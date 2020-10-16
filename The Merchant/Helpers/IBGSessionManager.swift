//
//  IBGSessionManager.swift
//  The Merchant
//
//  Created by Kyle Gardner on 8/21/20.
//  Copyright © 2020 Kyle Gardner. All rights reserved.
//

import Alamofire
import Instabug

class IBGSessionManager: Alamofire.SessionManager {
    static let sharedManager: IBGSessionManager = {
        let configuration = URLSessionConfiguration.default
                NetworkLogger.enableLogging(for: configuration)
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = IBGSessionManager(configuration: configuration)
        return manager
    }()
}
