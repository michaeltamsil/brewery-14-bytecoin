//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "7B6A878D-3514-4490-9BD4-BD780606C15F"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: CoinManagerDelegate?
    
    func fetchRate(to_currency currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }

    func getCoinPrize(for currency: String){
        
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let coin = self.parseJSON(safeData){
                        print("save")
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ rateData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: rateData)
            
            let time = decodeData.time
            let asset_id_base = decodeData.asset_id_base
            let asset_id_quote = decodeData.asset_id_quote
            let rate = decodeData.rate
            print(rate)
            let coinModel = CoinModel(time: time, asset_id_base: asset_id_base, asset_id_quote: asset_id_quote, rate: rate)
            return coinModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
