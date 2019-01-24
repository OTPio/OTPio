//
//  IconSelectorViewController.swift
//  otpio
//
//  Created by Mason Phillips on 12/2/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import Eureka
import libfa
import FuzzyMatchingSwift

public class IconSelectorVC: UITableViewController, TypedRowControllerType {
    public var row: RowOf<FontAwesome>!
    public typealias RowValue = FontAwesome
        
    public var onDismissCallback: ((UIViewController) -> Void)?
    
    let searchController: UISearchController
    var filterResults: Array<(k: String, v: FontAwesome)> = FontAwesome.mappedBrands
    
    var currentIcon: FontAwesome?
    var issuer: String?
    var suggestedResults: Array<(String, FontAwesome)> = []
    
    var suggestedEnabled: Bool = false
    var currentEnabled: Bool = false
    
    public required init?(coder aDecoder: NSCoder) {
        searchController = UISearchController(searchResultsController: nil)

        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        searchController = UISearchController(searchResultsController: nil)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience public init(_ callback: ((UIViewController) -> ())?) {
        self.init(nibName: nil, bundle: nil)
        onDismissCallback = callback
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let theme = ThemingEngine.sharedInstance
        tableView.backgroundColor = theme.background
    }
    
    func initialize() {
        tableView.register(IconDisplayTVC.self, forCellReuseIdentifier: "iconCell")
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        if let i = currentIcon {
            currentEnabled = true
            currentIcon = i
        }
        
        if let s = issuer {
            suggestedResults = filterResults.filter { (k: String, _) in
                let score = k.score(word: s, fuzziness: 0.5)
                return score > 0.7
            }
            suggestedEnabled = true
        }
        
        tableView.reloadData()
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return (suggestedEnabled && currentEnabled) ? 3 : 1
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let count = numberOfSections(in: tableView)
        
        switch count {
        case 3:
            if section == 0 { return "Current Icon" }
            if section == 1 { return "Suggested Icons" }
            if section == 2 { return "All Icons" }
        default: return "All Icons"
        }
        
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentEnabled && suggestedEnabled {
            switch section {
            case 0 : return 1
            case 1 : return suggestedResults.count
            default: return filterResults.count
            }
        }
        
        return filterResults.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath) as! IconDisplayTVC

        if currentEnabled && suggestedEnabled {
            switch indexPath.section {
            case 0:
                cell.iconLabel?.text = String.fontAwesomeIcon(name: currentIcon!)
                cell.nameLabel?.text = currentIcon!.iconName()
            case 1:
                let r = suggestedResults[indexPath.row]
                
                cell.iconLabel?.text = String.fontAwesomeIcon(name: r.1)
                cell.nameLabel?.text = r.0
            default:
                let r = filterResults[indexPath.row]
                
                cell.iconLabel?.text = String.fontAwesomeIcon(name: r.1)
                cell.nameLabel?.text = r.0
            }
        } else {
            let r = filterResults[indexPath.row]
            
            cell.iconLabel?.text = String.fontAwesomeIcon(name: r.1)
            cell.nameLabel?.text = r.0
        }
        
        cell.backgroundColor = ThemingEngine.sharedInstance.bgHighlight
        cell.iconLabel?.textColor = ThemingEngine.sharedInstance.emphasizedText
        cell.nameLabel?.textColor = ThemingEngine.sharedInstance.normalText
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! IconDisplayTVC
        
        guard let value = cell.iconLabel?.text else { return }
        guard let icon = FontAwesome(rawValue: value) else { return }
        
        row.value = icon
        navigationController?.popViewController(animated: true)
        searchController.resignFirstResponder()
    }
}

extension IconSelectorVC: UISearchBarDelegate, UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else { return }
        
        let sstring = search.lowercased()
        if !search.isEmpty {
            filterResults = FontAwesome.mappedBrands.filter { $0.0.lowercased().contains(sstring) }
            
            currentEnabled = false
            suggestedEnabled = false
        } else {
            filterResults = FontAwesome.mappedBrands
            
            currentEnabled = (currentIcon != nil)
            suggestedEnabled = (suggestedResults.count > 0)
        }
        
        tableView.reloadData()
    }
}
