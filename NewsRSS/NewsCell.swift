//
//  NewsCell.swift
//  NewsRSS
//
//  Created by Petteri S on 31/01/2018.
//  Copyright © 2018 Petteri S. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var item: RSSItem! {
        didSet {
            titleLabel.text = item.title
            dateLabel.text = formatDate(date: item.pubDate)
        }
    }
    
    private func formatDate(date: String) -> String {
        var result = ""
        
        let startingFormatter = DateFormatter()
        startingFormatter.dateFormat = "EEE, dd MMM y HH:mm:ss Z"
        startingFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let endingFormatter = DateFormatter()
        endingFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        let actualDate = startingFormatter.date(from: date)
        
        if let actualDate = actualDate {
            result = endingFormatter.string(from: actualDate)
        } else {
            // handle error
            result = date
        }
        
        return result
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
