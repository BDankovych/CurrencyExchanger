import UIKit
import Combine

class ViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    let manager = ExchangeCurrencyNetworkManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let from = CurrencyStorage.shared.defaultFrom
        let to = CurrencyStorage.shared.defaultTo
        let input = ExchangeCurrencyCoordinator.CoordinatorInput(amount: 1.00, from: from, to: to)
        
        let exhangeCoordinator = ExchangeCurrencyCoordinator(input: input, presenterVC: self)
        
        exhangeCoordinator.start()
    }

}

