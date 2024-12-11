import Combine

protocol ExchangeViewModelProtocol {
    
    var amount: Double { get }
    var from: Currency { get }
    var to: Currency { get }
    
    func getImputViewModel() -> CurrencyInputFieldViewModelProtocol
    func getExchangeSelectorViewModel() -> CurrencyExchangeSelectorViewModelProtocol
    func getResultViewModel() -> ExchngeResultViewModelProtocol
}


class ExchangeViewModel: ExchangeViewModelProtocol {
    
    var amount: Double
    var from: Currency
    var to: Currency
    
    private var inputViewModel: CurrencyInputFieldViewModel
    private var exchangeSelectorViewModel: CurrencyExchangeSelectorViewModel
    private var resultViewModel: ExchngeResultViewModel
    
    private var coordinator: any ExchangeViewCoordinatorProtocol
    
    private var bag = Set<AnyCancellable>()
    
    init(amount: Double, from: Currency, to: Currency, coordinator: any ExchangeViewCoordinatorProtocol) {
        self.amount = amount
        self.from = from
        self.to = to
        self.coordinator = coordinator
        
        self.inputViewModel = CurrencyInputFieldViewModel(symbol: from.symbol)
        self.exchangeSelectorViewModel = CurrencyExchangeSelectorViewModel(fromCurrency: from, toCurrency: to)
        self.resultViewModel = ExchngeResultViewModel(result: .none)
        
        bind()
    }
    
    func getImputViewModel() -> CurrencyInputFieldViewModelProtocol {
        inputViewModel
    }
    
    func getExchangeSelectorViewModel() -> CurrencyExchangeSelectorViewModelProtocol {
        exchangeSelectorViewModel
    }
    
    func getResultViewModel() -> ExchngeResultViewModelProtocol {
        resultViewModel
    }
    
    private func bind() {
        inputViewModel.amountChangedPublisher
        .sink { [weak self] amount in
            self?.amount = amount
            self?.updateExchange()
        }.store(in: &bag)
        
        exchangeSelectorViewModel.currenciesChangedSubject
        .sink { [weak self] from, to in
            guard let self else { return }
            self.from = from
            self.to = to
            self.updateSymbol()
            self.updateExchange()
        }.store(in: &bag)
        
        exchangeSelectorViewModel.delegate = self
    }
    
    private func updateExchange() {
        print("Updating..")
        
        let res = ExchangeResult(from: from.name, to: to.name, fromAmount: amount, toAmount: 100)
        
        resultViewModel.update(result: .resut(res))
    }
    
    private func updateSymbol() {
        inputViewModel.symbol = from.symbol
    }
    
}

extension ExchangeViewModel: CurrencyExchangeSelectorViewModelDelegate {
    func changeCurrencyRequested(changeHanler: @escaping (Currency) -> Void) {
        coordinator.changeCurrencyRequested(changeHanler: changeHanler)
    }
}
