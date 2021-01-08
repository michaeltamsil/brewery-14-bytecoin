//
//  CoinModel.swift
//  ByteCoin
//
//  Created by michael tamsil on 08/01/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
    var rate2Decimal: Double {
        return Double(String(format: "%.2f", rate)) ?? 0.00
    }
}
