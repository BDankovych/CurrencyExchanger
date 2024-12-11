import Combine

struct ExchangeResult {
    var from: String
    var to: String
    var fromAmount: Double
    var toAmount: Double
}

enum ExchangeResultState {
    case loading
    case error
    case resut(ExchangeResult)
}

protocol ExchngeResultViewModelProtocol {
    var symbolPublisher: Published<ExchangeResultState>.Publisher { get }
    func update(result: ExchangeResultState)
}

class ExchngeResultViewModel: ExchngeResultViewModelProtocol {
    var symbolPublisher: Published<ExchangeResultState>.Publisher { $result }
    @Published var result: ExchangeResultState
    
    init(result: ExchangeResultState) {
        self.result = result
    }
    
    func update(result: ExchangeResultState) {
        self.result = result
    }
}
