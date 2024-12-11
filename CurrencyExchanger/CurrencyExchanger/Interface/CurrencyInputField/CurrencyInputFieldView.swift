import UIKit
import Combine

class CurrencyInputFieldView: UIView {
    private var titleLabel: UILabel!
    private var currencySymbolLabel: UILabel!
    private var amountField: UITextField!
    
    private var isFirstTimeEditing = true
    
    private var viewModel: CurrencyInputFieldViewModelProtocol!
    private var bag: Set<AnyCancellable> = []
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter
    }()
    
    init(viewModel: CurrencyInputFieldViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setup()
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("Use please init(viewModel: CurrencyInputFieldVMProtocol)")
    }
    
    private func setup() {
        setupTitleLabel()
        setupSymbolLabel()
        setupAmountInput()
        
        layer.borderWidth = 3
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        
        bind()
    }
    
    private func bind() {
        viewModel.symbolPublisher
            .assign(to: \.text!, on: currencySymbolLabel)
            .store(in: &bag)
        
        amountField.textPublisher()
            .debounce(for: 0.1, scheduler: DispatchQueue.global(qos: .userInteractive))
            .compactMap {
                self.formatter.number(from: $0)
            }.sink {
                self.viewModel.amountChangedPublisher.send($0.doubleValue)
            }.store(in: &bag)
    }
    
    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Amount"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        
        addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        
        self.titleLabel = titleLabel
    }
    
    private func setupSymbolLabel() {
        let symbolLabel = UILabel()
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        
        symbolLabel.text = ""
        symbolLabel.textColor = .black
        symbolLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        symbolLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        addSubview(symbolLabel)
        
        symbolLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 15).isActive = true
        symbolLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        symbolLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.currencySymbolLabel = symbolLabel
    }
    
    private func setupAmountInput() {
        let textField = UITextField()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        textField.font = .systemFont(ofSize: 16, weight: .bold)
        textField.borderStyle = .none
        textField.keyboardType = .decimalPad
        textField.text = formatter.string(from: 1.00)
        
        textField.leadingAnchor.constraint(equalTo: currencySymbolLabel.trailingAnchor, constant: 2).isActive = true
        textField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: currencySymbolLabel.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: currencySymbolLabel.heightAnchor).isActive = true
        
        self.amountField = textField
    }
}

extension CurrencyInputFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isFirstTimeEditing = false
        
        guard let text = textField.text else { return true }
        
        if string.contains(/[,.]/) && (text.contains(/[,.]/) || text.isEmpty) {
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isFirstTimeEditing {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if let number = formatter.number(from: text) {
            textField.text = formatter.string(from: number)
        } else {
            textField.text = formatter.string(from: 1.00)
        }
        
    }
}

