import Foundation

class CurrencyStorage: CurrenciesListDataProvider {
    
    static let shared = CurrencyStorage()
    
    func getCurrencies(handler: @escaping ([Currency]) -> Void) {
        handler(currencies)
    }
    
    private lazy var currencies: [Currency] = {
        
        if let path = Bundle.main.path(forResource: "CurrenciesList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONDecoder().decode(CurrenciesList.self, from: data)
                
                return result.currencies
            } catch {
                return []
            }
        } else {
            return []
        }
    }()
    
    var defaultFrom: Currency {
        currencies[0]
    }
    
    var defaultTo: Currency {
        currencies[1]
    }
}

fileprivate struct CurrenciesList: Decodable {
    let currencies: [Currency]
}
