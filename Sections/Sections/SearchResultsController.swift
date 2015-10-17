//
//  SearchResultsController.swift
//  Sections
//
//  Created by Brian J Glowe on 10/16/15.
//  Copyright © 2015 Brian Glowe. All rights reserved.
//

import UIKit

/// THESE PROPERTIES - allow us to get the search text from the search bar and use it to construct a filtered list of names in the filteredNames array.
private let longNameSize = 6
private let shortNamesButtonIndex = 1
private let longNamesButtonIndex = 2

class SearchResultsController: UITableViewController, UISearchResultsUpdating {

    
    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names: [String: [String]] = [String: [String]]()
    var keys: [String] = []
    var filteredNames: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UISearchResultsUpdating Conformance: 
// the following ~25 lines of code is explained on page 292-293 Apress book
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
        filteredNames.removeAll(keepCapacity: true)
        
        print("\(searchString)")
        
        if searchString?.isEmpty != nil  { // NOTE - the books code is wrong, this works
            let filter: String -> Bool = { name in
            // Filter out long or short names depending on which scope button is selected.
                let nameLength = name.characters.count
                if (buttonIndex == shortNamesButtonIndex && nameLength >= longNameSize) ||
                    (buttonIndex == longNamesButtonIndex && nameLength < longNameSize) {
                        return false
                }
                let range = name.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range != nil
            }
            for key in keys {
                let namesForKey = names[key]!
                let matches = namesForKey.filter(filter)
                filteredNames += matches
            }
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source methods

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return filteredNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier)
        cell!.textLabel?.text = filteredNames[indexPath.row]
        return cell!
    }
    

}

































