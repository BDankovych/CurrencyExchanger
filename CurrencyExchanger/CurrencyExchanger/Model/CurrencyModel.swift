import Foundation

struct Currency {
    let country: String
    let code: String
    let symbol: String
    let name: String
    let flag: String
}

protocol CurrenciesListDataProvider {
    func getCurrencies(handler: @escaping ([Currency]) -> Void)
}

class CurrencyStorage: CurrenciesListDataProvider {
    
    func getCurrencies(handler: @escaping ([Currency]) -> Void) {
        let result = getCurrencies()
        handler(result)
    }
    
    static let shared = CurrencyStorage()
    
    func getCurrencies() -> [Currency] {
        return [
            Currency(country: "US", code: "USD", symbol: "$", name: "US Dollar", flag: "Germany"),
            Currency(country: "Grait Britain", code: "CBP", symbol: "&", name: "British Pound", flag: "Germany"),
            Currency(country: "Ukraine", code: "UA", symbol: "#", name: "BDAHS", flag: "Germany"),
            Currency(country: "Poland", code: "ZLT", symbol: "$", name: "Zloty", flag: "Germany")
        ]
    }
}
