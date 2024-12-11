import UIKit
import Combine

class ViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let from = Currency(country: "US", code: "USD", symbol: "$", name: "US Dollar", flag: "Germany")
        let to = Currency(country: "Grait Britain", code: "CBP", symbol: "&", name: "British Pound", flag: "Germany")
        let input = ExchangeCurrencyCoordinator.CoordinatorInput(amount: 1.00, from: from, to: to)
        
        let exhangeCoordinator = ExchangeCurrencyCoordinator(input: input, presenterVC: self)
        
        exhangeCoordinator.start()
    }

}

