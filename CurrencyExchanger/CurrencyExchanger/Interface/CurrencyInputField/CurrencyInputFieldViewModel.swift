import Combine

protocol CurrencyInputFieldViewModelProtocol {
    var amountChangedPublisher: PassthroughSubject<Double, Never> { get }
    var symbolPublisher: Published<String>.Publisher { get }
}

class CurrencyInputFieldViewModel: CurrencyInputFieldViewModelProtocol {
    var symbolPublisher: Published<String>.Publisher { $symbol }
    @Published var symbol: String
    private(set) var amountChangedPublisher: PassthroughSubject<Double, Never>
        
    private var bag: Set<AnyCancellable> = []
    
    init(symbol: String) {
        self.symbol = symbol
        self.amountChangedPublisher = PassthroughSubject()
    }
}
