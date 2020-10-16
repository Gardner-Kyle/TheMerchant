//
//  ViewController.swift
//  The Merchant
//
//  Created by Kyle Gardner on 8/20/20.
//  Copyright © 2020 Kyle Gardner. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var cashBalance: UILabel!
    @IBOutlet weak var accruedInterest: UILabel!
    @IBOutlet weak var stockTable: UITableView!
    
    var orderService = OrderService()
    
    var account: Account!
    var stocks: [Stock] = []
    var selected: [Stock] = []
    var refreshTimer = Timer()
    var tradeTimer = Timer()
    var accessTimer = Timer()
    var invested = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAccessToken()
        self.accessTimer = Timer.scheduledTimer(timeInterval: 1700, target: self, selector: #selector(self.getAccessToken), userInfo: nil, repeats: true)
    }
    
    func gotToken() {
        DispatchQueue.main.async {
            self.getAccount()
            self.getStockData()
            self.refreshTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.getStockData), userInfo: nil, repeats: true)
            self.stockTable.delegate = self
            self.stockTable.dataSource = self
        }
    }
    
    @objc func getAccessToken() {
        let url = URL(string: "https://api.tdameritrade.com/v1/oauth2/token")
        let payload = "grant_type=refresh_token&refresh_token=hFd%2FPibx6CboMD89xpHqt3xvNZDOOSNTqAKXG%2F%2F7b9zMQ%2BOLArW2UN3sQNcA%2FfUcYS8%2BNdxO50%2F28iUWW0RqntEHD7wZiFocjyXwrsru1SEUCDo7lknYNfqwIuVdRcpGzP58AALyna4LhT0x3agInloRzDsexCa57%2F%2F%2B20DKFRnGQ%2Bd%2FFaHdpyX6852pVONBRvvPUXdXH6DpwIW3z1fPMITUkQOKGUoovMjv1%2B38kxXEZ%2BnawQJMUeUcHonboXUUHdSygDNpVi6RDkssDYL0rahuatuU6eefk1i9K9ioRd2HGCVzMHY7sM%2FAkjbZMeUa2yBgUNLjpSbwnuTRW33dYZMUFMx4S1WR3pMumC%2BY%2BncRfigZAjBb1mt89XRDWGzUd0Io3lMSSE6wq9w%2BTACy2FQbChoOI0x%2Fvj02uMB3Vwrp5zaHEjj9dFNdwub100MQuG4LYrgoVi%2FJHHvlmLVD8FWV09Ux0HNqmzceruZyMHc%2B6%2BHO3MA97ycUwaosGgLwUpcGYCnpJ0svH9qX1A9lUXfBat4zozFhqjIQKu0DIKd1W6PAYwjr%2Fc%2B8BWUKauDR1vWkOQ3rYPutoXIAt%2FaSv72SffIBBeD3ytiqaUZ9SvEU2XSQmACt6Mj2y2OgfjzQs6TfPMTeiO3RKm1eo2mCyfrr7HHLqAhd%2F4oH4mwIN9sofJdI7XVAQO4ibA5wonVxKAhaNxI8PP9ePqD8HbtB%2BaS6AduJzUAFDzbCpfCp7q%2FxttyvYLJmvLHfzWz9iXUl3uSV1%2FNLwGXUSuqmFDVMLQinfDfBE87Pq8T7hET%2FPpx%2Fjt2b%2BGAeBS21L2cZKxHvMnU07n7Fn%2FPdXwp4H5aS2HGHSU6NfifKuT87Yy4DfKyPJh56TaPq6z6%2FSAgQuQJFjGbaZ1umPwo%3D212FD3x19z9sWBHDJACbC00B75E&access_type=&code=&client_id=SRG9M3EO8ORPVJKNHDUVVSUGRVVW8FJ6&redirect_uri=".data(using: .utf8)

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                self.createAlertController(title: "Unable to Create Token", message: "Please reload the application")
                return
            }
            guard let data = data else {
                print("Empty data")
                self.createAlertController(title: "Unable to Create Token", message: "Please reload the application")
                return
            }

            if let str = String(data: data, encoding: .utf8) {
                print(str)
                if str.contains("access_token") {
                    if let token = JSON.init(parseJSON: str).dictionaryValue["access_token"]?.stringValue {
                        Global.accessToken = token
                        self.gotToken()
                    }
                }
            }
        }.resume()
    }
    
    func getAccount() {
        let request = self.orderService.getAccount()
        request.responseJSON { data in
            if data.result.isSuccess {
                if let val = data.result.value {
                    self.account = Account(json: JSON(val).object as! [String: Any])
                    if self.account != nil {
                        let bal: CVarArg = self.account.cashBalance
                        let interest: CVarArg = self.account.accruedInterest
                        self.cashBalance.text = "Balance: " + String(format: "%.2f", bal)
                        self.accruedInterest.text = "Earnings: " + String(format: "%.2f", interest)
                    }
                }
            } else {
                print(data.result.value as Any)
            }
        }
    }
    
    @objc func getStockData() {
        self.stocks.removeAll()
        let request = self.orderService.getQuotes(symbols: "XELA,DXLG,JAGX,TTNP,ACST,GHSI,BIOL,HTGM")
        request.responseJSON { data in
            if data.result.isSuccess {
                if let val = data.result.value {
                    if let json = JSON(val).object as? [String: Any] {
                        let stocks = json.values
                        for stock in stocks {
                            self.stocks.append(Stock(json: stock as! [String : Any]))
                        }
                        self.stocks.sort(by: { $0.symbol < $1.symbol })
                        self.stockTable.reloadData()
                        if !self.selected.isEmpty {
                            for stock in self.selected {
                                for i in 0..<self.stocks.count {
                                    if self.stocks[i].symbol == stock.symbol {
                                        self.stockTable.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .none)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print(data.result.value as Any)
            }
        }
    }
    
    func buy(stock: Stock) {
        let order = [
            "orderType": "MARKET",
            "session": "NORMAL",
            "duration": "DAY",
            "orderStrategyType": "SINGLE",
            "orderLegCollection": [[
                "instruction": "Buy",
                "quantity": 1,
                "instrument": [
                    "symbol": stock.symbol,
                    "assetType": "EQUITY"
                ],
            ]]
        ] as [String : Any]
        
        
        
        let request = self.orderService.order(stock: JSON(order))
        request.responseJSON { data in
            for item in self.selected {
                if stock.symbol == item.symbol {
                    let info = order["orderLegCollection"] as! [[String: Any]]
                    item.quantityHeld += info[0]["quantity"] as! Int
                }
            }
        }
    }
    
    func sell(stock: Stock) {
        for item in self.selected {
            if item.symbol == stock.symbol {
                stock.quantityHeld = item.quantityHeld
            }
        }
        let order = [
            "orderType": "MARKET",
            "session": "NORMAL",
            "duration": "DAY",
            "orderStrategyType": "SINGLE",
            "orderLegCollection": [[
                "instruction": "SELL",
                "quantity": stock.quantityHeld as Any,
                "instrument": [
                    "symbol": stock.symbol,
                    "assetType": "EQUITY"
                ],
            ]]
        ] as [String : Any]
        
        let request = self.orderService.order(stock: JSON(order))
        request.responseJSON { data in
            if data.result.isSuccess {
                for item in self.selected {
                    if stock.symbol == item.symbol {
                        item.quantityHeld = 0
                    }
                }
                print(data.result.value as Any)
            } else {
                print(data.result.value as Any)
            }
        }
    }
    
    @objc func trade() {
        for stock in self.selected {
            let request = self.orderService.getQuote(symbol: stock.symbol)
            request.responseJSON { data in
                if data.result.isSuccess {
                    if let val = data.result.value {
                        let stocksJson = JSON(val).object as! [String: Any]
                        let stocks = stocksJson.values
                        for item in stocks {
                            if let val = item as? [String: Any] {
                                let freshStock = Stock(json: val)
                                if !stock.invested && freshStock.currentPrice > freshStock.lastPrice {
                                    self.buy(stock: freshStock)
                                    stock.invested = true
                                } else if stock.invested && freshStock.currentPrice < freshStock.lastPrice {
                                    self.sell(stock: freshStock)
                                    stock.invested = false
                                }
                            }
                        }
                    }
                } else {
                    print(data.result.value as Any)
                    self.tradeTimer.invalidate()
                }
            }
        }
    }
    
    @IBAction func tradeBtn(_ sender: UIButton) {
        if !self.selected.isEmpty {
            self.tradeTimer = Timer.scheduledTimer(timeInterval: 1.55, target: self, selector: #selector(self.trade), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func stopBtn(_ sender: UIButton) {
        self.tradeTimer.invalidate()
        if self.invested {
            for stock in self.selected {
                self.sell(stock: stock)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockTableViewCell", for: indexPath) as? StockTableViewCell else {
            fatalError("The dequeued cell is not an instance of iPadPayHistoryTableViewCell.")
        }
        if !self.stocks.isEmpty {
            let stock = self.stocks[indexPath.row]
            cell.symbol.text = stock.symbol
            cell.percent.text = String(format: "%.4f", ((stock.currentPrice - stock.lastPrice) / stock.lastPrice) * 100) + "%"
            cell.price.text = "$" + String(format: "%.4f", stock.currentPrice)
            
            if stock.currentPrice < stock.lastPrice {
                cell.symbol.textColor = UIColor.red
            } else {
                cell.symbol.textColor = UIColor.green
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stock = self.stocks[indexPath.row]
        var doubleSelect = false
        
        for item in self.selected {
            if item.symbol == stock.symbol {
                doubleSelect = true
            }
        }
        
        if !doubleSelect {
            if self.selected.count < 3 {
                self.selected.append(stock)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let val = self.stocks[indexPath.row]
        for i in 0..<self.selected.count {
            if self.selected[i].symbol == val.symbol {
                let stock = self.selected[i]
                if stock.quantityHeld > 0 {
                    self.sell(stock: stock)
                }
                self.selected.remove(at: i)
                break
            }
        }
    }
    
}

