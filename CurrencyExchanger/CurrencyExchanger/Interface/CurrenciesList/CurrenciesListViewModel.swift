import Combine

protocol CurrenciesListViewModelProtocol {
    
    var currenciesPublisger: Published<[Currency]>.Publisher { get }
    
    func searchChanged(query: String)
    func currencySelected(currency: Currency)
    
    init(dataProvider: CurrenciesListDataProvider, coordinator: any CurrenciesListCoordinatorProtocol)
}

class CurrenciesListViewModel: CurrenciesListViewModelProtocol {
    
    var currenciesPublisger: Published<[Currency]>.Publisher { $currenciesFilteredList }
    @Published private var currenciesFilteredList: [Currency]
    
    private var allCurrencies: [Currency]
    private var coordinator: any CurrenciesListCoordinatorProtocol
    
    required init(dataProvider: CurrenciesListDataProvider, coordinator: any CurrenciesListCoordinatorProtocol) {
        self.coordinator = coordinator
        self.currenciesFilteredList = []
        self.allCurrencies = []
        
        dataProvider.getCurrencies { [weak self] currencies in
            self?.allCurrencies = currencies
            self?.currenciesFilteredList = currencies
        }
    }
    
    func searchChanged(query: String) {
        if query.isEmpty {
            currenciesFilteredList = allCurrencies
        } else {
            currenciesFilteredList = allCurrencies.filter {
                $0.name.contains(query)
            }
        }
    }
    
    func currencySelected(currency: Currency) {
        coordinator.close(with: currency)
    }
}

