import UIKit

protocol ExchangeViewCoordinatorProtocol: CoordinatorProtocol {
    func show(error: Error)
    func changeCurrencyRequested(changeHanler: @escaping (Currency) -> Void)
}

class ExchangeCurrencyCoordinator: ExchangeViewCoordinatorProtocol {
    typealias Input = CoordinatorInput
    typealias Output = CoordinatorOutput
        
    var presenterVC: UIViewController
    var input: CoordinatorInput
    
    var condinatorDidFinished: ((Result<CoordinatorOutput, any Error>) -> Void)?
    
    
    private var childVC: UIViewController?
    
    func start() {
        let viewModel = ExchangeViewModel(amount: input.amount, from: input.from, to: input.to, coordinator: self)
        let vc = ExchangeView(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen
        presenterVC.present(vc, animated: false)
        childVC = vc
    }
    
    required init(input: CoordinatorInput, presenterVC: UIViewController) {
        self.input = input
        self.presenterVC = presenterVC
    }
    
    func show(error: any Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        childVC?.present(alert, animated: true)
    }
    
    func changeCurrencyRequested(changeHanler: @escaping (Currency) -> Void) {
        guard let childVC = self.childVC else { return }
        let input = CurrenciesListCoordinator.Input(dataProvider: CurrencyStorage.shared)
        
        let coordinator = CurrenciesListCoordinator(input: input, presenterVC: childVC)
        coordinator.condinatorDidFinished = {
            print($0)
            switch $0 {
            case .success(let output):
                changeHanler(output.selectedCurrency)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        coordinator.start()
    }
}

extension ExchangeCurrencyCoordinator {
    struct CoordinatorInput {
        var amount: Double
        var from: Currency
        var to: Currency
    }
    
    struct CoordinatorOutput {
        
    }
}
