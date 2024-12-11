import Foundation

protocol CurrenciesListDataProvider {
    func getCurrencies(handler: @escaping ([Currency]) -> Void)
}
