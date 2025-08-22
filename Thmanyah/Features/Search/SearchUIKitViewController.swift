//
//  SearchUIKitViewController.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import UIKit
import Combine

final class SearchUIKitViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SearchUIKitViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadingView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshSearchBarAppearance()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "بحث"
    
        view.backgroundColor = UIColor(AppTheme.bg)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        
        searchBar.delegate = self
        searchBar.placeholder = "ابحث..."
        searchBar.searchBarStyle = .minimal
        
        searchBar.backgroundColor = UIColor(AppTheme.searchBarBackground)
        searchBar.barTintColor = UIColor(AppTheme.searchBarBackground)
        searchBar.tintColor = UIColor(AppTheme.searchBarText)
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = UIColor(AppTheme.searchBarBackground)
        textField.textColor = UIColor(AppTheme.searchBarText)
        textField.attributedPlaceholder = NSAttributedString(
            string:"ابحث...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(AppTheme.searchBarPlaceholder)]
        )
        
        if let font = AppTheme.uiFont(16, weight: .regular) {
            textField.font = font
        }
        
        if let leftView = textField.leftView {
            leftView.tintColor = UIColor(AppTheme.searchBarPlaceholder)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        tableView.sectionFooterHeight = 12
        tableView.sectionHeaderHeight = 0
        
        tableView.backgroundColor = UIColor(AppTheme.bg)
        
        refreshSearchBarAppearance()
    }
    
    private func refreshSearchBarAppearance() {
        searchBar.backgroundColor = UIColor(AppTheme.searchBarBackground)
        searchBar.barTintColor = UIColor(AppTheme.searchBarBackground)
        searchBar.tintColor = UIColor(AppTheme.searchBarText)
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = UIColor(AppTheme.searchBarBackground)
        textField.textColor = UIColor(AppTheme.searchBarText)
        textField.attributedPlaceholder = NSAttributedString(
            string: "ابحث…",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(AppTheme.searchBarPlaceholder)]
        )
        
        if let font = AppTheme.uiFont(16, weight: .regular) {
            textField.font = font
        }
        
        // Customize left view (search icon)
        if let leftView = textField.leftView {
            leftView.tintColor = UIColor(AppTheme.searchBarPlaceholder)
        }
    }
    
    private func setupBindings() {
        viewModel.$query
            .receive(on: DispatchQueue.main)
            .sink { [weak self] query in
                self?.searchBar.text = query
            }
            .store(in: &cancellables)
        
        viewModel.$results
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        viewModel.$isSearching
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSearching in
                if isSearching {
                    self?.loadingView.isHidden  = false
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.isHidden  = true

                    self?.loadingView.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
      print(errorMessage)
                } else {
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateUI() {
        let hasResults = !viewModel.results.isEmpty
        let hasQuery = !viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        tableView.isHidden = !hasResults
        tableView.reloadData()
    }
}

extension SearchUIKitViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchUIKitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: IndexPath(row: indexPath.row, section: 0)) as! ContentTableViewCell
        let item = viewModel.results[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

extension SearchUIKitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.results.isEmpty ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !viewModel.results.isEmpty else { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = "نتائج البحث"
        titleLabel.font = AppTheme.uiFont(20, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.accessibilityIdentifier = "نتائج البحث"
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}


