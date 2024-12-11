import Combine

protocol CurrencyExchangeSelectorViewModelDelegate: AnyObject {
    func changeCurrencyRequested(changeHanler: @escaping (Currency) -> Void)
}

protocol CurrencyExchangeSelectorViewModelProtocol {
    
    var fromCurrency: Currency { get }
    var toCurrency: Currency { get }

    func getFromCurrencyVM() -> CurrencySelectionViewModelProtocol
    func getToCurrencyVM() -> CurrencySelectionViewModelProtocol
    
    func swapPressed()
    var currenciesChangedSubject: PassthroughSubject<(Currency, Currency), Never> { get }
}

class CurrencyExchangeSelectorViewModel: CurrencyExchangeSelectorViewModelProtocol {
    
    var fromCurrency: Currency
    var toCurrency: Currency
    
    var currenciesChangedSubject: PassthroughSubject<(Currency, Currency), Never>
    
    private var fromCurrencyVM: CurrencySelectionViewModel
    private var toCurrencyVM: CurrencySelectionViewModel
    
    weak var delegate: CurrencyExchangeSelectorViewModelDelegate?
    private var bag = Set<AnyCancellable>()
            
    init(fromCurrency: Currency, toCurrency: Currency) {
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        
        self.currenciesChangedSubject = PassthroughSubject<(Currency, Currency), Never>()
        
        fromCurrencyVM = CurrencySelectionViewModel(currency: fromCurrency)
        toCurrencyVM = CurrencySelectionViewModel(currency: toCurrency)
        
        fromCurrencyVM.delegate = self
        toCurrencyVM.delegate = self
        
        bind()
    }
    
    func getFromCurrencyVM() -> CurrencySelectionViewModelProtocol {
        fromCurrencyVM
    }
    
    func getToCurrencyVM() -> CurrencySelectionViewModelProtocol {
        toCurrencyVM
    }
    
    private func bind() {
        fromCurrencyVM.currencyPublisher.sink { [self] in
            fromCurrency = $0
            updateCurrencies()
        }.store(in: &bag)
        
        toCurrencyVM.currencyPublisher.sink { [self] in
            toCurrency = $0
            updateCurrencies()
        }.store(in: &bag)
    }
    
    func swapPressed() {
        swap(&fromCurrency, &toCurrency)
        fromCurrencyVM.set(currency: fromCurrency)
        toCurrencyVM.set(currency: toCurrency)
        
        updateCurrencies()
    }
    
    private func updateCurrencies() {
        currenciesChangedSubject.send((fromCurrency, toCurrency))
    }
}

extension CurrencyExchangeSelectorViewModel: CurrencySelectionViewModelDelegate {
    func changeCurrencyRequested(viewModel: CurrencySelectionViewModelProtocol, changeHanler: @escaping (Currency) -> Void) {
        delegate?.changeCurrencyRequested {
            viewModel.set(currency: $0)
        }
    }
}
