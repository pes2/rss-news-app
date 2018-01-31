//
//  NewsSource.swift
//  NewsRSS
//
//  Created by Petteri S on 31/01/2018.
//  Copyright © 2018 Petteri S. All rights reserved.
//

import Foundation


enum NewsSource: String {
    
    case paauutiset = "majorHeadlines/YLE_UUTISET.rss"
    case tuoreimmat = "recent.rss?publisherIds=YLE_UUTISET"
    case luetuimmat = "mostRead/YLE_UUTISET.rss"
    case kotimaa = "recent.rss?publisherIds=YLE_UUTISET&concepts=18-34837"
    case ulkomaat = "recent.rss?publisherIds=YLE_UUTISET&concepts=18-34953"
    case talous = "recent.rss?publisherIds=YLE_UUTISET&concepts=18-19274"
    case viihde = "recent.rss?publisherIds=YLE_UUTISET&concepts=18-36066"
    case urheilu = "recent.rss?publisherIds=YLE_URHEILU"
    
    var title: String {
        switch self {
        case .paauutiset: return "Pääuutiset"
        case .tuoreimmat: return "Tuoreimmat"
        case .luetuimmat: return "Luetuimmat"
        case .kotimaa: return "Kotimaa"
        case .ulkomaat: return "Ulkomaat"
        case .talous: return "Talous"
        case .viihde: return "Viihde"
        case .urheilu: return "Urheilu"
        }
    }
    
    static var allValues: [NewsSource] {
        return [
            .paauutiset,
            .tuoreimmat,
            .luetuimmat,
            .kotimaa,
            .ulkomaat,
            .talous,
            .viihde,
            .urheilu
        ]
    }
    
}
