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
        
        let resultVM = ExchngeResultViewModel(result: .loading)
        let resultView = ExchngeResultView(viewModel: resultVM)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(resultView)
    
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            resultView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            resultVM.update(result: .resut(.init(from: "USD", to: "GBP", fromAmount: 1.00, toAmount: 30.00)))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            resultVM.update(result: .error)
        }
        
//        let animation = LoadingView()
//        animation.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(animation)
//        
//        NSLayoutConstraint.activate([
//            animation.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            animation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
//            animation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
//            animation.heightAnchor.constraint(equalToConstant: 80)
//        ])
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            animation.startAnimation()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
////            animation.stopAnimation()
//        }
    }

}

