import UIKit
import Combine

class AppCoordinator: CoordinatorProtocol {
    typealias Input = Void
    typealias Output = Void
    var input: Void
    
    var condinatorDidFinished: ((Result<Void, any Error>) -> Void)?
    var presenterVC: UIViewController
    
    required init(input: Void, presenterVC: UIViewController) {
        self.presenterVC = presenterVC
        presenterVC.view.backgroundColor = .white
    }
    
    func start() {
        let from = CurrencyStorage.shared.defaultFrom
        let to = CurrencyStorage.shared.defaultTo
        let input = ExchangeCurrencyCoordinator.CoordinatorInput(amount: 1.00, from: from, to: to)
        let exhangeCoordinator = ExchangeCurrencyCoordinator(input: input, presenterVC: presenterVC)
        exhangeCoordinator.start()
    }

}

