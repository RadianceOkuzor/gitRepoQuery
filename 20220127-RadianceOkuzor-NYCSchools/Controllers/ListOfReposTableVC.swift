//
//  ListOfSchoolsTableVC.swift
//  20220127-RadianceOkuzor-NYCSchools
//
//  Created by Radiance Okuzor on 1/27/22.
//

import UIKit
import Cache
import Alamofire

class ListOfReposTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterView: UIStackView!
    @IBOutlet weak var aToZButton: UIButton!
    @IBOutlet weak var mathButtn: UIButton!
    @IBOutlet weak var readingButton: UIButton!
    @IBOutlet weak var writtingButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // filter buttons
   
    private var repoViewModel : RepoViewModel!
    var repoData = RepoListDTO(repositories: [], isError: false, errorMessage: "", showMore: false) // collection of all the repos
    var tableHeader = ""
    var isConnected:Bool = true
//    var presenter : (RepoListPresenter & RepoLisViewToPresenterDelegate)!
    var pageNumber = 1
    var queryString = "graphQL"
    var selectedCell = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        //Display a list of NYC Highscools
        self.title = "PEEK"
        
        // check internet connectivity and based on that use the cache data or the backend data
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.isConnected = appDelegate.internetIsConnected
            if appDelegate.internetIsConnected {
                // we have wifi go ahead and hit the backed
                self.repoViewModel = RepoViewModel()
                callToViewModelForUIUpdate()
            } else {
                // no data use the cache
                print("pulling from cache data")
                
                self.repoViewModel = RepoViewModel()
                callToViewModelForUIUpdate()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        } else {
            print("invalid delegate type")
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        tableHeader = "Git Repo Queries"
    }
    
   // filter the list of highschools in alphabetical order
    @IBAction func aToZPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        menuOpenClose()
        repoData = self.repoViewModel.filterSchools(filter: "alpha")
        tableView.reloadData()
        tableHeader = "Repos A to Z"
        activityIndicator.stopAnimating()
    }
    
    @IBAction func wacthersPrsed(_ sender: UIButton) {
        // when pressed show from highest to lowest the math scores
        menuOpenClose()
        activityIndicator.startAnimating()
        // show list in high to low order and change label to low to high
        if sender.titleLabel?.text == "WATCHERS ⇣" {
            sender.setTitle("WATCHERS ⇡", for: .normal)
            repoData = self.repoViewModel.filterSchools(filter: "watchersHigh")
            tableView.reloadData()
            tableHeader = "Watchers Highest to Lowest"
            activityIndicator.stopAnimating()
        } else {
            // show list in low to high order and change label to high to low
            sender.setTitle("WATCHERS ⇣", for: .normal)
            repoData = self.repoViewModel.filterSchools(filter: "watchersLow")
            tableView.reloadData()
            tableHeader = "Watchers Lowest to Highest"
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func showMoreClicked(_ sender: Any) {
        pageNumber += 1
        repoViewModel.search(queryString: queryString, page: pageNumber)
        callToViewModelForUIUpdate()
    }
    
    @IBAction func starrsPrsd(_ sender: UIButton) {
        menuOpenClose()
        activityIndicator.startAnimating()
        if sender.titleLabel?.text == "FORKS ⇣" {
            // show list in high to low order and change label to low to high
            sender.setTitle("FORKS ⇡", for: .normal)
            repoData = self.repoViewModel.filterSchools(filter: "forksHigh")
            tableView.reloadData()
            tableHeader = "Forks Highest to Lowest"
            activityIndicator.stopAnimating()
        } else {
            // show list in low to high order and change label to high to low
            sender.setTitle("FORKS ⇣", for: .normal)
            repoData = self.repoViewModel.filterSchools(filter: "forksLow")
            tableView.reloadData()
            tableHeader = "Forks Lowest to Highest"
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func reposPrsdd(_ sender: UIButton) {
        menuOpenClose()
        activityIndicator.startAnimating()
        if sender.titleLabel?.text == "REPOS ⇣" {
            // show list in high to low order and change label to low to high
            sender.setTitle("REPOS ⇡", for: .normal)
            repoData = self.repoViewModel.filterSchools(filter: "reposHigh")
            tableView.reloadData()
            tableHeader = "Repos submitted Highest to Lowest"
            activityIndicator.stopAnimating()
        } else {
            // show list in low to high order and change label to high to low
            sender.setTitle("REPOS ⇣", for: .normal)
            repoData = self.repoViewModel.filterSchools(filter: "reposLow")
            tableView.reloadData()
            tableHeader = "Repos Submitted Lowest to Highest"
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func filterPressed(_ sender: UIButton) {
        menuOpenClose()
    }
    
    func menuOpenClose(){
        UIView.animate(withDuration: 0.2) {
            self.aToZButton.isHidden =  (self.aToZButton.isHidden) ? false : true
        }
        UIView.animate(withDuration: 0.2) {
            self.mathButtn.isHidden =  (self.mathButtn.isHidden) ? false : true
        }
        UIView.animate(withDuration: 0.2) {
            self.readingButton.isHidden =  (self.readingButton.isHidden) ? false : true
        }
        UIView.animate(withDuration: 0.2) {
            self.writtingButton.isHidden =  (self.writtingButton.isHidden) ? false : true
        }
    }
    
    func callToViewModelForUIUpdate(){
        // this is binded to viewmodel and is only triggered upon the completion of the data request from the server 
        self.repoViewModel.bindRepoViewModelToController = {self.updateDataSource()}
    }
    
    func updateDataSource(){
        repoData.repositories.removeAll()
        repoData = self.repoViewModel.repoData
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollsToTop = true
            self.activityIndicator.stopAnimating()
        }
    }

    // MARK: - Table view data source
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepoData" {
            if let vc = segue.destination as? RepoDataVC {
                vc.selected = self.selectedCell
                vc.repoData = self.repoData
            }
        }
    }

}

extension ListOfReposTableVC {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        queryString = searchBar.text ?? ""
        repoViewModel.search(queryString: searchBar.text!)
        callToViewModelForUIUpdate()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        queryString = searchBar.text ?? ""
        repoViewModel.search(queryString: searchBar.text!)
        callToViewModelForUIUpdate()
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return repoData.repositories.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoList", for: indexPath) as? RepoNameTableViewCell else {
            return UITableViewCell()
        }

        // Configure the cell...
        cell.repoDescription.text = repoData.repositories[indexPath.row].description
        cell.forksCount.text = "\(repoData.repositories[indexPath.row].forks ?? 0) watchers"
        cell.ownerName.text = repoData.repositories[indexPath.row].name
        cell.ownerImage?.load(url: URL(string: repoData.repositories[indexPath.row].owner?.avatarURL ?? "")!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = indexPath.row
        performSegue(withIdentifier: "showRepoData", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repoData.repositories.count - 1 {
//            pageNumber += 1
//            repoViewModel.search(queryString: queryString, page: pageNumber)
//            callToViewModelForUIUpdate()
        }
    }
}
