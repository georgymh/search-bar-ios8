//
//  CandyTableViewController.swift
//  Search Bar
//
//  Created by Georgy Marrero on 6/10/15.
//  Copyright (c) 2015 Georgy Marrero. All rights reserved.
//

import UIKit

class CandyTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var allTheCandies = [Candy]()
    
    var showingCandies = [Candy]()
    
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        //self.searchController.searchBar.scopeButtonTitles = ...
        self.searchController.searchBar.delegate = self

        self.tableView.tableHeaderView = self.searchController.searchBar
        
        self.definesPresentationContext = true
        self.searchController.searchBar.sizeToFit()
        
        // Sample Data for candyArray
        self.allTheCandies = [Candy(category:"Chocolate", name:"chocolate Bar"),
            Candy(category:"Chocolate", name:"chocolate Chip"),
            Candy(category:"Chocolate", name:"dark chocolate"),
            Candy(category:"Hard", name:"lollipop"),
            Candy(category:"Hard", name:"candy cane"),
            Candy(category:"Hard", name:"jaw breaker"),
            Candy(category:"Other", name:"caramel"),
            Candy(category:"Other", name:"sour chew"),
            Candy(category:"Other", name:"gummi bear")]
        
        // Assign
        self.showingCandies = self.allTheCandies
        
        // Reload the table
        self.tableView.reloadData()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showingCandies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        var candy : Candy = self.showingCandies[indexPath.row]
        
        // Configure the cell
        cell.textLabel!.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("candyDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "candyDetail" {
            let candyDetailViewController = segue.destinationViewController as! UIViewController
           
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let destinationTitle = self.showingCandies[indexPath.row].name
            candyDetailViewController.title = destinationTitle
        }
    }
    
    // MARK: - Search bar
    
    // THIS will happen when the user changes the text in the Search Bar.
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Check if the user is writing something or not.
        if searchString == "" {
            // CASE: the user has not written anything.
            
            showingCandies = allTheCandies
        } else {
            // CASE: the user wrote something.
            
            filterContentForSearchText(searchString)
        }
        
        self.tableView.reloadData()
    }
    
    // This will happen when the user changes the scope.
    /*
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(self.searchController)
    }
    */

    // MARK: - Helper functions
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.showingCandies = self.allTheCandies.filter({(candy: Candy) -> Bool in
            let stringMatch = candy.name.rangeOfString(searchText, options: nil, range: nil, locale: nil)
            return (stringMatch != nil)
        })
    }

}
