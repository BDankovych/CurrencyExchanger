import UIKit
import Combine

class ViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        let inputViewModel = CurrencyInputFieldViewModel(symbol: "$")
        
        let input = CurrencyInputFieldView(viewModel: inputViewModel)
        
        inputViewModel.amountChangedPublisher
        .sink { amount in
            print(amount)
        }.store(in: &bag)
        
        input.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(input)
        
        NSLayoutConstraint.activate([
            input.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            input.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
        ])
    }

}

