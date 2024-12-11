import Combine
import Foundation

struct ExchangeCurrencyRequestModel {
    let from: String
    let to: String
    let amount: Double
}

struct ExchangeCurrencyResponseModel: Decodable {
    let amount: Double
}

protocol CurrenciesExhangerProtocol {
    func exhangeMoney(model: ExchangeCurrencyRequestModel) -> AnyPublisher<ExchangeCurrencyResponseModel, Error>
}
