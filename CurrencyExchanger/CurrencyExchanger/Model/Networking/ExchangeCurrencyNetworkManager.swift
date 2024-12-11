import Foundation
import Combine

class ExchangeCurrencyNetworkManager: CurrenciesExhangerProtocol {
    let baseUrl: URL
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        baseUrl = URL(string: "http://api.evp.lt")!
    }
    
    func exhangeMoney(model: ExchangeCurrencyRequestModel) -> AnyPublisher<ExchangeCurrencyResponseModel, Error> {
        
        let url = baseUrl.appending(path: "/currency/commercial/exchange/\(model.amount)-\(model.from)/\(model.to)/latest")
        
        return  URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .mapError { error in
                return DefaultError.somethingWrong
            }
            .decode(type: NetworkExchangeResponse.self, decoder: JSONDecoder())
            .map {
                return ExchangeCurrencyResponseModel(amount: $0.amount)
            }
            .eraseToAnyPublisher()
    }
}

fileprivate struct NetworkExchangeResponse: Codable {
    
    let amount: Double
    
    private enum CodingKeys: String, CodingKey {
        case amount
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let amountStr = try container.decode(String.self, forKey: .amount)

        if let value = Double(amountStr) {
            self.amount = value
        } else {
            throw DefaultError.wrongData
        }
    }
}

enum DefaultError: Error, LocalizedError {
    case wrongData
    case somethingWrong
    
    var errorDescription: String? {
        switch self {
        case .wrongData:
            return "Wrong data format"
        case .somethingWrong:
            return "Something went wrong. Please try again later"
        }
    }
}
