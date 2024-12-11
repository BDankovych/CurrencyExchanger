import UIKit

protocol CurrenciesListCoordinatorProtocol: CoordinatorProtocol {
    func close(with currency: Currency)
}

class CurrenciesListCoordinator: CurrenciesListCoordinatorProtocol {
    typealias Input = CoordinatorInput
    typealias Output = CoordinatorOutput
    
    var presenterVC: UIViewController
    var input: CoordinatorInput
    
    var condinatorDidFinished: ((Result<CoordinatorOutput, any Error>) -> Void)?
    private var childVC: UIViewController?
    
    func start() {
        let viewModel = CurrenciesListViewModel(dataProvider: input.dataProvider, coordinator: self)
        let vc = CurrenciesListView(viewModel: viewModel)
        vc.modalPresentationStyle = .pageSheet
        presenterVC.present(vc, animated: true)
        childVC = vc
    }
    
    required init(input: CoordinatorInput, presenterVC: UIViewController) {
        self.input = input
        self.presenterVC = presenterVC
    }
    
    func close(with currency: Currency) {
        condinatorDidFinished?(.success(.init(selectedCurrency: currency)))
        childVC?.dismiss(animated: true)
    }
}

extension CurrenciesListCoordinator {
    struct CoordinatorInput {
        var dataProvider: CurrenciesListDataProvider
    }
    
    struct CoordinatorOutput {
        var selectedCurrency: Currency
    }
}
