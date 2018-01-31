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
    
    var tabBar = MDCTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        
        navigationItem.title = "NewsRSS"
    }
    
    func configureTabBar() {
        tabBar = MDCTabBar(frame: self.mainTabBar.bounds)
        tabBar.delegate = self
        
        tabBar.items = NewsSource.allValues.enumerated().map { index, source in
            return UITabBarItem(title: source.title, image: nil, tag: index)
        }
        
        tabBar.selectedItem = tabBar.items[0]
        
        tabBar.selectedItemTintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
        tabBar.barTintColor = UIColor.rgb(red: 43, green: 79, blue: 133)
        
        tabBar.itemAppearance = .titles
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        tabBar.displaysUppercaseTitles = true
        
        self.mainTabBar.addSubview(tabBar)
    }
    

    
}


// MARK: MDCTabBarDelegate
extension ViewController: MDCTabBarDelegate {
    
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        
    }
}
