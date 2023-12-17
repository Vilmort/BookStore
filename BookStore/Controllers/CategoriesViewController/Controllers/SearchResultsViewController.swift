//
//  SearchResultsViewController.swift
//  BookStore
//
//  Created by Alex  on 16.12.2023.
//

import UIKit
import OpenLibraryKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	var searchResults: [SearchResult] = []
	private let tableView = UITableView()
    private let openLibraryService = OpenLibraryService()
     var searchAuthorResults: [AuthorSearchResult] = []
    private var ifFilterIsOn = false
    
	lazy var filterButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "filterIcon"), for: .normal)
		button.addTarget(self, action: #selector(sortedResult), for: .touchUpInside)
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupTableView()
		view.addSubview(tableView)
		view.addSubview(filterButton)
		//print(searchResults)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		filterButton.snp.makeConstraints { make in
			 make.trailing.equalToSuperview().offset(-20)
			 make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
		 }
		 tableView.snp.makeConstraints { make in
			 make.top.equalTo(filterButton.snp.bottom).offset(20)
			 make.leading.trailing.bottom.equalToSuperview()
		 }
	}
    
    private func setupTableViewSection() -> Int {
        if ifFilterIsOn {
            return searchAuthorResults.count
        } else  {
            return searchResults.count
        }
    }
    
    private func removeSubstringFromWorks(_ input: String) -> String {
         return input.replacingOccurrences(of: "/works/", with: "")
     }
    

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return setupTableViewSection()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        if ifFilterIsOn {
            let result = searchAuthorResults[indexPath.row]
            cell.textLabel?.text = result.key
        } else {
            let result = searchResults[indexPath.row]
            cell.textLabel?.text = result.title
        }
		return cell
	}

	// MARK: - UITableViewDelegate

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ifFilterIsOn {
            let result = searchAuthorResults[indexPath.row]
        } else {
            let result = searchResults[indexPath.row]
            let id = removeSubstringFromWorks(result.key)
            let vc = BookDescriptionViewController(bookId: id )
            navigationController?.pushViewController(vc, animated: true)
        }
	}

	func updateSearchResults(results: [SearchResult]) {
		searchResults = results
		tableView.reloadData()
	}

	private func setupTableView() {
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
	}

	@objc func sortedResult() {
        if ifFilterIsOn {
            filterButton.backgroundColor = .clear
        } else  {
            filterButton.backgroundColor = . red
        }
        ifFilterIsOn.toggle()
        tableView.reloadData()
	}
}
