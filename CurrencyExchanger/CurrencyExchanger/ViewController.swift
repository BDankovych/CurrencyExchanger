import UIKit
import Combine

class ViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let input = CurrenciesListCoordinator.Input(dataProvider: CurrencyStorage.shared)
        
        let coordinator = CurrenciesListCoordinator(input: input, presenterVC: self)
        coordinator.condinatorDidFinished = {
            print($0)
            switch $0 {
            case .success(let output):
                print(output.selectedCurrency)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        coordinator.start()
    }

}

