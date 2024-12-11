import Combine

protocol CurrencySelectionViewModelDelegate: AnyObject {
    func changeCurrencyRequested(viewModel: CurrencySelectionViewModelProtocol, changeHanler:  @escaping (Currency) -> Void)
}

protocol CurrencySelectionViewModelProtocol {
    func changeCurrencyPressed()
    var currencyPublisher: Published<Currency>.Publisher { get }
    func set(currency: Currency)
    
    var delegate: CurrencySelectionViewModelDelegate? { get set }
}

class CurrencySelectionViewModel: CurrencySelectionViewModelProtocol {
    var currencyPublisher: Published<Currency>.Publisher { $currency }
    @Published private var currency: Currency
    
    weak var delegate: CurrencySelectionViewModelDelegate?
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func changeCurrencyPressed() {
        delegate?.changeCurrencyRequested(viewModel: self, changeHanler: { [weak self] newValue in
            self?.currency = newValue
        })
    }
    
    func set(currency: Currency) {
        self.currency = currency
    }
}
