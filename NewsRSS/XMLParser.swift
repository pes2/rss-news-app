//
//  XMLParser.swift
//  NewsRSS
//
//  Created by Petteri S on 31/01/2018.
//  Copyright © 2018 Petteri S. All rights reserved.
//
import UIKit

struct RSSItem {
    var title: String
    var description: String
    var pubDate: String
    var webURL: String
    var imageUrl: URL?
}

class FeedParser: NSObject, XMLParserDelegate {
    
    static let sharedInstance = FeedParser()
    
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var postImageUrl: URL?
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentWebURL: String = "" {
        didSet {
            currentWebURL = currentWebURL.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?) {
        
        // Clear the array before updating with new news elements
        self.rssItems.removeAll()
        
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                if let error = error {
                    self.createAlert(title: "Error", message: error.localizedDescription)
                    print(error.localizedDescription)
                }
                return
            }
            // Parse XML Data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    
    // MARK: XML Parser Delegate
    
    // When opening tag gets parsed
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        
        currentElement = elementName
        switch currentElement {
        case "item":
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentWebURL = ""
        case "enclosure":
            if let urlString = attributeDict["url"] {
                //print(urlString)
                postImageUrl = URL(string: urlString)
                //print("URLi: \(postImageUrl!)")
            } else {
                print("Malformed element:Enclosure without url attribute")
            }
            
        default:
            break
        }
        
    }
    
    // When date inside the tag gets parsed
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        case "link": currentWebURL += string
        default: break
        }
    }
    
    // When the parser reaches the closing tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI:
        String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, pubDate: currentPubDate, webURL: currentWebURL, imageUrl: postImageUrl)
            self.rssItems.append(rssItem)
        }
    }
    
    // Done parsing of the document
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        createAlert(title: "Error", message: parseError.localizedDescription)
        print(parseError.localizedDescription)
    }
    
    
    func createAlert (title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
}
