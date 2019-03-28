//
//  Model.swift
//  KartpaySDK
//
//  Created by iMAC on 28/03/19.
//  Copyright © 2019 Saurabh.Chaudhari. All rights reserved.
//

import Foundation

public struct TransactionStatus {
    var kartpayId: Int
    var orderId: String
    var orderAmount: String
    var status: String
    var hash: String
}


public struct Refunds {
    var requestId: Int
    var kartpayId: Int
    var reason: String?
    var status: String
}


public struct RefundStatus {
    var kartpayId: Int
    var requestId: Int
    var status: String
    var reason: String?
}
