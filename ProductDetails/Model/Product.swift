//
//  Product.swift
//  ProductDetails
//
//  Created by MAC Consultant on 4/15/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import Foundation

struct Product: Decodable {
    let pId: String
    let productName: String
    let price: Price
    let descr: String
    let mfgDate: String
}

struct Price: Decodable {
    let currency: String?
    let amount: Amount
}

struct Amount: Decodable {
    let rate: String
}
