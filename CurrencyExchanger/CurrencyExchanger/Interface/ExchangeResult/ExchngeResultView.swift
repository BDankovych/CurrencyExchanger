import UIKit
import Combine

class ExchngeResultView: UIView {
    
    private var resultLabel: UILabel!
    private var loadingView: LoadingView!
    
    private var viewModel: ExchngeResultViewModelProtocol
    private var bag = Set<AnyCancellable>()
    
    
    init(viewModel: ExchngeResultViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("please use init(viewModel: ExchngeResultViewModelProtocol)")
    }
    
    private func setup() {
        setupResultLabel()
        setupLoadingView()
        bind()
    }
    
    private func setupResultLabel() {
        let resultLabel = UILabel()
        resultLabel.isHidden = true
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        resultLabel.text = ""
        resultLabel.numberOfLines = 0
        
        addSubview(resultLabel)
        
        resultLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        resultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        resultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        resultLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.resultLabel = resultLabel
    }
    
    private func setupLoadingView() {
        let loadingView = LoadingView()
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loadingView)
        
        loadingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.loadingView = loadingView
    }
    
    private func bind() {
        viewModel.resultPublisher.sink { [weak self] result in
            self?.configure(model: result)
        }.store(in: &bag)
    }
    
    private func configure(model: ExchangeResultState) {
        DispatchQueue.main.async { [self] in
            switch model {
            case .loading:
                resultLabel.isHidden = true
                loadingView.isHidden = false
                loadingView.startAnimation()
            case .none:
                resultLabel.isHidden = true
                loadingView.isHidden = true
                loadingView.stopAnimation()
            case .result(let exchangeResult):
                resultLabel.isHidden = false
                loadingView.isHidden = true
                loadingView.stopAnimation()
                configureResultLabel(result: exchangeResult)
            }
        }
    }
    
    private func configureResultLabel(result: ExchangeResult) {
        let str1 = NSAttributedString(
            string: String(format: "%0.2f ", result.fromAmount),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ])
        
        let str2 = NSAttributedString(
            string: "\(result.from)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        
        let str3 = NSAttributedString(
            string: " = \n",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ])
        
        let str4 = NSAttributedString(
            string: String(format: "%0.2f ", result.toAmount),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ])
        
        let str5 = NSAttributedString(
            string: result.to,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        
        resultLabel.attributedText = str1 + str2 + str3 + str4 + str5
    }
}

