//
//  Account.swift
//  The Merchant
//
//  Created by Kyle Gardner on 8/21/20.
//  Copyright © 2020 Kyle Gardner. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account {
    var accountId: String!
    var cashBalance: Double!
    var accruedInterest: Double!
    
    init(json: [String: Any]) {
        let securitiesAccount = json["securitiesAccount"] as? [String: Any]
        let currentBalances = securitiesAccount?["currentBalances"] as? [String: Any]
        
        self.accountId = securitiesAccount?["accountId"] as? String
        self.cashBalance = currentBalances?["cashBalance"] as? Double
        self.accruedInterest = currentBalances?["accruedInterest"] as? Double
    }
}
