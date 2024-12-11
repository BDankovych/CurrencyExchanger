import UIKit

protocol CoordinatorProtocol {
    var presenterVC : UIViewController { get set }
    
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    
    init(input: Input, presenterVC: UIViewController)
    var condinatorDidFinished: ((Result<Output, Error>) -> Void)? { get set }
    
    func start()
}
