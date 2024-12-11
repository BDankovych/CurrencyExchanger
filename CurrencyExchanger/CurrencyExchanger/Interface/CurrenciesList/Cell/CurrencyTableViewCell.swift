import UIKit

class CurrencyTableViewCell: UITableViewCell {
    private var flagImageView: UIImageView!
    private var currencyTitleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flagImageView.image = nil
        currencyTitleLabel.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupFlagImageView()
        setupCurrencyLabel()
    }
    
    private func setupFlagImageView() {
        let countryFlagImageView = UIImageView()
        countryFlagImageView.translatesAutoresizingMaskIntoConstraints = false
        countryFlagImageView.contentMode = .scaleAspectFit
        
        addSubview(countryFlagImageView)
        
        countryFlagImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        countryFlagImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        countryFlagImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        countryFlagImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        countryFlagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        self.flagImageView = countryFlagImageView
    }
    
    private func setupCurrencyLabel() {
        let currencyLabel = UILabel()
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currencyLabel.text = ""
        
        addSubview(currencyLabel)
        
        currencyLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 15).isActive = true
        currencyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        currencyLabel.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor).isActive = true
        
        self.currencyTitleLabel = currencyLabel
    }
    
    func configure(with model: Currency) {
        let currencyCodeString = NSAttributedString(
            string: model.code,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        
        let currencyNameString = NSAttributedString(
            string: " - " + model.name,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        
        currencyTitleLabel.attributedText = currencyCodeString + currencyNameString
        flagImageView.image = UIImage(named: model.flag)
    }
}
