import UIKit

class LoadingView: UIView {
    private var stackView: UIStackView!
    private let dotsCount: Int = 4
    
    private let dotsSize: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupDots()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setupDots()
    }
    
    private func setupStackView() {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = dotsSize / 2
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        
        let width = (dotsSize * 1.5 * CGFloat(dotsCount)) - (dotsSize / 2)
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant: width),
            stack.heightAnchor.constraint(equalTo: self.heightAnchor),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        
        self.stackView = stack
    }
    
    private func setupDots() {
        
        for _ in 0..<dotsCount {
            let view = UIView()
            view.clipsToBounds = true
            view.backgroundColor = .darkGray
            view.layer.cornerRadius = 10
            view.widthAnchor.constraint(equalToConstant: 20).isActive = true
            view.heightAnchor.constraint(equalToConstant: 20).isActive = true
            stackView.addArrangedSubview(view)
        }
    }
    
    
    func startAnimation() {
        let duration: Double = 1
        let delay = duration / Double(dotsCount - 1)
        
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            UIView.animate(withDuration: duration, delay: Double(index) * delay, options: [.repeat, .autoreverse]) {
                view.transform = CGAffineTransform(translationX: 0, y: -self.dotsSize)
            }
        }
    }
    
    func stopAnimation() {
        stackView.arrangedSubviews.forEach {
            $0.layer.removeAllAnimations()
            $0.transform = .identity
        }
    }
}
