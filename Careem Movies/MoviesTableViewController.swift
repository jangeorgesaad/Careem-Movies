//
//  MoviesTableViewController.swift
//  Careem Movies
//
//  Created by Jan G. Botros on 7/27/18.
//  Copyright © 2018 Jan G. Botros. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    var pageNumber: Int = 1
    var totalPages: Int = 0
    let searchController = UISearchController(searchResultsController: nil)
    var movies = [Movie]()
    let activityIndicator = UIActivityIndicatorView()
    var movieName: String = ""
    var successfulSearchArray = [String]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 75.0/255.0, green: 161.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        view.addSubview(activityIndicator)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.darkGray
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = searchTextField.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }

        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        
        fetchSearchHistory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if movies.count > 0 {
            return movies.count
        }else {
            return successfulSearchArray.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == movies.count - 1 {
            if totalPages > pageNumber {
                pageNumber += 1
                fetchMovies()
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if movies.count > 0 {
            cell.textLabel?.text = movies[indexPath.row].title
        } else {
            cell.textLabel?.text = successfulSearchArray[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if movies.count > 0 {
            return "Search Results"
        } else {
            if successfulSearchArray.count > 0{
                return "Recent Searches"
            } else {
                return nil
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if movies.count > 0 {
            let movie = movies[indexPath.row]
            let sb:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            controller.movie = movie
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let searchText = successfulSearchArray[indexPath.row]
            searchController.searchBar.text = searchText
            movieName = searchText
            pageNumber = 1
            fetchMovies()
            searchController.searchBar.resignFirstResponder()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        fetchSearchHistory()
        return true
    }
    
    func fetchSearchHistory(){
        movies.removeAll()
        successfulSearchArray.removeAll()
        let SearchArray = defaults.stringArray(forKey: "successfulSearchArray") ?? [String]()
        for index in stride(from: SearchArray.count - 1, through: 0, by: -1) {
            successfulSearchArray.append(SearchArray[index])
        }
        tableView.reloadData()
    }
    
    func fetchMovies(){
        let api = API()
        api.fetchMovies(MovieName: movieName, PageNumber: pageNumber, completion: {movieResults,totalPages  in
            self.activityIndicator.stopAnimating()
            
            if movieResults != nil {
                if self.pageNumber == 1 {
                    if self.successfulSearchArray.contains(self.movieName){
                        let index = self.successfulSearchArray.index(of: self.movieName)
                        self.successfulSearchArray.remove(at: index!)
                        self.successfulSearchArray.append(self.movieName)
                        self.defaults.set(self.successfulSearchArray, forKey: "successfulSearchArray")
                    } else {
                        if movieResults?.count != 0 {
                        self.successfulSearchArray.append(self.movieName)
                        self.defaults.set(self.successfulSearchArray, forKey: "successfulSearchArray")
                        }
                    }
                }
                self.totalPages = totalPages!
                //                self.movies = movieResults!
                if (movieResults?.count)! > 0 {
                    self.movies.append(contentsOf: movieResults!)
                    self.tableView.reloadData()
                } else {
                    self.movies.removeAll()
                    self.tableView.reloadData()
                    let alertController = UIAlertController(title: nil, message: "Unfortunately, There is no movie name '\(self.movieName)'!", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        alertController.dismiss(animated: true, completion: nil)
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                self.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "No internet connection!", message: "Please check your internet connection and try again!", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
            
        } )
    }
    
}

extension MoviesTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        movieName = searchController.searchBar.text!
        if searchController.searchBar.text != "" {
            movies.removeAll()
            fetchMovies()
        }
    }
}
