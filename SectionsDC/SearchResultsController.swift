//  SearchResultsController.swift
//  SectionsDC
//
//  Created by Daniel Catlett on 3/6/17.
//  Copyright © 2017 Daniel Catlett. All rights reserved.

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating
{
    private static let longNameSize = 6
    private static let shortNamesButtonIndex = 1
    private static let longNamesButtonIndex = 2
    
    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names:[String: [String]] = [String: [String]]()
    var keys:[String] = []
    var filteredNames: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UISearchResultsUpdatingConformance
    func updateSearchResults(for searchController: UISearchController)
    {
        if let searchString = searchController.searchBar.text
        {
            let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
            filteredNames.removeAll(keepingCapacity: true)
            
            if(!searchString.isEmpty)
            {
                let filter: (String) -> Bool = { name in
                    //Filter out long or short names depending on which
                    //scope is selected
                    let nameLength = name.characters.count
                    if(buttonIndex == SearchResultsController.shortNamesButtonIndex && nameLength >= SearchResultsController.longNameSize) || (buttonIndex == SearchResultsController.longNamesButtonIndex && nameLength < SearchResultsController.longNameSize)
                    {
                        return false
                    }
                    
                    let range = name.range(of: searchString, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                    return range != nil
                }
                
                for key in keys
                {
                    let namesForKey = names[key]!
                    let matches = namesForKey.filter(filter)
                    filteredNames += matches
                }
            }
        }
        tableView.reloadData()
    }
}
