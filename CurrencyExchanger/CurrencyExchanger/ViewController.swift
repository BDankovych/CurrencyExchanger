import UIKit
import Combine

class ViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let inputViewModel = CurrencyInputFieldViewModel(symbol: "$")
//        
//        let input = CurrencyInputFieldView(viewModel: inputViewModel)
//        
//        inputViewModel.amountChangedPublisher
//        .sink { amount in
//            print(amount)
//        }.store(in: &bag)
//        
//        input.translatesAutoresizingMaskIntoConstraints = false
        
        let animation = LoadingView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animation)
        
        NSLayoutConstraint.activate([
            animation.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            animation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            animation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            animation.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            animation.startAnimation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            animation.stopAnimation()
        }
    }

}

