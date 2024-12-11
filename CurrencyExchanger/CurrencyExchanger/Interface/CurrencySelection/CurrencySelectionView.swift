import UIKit
import Combine

class CurrencySelectionView: UIView {
    var titleLabel: UILabel!
    var flagImageView: UIImageView!
    var currencyLabel: UILabel!
    
    private var fieldType: FieldType!
    private var mode: Mode!

    private var viewModel: CurrencySelectionViewModelProtocol!
    private var bag: Set<AnyCancellable> = []
    
    init(type: FieldType, mode: Mode, viewModel: CurrencySelectionViewModelProtocol) {
        self.fieldType = type
        self.mode = mode
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Use please init(type: FieldType, mode: Mode, viewModel: CurrencySelectionViewModelProtocol)")
    }
    
    private func setup() {
        setupTitleLabel()
        setupFlagImageView()
        setupCurrencyLabel()
        addTapGesture()
        
        layer.borderWidth = 3
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        bind()
    }
    
    private func bind() {
        viewModel.currencyPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] currency in
                self?.configure(model: currency)
            }.store(in: &bag)
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectCyrrencyPressed))
        self.addGestureRecognizer(tap)
    }
    
    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = ""
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        
        addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: mode.leadingConstraint).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -mode.trailingConstraint).isActive = true
        
        self.titleLabel = titleLabel
    }
    
    private func setupFlagImageView() {
        let countryFlagImageView = UIImageView()
        countryFlagImageView.translatesAutoresizingMaskIntoConstraints = false
        countryFlagImageView.contentMode = .scaleAspectFit
        
        addSubview(countryFlagImageView)
        
        countryFlagImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        countryFlagImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        
        countryFlagImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        countryFlagImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        countryFlagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.flagImageView = countryFlagImageView
    }
    
    private func setupCurrencyLabel() {
        let currencyLabel = UILabel()
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currencyLabel.text = ""
        
        addSubview(currencyLabel)
        
        currencyLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 2).isActive = true
        currencyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        currencyLabel.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor).isActive = true
        
        self.currencyLabel = currencyLabel
    }
    
    private func configureCurrencyString(code: String, name: String) {
        let currencyCodeString = NSAttributedString(
            string: code,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        
        let currencyNameString = NSAttributedString(
            string: " - " + name,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        
        currencyLabel.attributedText = currencyCodeString + currencyNameString
    }
    
    private func configure(model: Currency) {
        titleLabel.text = fieldType.rawValue.uppercased()
        configureCurrencyString(code: model.code, name: model.name)
        flagImageView.image = UIImage(named: model.flag)
    }
    
    @objc private func selectCyrrencyPressed() {
        viewModel.changeCurrencyPressed()
    }
}

extension CurrencySelectionView {
    enum FieldType: String, CaseIterable {
        case from
        case to
    }
}

extension CurrencySelectionView {
    enum Mode {
        case normal
        case left
        case right
        
        
        var leadingConstraint: CGFloat {
            switch self {
            case .normal, .left: return 10
            case .right: return 15
            }
        }
        
        var trailingConstraint: CGFloat {
            switch self {
            case .left: return 15
            case .right, .normal: return 10
            }
        }
    }
}
