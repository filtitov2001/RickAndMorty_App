//
//  CharactersTableViewController.swift
//  RickAndMorty_App
//
//  Created by Felix Titov on 7/26/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class CharacterTableViewController: UITableViewController {
    
    //MARK: Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var rickAndMorty: RickAndMorty?
    private var filteredCharacter: [Character] = []
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 70
        tableView.backgroundColor = .black
        
        setupNavigationBar()
        setupSearchController()
        fetchData(from: Link.rickAndMortyApi.rawValue)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredCharacter.count : rickAndMorty?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let character = isFiltering ? filteredCharacter[indexPath.row] : rickAndMorty?.results[indexPath.row]
        cell.configure(with: character)
    
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let character = isFiltering ? filteredCharacter[indexPath.row] : rickAndMorty?.results[indexPath.row]
        
        guard let detailVC = segue.destination as? CharacterDetailsViewController else { return }
        detailVC.character = character
    }
    
    private func fetchData(from url: String?) {
        NetworkManager.shared.fetchData(from: url) { rickAndMorty in
            self.rickAndMorty = rickAndMorty
            self.tableView.reloadData()
        }
    }

    @IBAction func updateData(_ sender: UIBarButtonItem) {
        sender.tag == 1
            ? fetchData(from: rickAndMorty?.info.next)
            : fetchData(from: rickAndMorty?.info.prev)
    }
}

extension CharacterTableViewController {
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    // Setup navigation bar
    private func setupNavigationBar() {
        
        title = "Rick & Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = .black
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
    }
}

// MARK: - UISearchResultsUpdating
extension CharacterTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCharacter = rickAndMorty?.results.filter { character in
            character.name.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
    }
}
