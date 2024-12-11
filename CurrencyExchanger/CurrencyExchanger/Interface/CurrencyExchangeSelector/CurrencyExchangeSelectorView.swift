import UIKit

class CurrencyExchangeSelectorView: UIView {
    
    private var fromCurrencyView: CurrencySelectionView!
    private var toCurrencyView: CurrencySelectionView!
    
    private var viewModel: CurrencyExchangeSelectorViewModelProtocol
    
    init(viewModel: CurrencyExchangeSelectorViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("Please use init(viewModel: CurrencyExchangeSelectorVMProtocol)")
    }
    private func setup() {
        setupCurrenciesView()
        setupChangeCurrenciesButton()
    }
    
    private func setupCurrenciesView() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.fromCurrencyView = CurrencySelectionView(type: .from, mode: .left, viewModel: viewModel.getFromCurrencyVM() )
        fromCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        self.toCurrencyView = CurrencySelectionView(type: .to, mode: .right, viewModel: viewModel.getToCurrencyVM())
        toCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(fromCurrencyView)
        stack.addArrangedSubview(toCurrencyView)
    }
    
    private func setupChangeCurrenciesButton() {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonSize: CGFloat = 25
        button.layer.cornerRadius = buttonSize / 2
        button.backgroundColor = .white
        
        button.clipsToBounds = true
        button.setImage(UIImage(named:"change_button"), for: .normal)
        button.addTarget(self, action: #selector(changePressed), for: .touchUpInside)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: buttonSize),
            button.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
    
    @objc private func changePressed() {
        viewModel.swapPressed()
    }
}
