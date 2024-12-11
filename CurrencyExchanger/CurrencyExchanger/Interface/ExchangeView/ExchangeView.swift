import UIKit

class ExchangeView: UIViewController {
    
    private var viewModel: ExchangeViewModelProtocol
    
    private var input: CurrencyInputFieldView!
    private var exchangeView: CurrencyExchangeSelectorView!
    private var resultView: ExchngeResultView!
    
    init(viewModel: ExchangeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("please use init(viewModel: ExchangeViewModelProtocol)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        setup()
    }
    
    
    private func setup() {
        setupInputView()
        setupExhangeSelectorView()
        setupResultView()
        setupEndEditingGesture()
        bind()
    }
    
    private func bind() {
        
    }
    
    private func setupInputView() {
        let input = CurrencyInputFieldView(viewModel: viewModel.getImputViewModel())
        
        input.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(input)
        
        NSLayoutConstraint.activate([
            input.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            input.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
        ])
        
        self.input = input
    }
    
    private func setupExhangeSelectorView() {
        let exchangeView = CurrencyExchangeSelectorView(viewModel: viewModel.getExchangeSelectorViewModel())
        exchangeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exchangeView)
        
        NSLayoutConstraint.activate([
            exchangeView.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 10),
            exchangeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            exchangeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
        ])
        
        self.exchangeView = exchangeView
    }
    
    private func setupResultView() {
        let resultView = ExchngeResultView(viewModel: viewModel.getResultViewModel())
        resultView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultView)
        
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: exchangeView.bottomAnchor, constant: 10),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            resultView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        self.resultView = resultView
    }
    
    private func setupEndEditingGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
