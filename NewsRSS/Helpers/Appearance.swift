//
//  Appearance.swift
//  NewsRSS
//
//  Created by Petteri S on 31/01/2018.
//  Copyright © 2018 Petteri S. All rights reserved.
//

import UIKit

class Appearance {
    
    static func configure() {
        let navBarAppearance = UINavigationBar.appearance()
        
        navBarAppearance.barTintColor = UIColor.rgb(red: 43, green: 79, blue: 133)
        
        navBarAppearance.isTranslucent = false
        
        navBarAppearance.barStyle = .black
        
        navBarAppearance.tintColor = .white
        
        navBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        // Remove black bar underneath navigation bar
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.setBackgroundImage(UIImage(), for: .default)
                
    }
    
}
