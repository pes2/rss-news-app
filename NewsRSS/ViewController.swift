//
//  ViewController.swift
//  NewsRSS
//
//  Created by Petteri S on 31/01/2018.
//  Copyright © 2018 Petteri S. All rights reserved.
//

import UIKit
import MaterialComponents
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var mainTabBar: UIView!
    @IBOutlet weak var articlesTableView: UITableView!
    
    var tabBar = MDCTabBar()
    var rssItems: [RSSItem]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        
        navigationItem.title = "NewsRSS"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        refreshContent()
        
        configurePullToRefreshControl()
        
    }
    
    func configurePullToRefreshControl() {
        // Refresh Control on TableView
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .lightGray
        refreshControl?.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246)
        refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            articlesTableView.refreshControl = refreshControl
        } else {
            articlesTableView.addSubview(refreshControl!)
        }
    }
    
    func configureTabBar() {
        tabBar = MDCTabBar(frame: self.mainTabBar.bounds)
        tabBar.delegate = self
        
        tabBar.items = NewsSource.allValues.enumerated().map { index, source in
            return UITabBarItem(title: source.title, image: nil, tag: index)
        }
        
        tabBar.selectedItem = tabBar.items[0]
        
        tabBar.selectedItemTintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        
        tabBar.barTintColor = UIColor.rgb(red: 43, green: 79, blue: 133)
        
        tabBar.itemAppearance = .titles
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        tabBar.displaysUppercaseTitles = true
        
        self.mainTabBar.addSubview(tabBar)
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else { return 0 }
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        //print("rssItems.count: \(rssItems?.count ?? -99) - indexPath.item: \(indexPath.item)")
        
        if let item = rssItems?[indexPath.item] {
            cell.item = item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowSelected = rssItems![indexPath.row]
        
        guard let url = URL(string: rowSelected.webURL) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url, configuration: config)
        self.present(safariVC, animated: true, completion: nil)
    }
}

// MARK: Update contend and fetch data
extension ViewController {
    @objc func refreshContent() {
        guard let selectedItem = tabBar.selectedItem else { return }
        
        let source = NewsSource.allValues[selectedItem.tag]
        fetchData(tag: source.rawValue)
    }
    
    func showError() {
        print("Error...")
    }
    
    func fetchData(tag: String) {
        
        let urlSring = "https://feeds.yle.fi/uutiset/v1/\(tag)"
        
        FeedParser.sharedInstance.parseFeed(url: urlSring) { (rssItems) in
            self.rssItems = rssItems
            
            OperationQueue.main.addOperation {
                self.articlesTableView.reloadData()
                self.articlesTableView.contentOffset = .zero
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}

// MARK: MDCTabBarDelegate
extension ViewController: MDCTabBarDelegate {
    
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        refreshContent()
    }
}
