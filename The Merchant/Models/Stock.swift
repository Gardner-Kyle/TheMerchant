//
//  Stock.swift
//  The Merchant
//
//  Created by Kyle Gardner on 8/21/20.
//  Copyright © 2020 Kyle Gardner. All rights reserved.
//

import Foundation
import SwiftyJSON

class Stock {
    var symbol: String!
    var currentPrice: Double!
    var lastPrice: Double!
    var quantityHeld: Int!
    var invested: Bool!
    
    init(json: [String: Any]) {
        self.symbol = json["symbol"] as? String
        self.currentPrice = json["askPrice"] as? Double
        self.lastPrice = json["lastPrice"] as? Double
        self.quantityHeld = 0
        self.invested = false
    }
}
