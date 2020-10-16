//
//  File.swift
//  The Merchant
//
//  Created by Kyle Gardner on 8/21/20.
//  Copyright © 2020 Kyle Gardner. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderService {
    func getQuote(symbol: String) -> DataRequest {
        return IBGSessionManager.sharedManager.request("https://api.tdameritrade.com/v1/marketdata/" + symbol + "/quotes", method: .get, headers: Global.headers)
    }
    
    func getQuotes(symbols: String) -> DataRequest {
        return IBGSessionManager.sharedManager.request("https://api.tdameritrade.com/v1/marketdata/quotes?symbol=\(symbols)", method: .get, headers: Global.headers)
    }
    
    func getAccount() -> DataRequest {
        return IBGSessionManager.sharedManager.request("https://api.tdameritrade.com/v1/accounts/" + Global.accountId, method: .get, headers: Global.headers)
    }
    
    func order(stock: JSON) -> DataRequest {
        return IBGSessionManager.sharedManager.request("https://api.tdameritrade.com/v1/accounts/" + Global.accountId + "/orders", method: .post, parameters: stock.dictionaryObject, encoding: JSONEncoding.default, headers: Global.headers)
    }
    
    func getAccessToken(params: JSON) -> DataRequest {
        return IBGSessionManager.sharedManager.request("https://api.tdameritrade.com/v1/oauth2/token", method: .post, parameters: params.dictionaryObject, encoding: JSONEncoding.default, headers: Global.headers)
    }
}
