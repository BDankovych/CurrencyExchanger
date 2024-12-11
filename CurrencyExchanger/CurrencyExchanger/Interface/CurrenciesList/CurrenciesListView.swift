import UIKit
import Combine

class CurrenciesListView: UIViewController {
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var currencies: [Currency] = []
    
    private var viewModel: CurrenciesListViewModelProtocol
    
    init(viewModel: CurrenciesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("please use init(viewModel: CurrenciesListViewModelProtocol)")
    }
    
    private var bag = Set<AnyCancellable>()
    private var searchPublisher = PassthroughSubject<String, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        currencies = CurrencyStorage.shared.getCurrencies()
        setupSearchBar()
        setupSearchPublisher()
        setupTableView()
        bind()
    }
    
    private func bind() {
        viewModel.currenciesPublisger.sink { [weak self] currencies in
            self?.currencies = currencies
            self?.tableView.reloadData()
        }.store(in: &bag)
    }
    
    private func setupSearchPublisher() {
        searchPublisher
            .debounce(for: 0.1, scheduler: DispatchQueue.global(qos: .userInteractive))
            .receive(on: RunLoop.main)
            .sink { [weak self] query in
                self?.viewModel.searchChanged(query: query)
            }
            .store(in: &bag)
    }
    
    private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        self.searchBar = searchBar

    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        tableView.separatorStyle = .singleLine
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView = tableView
    }
}

extension CurrenciesListView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPublisher.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}


extension CurrenciesListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as! CurrencyTableViewCell
        let model = currencies[indexPath.row]
        cell.configure(with: model)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencies[indexPath.row]
        viewModel.currencySelected(currency: currency)
    }
}
