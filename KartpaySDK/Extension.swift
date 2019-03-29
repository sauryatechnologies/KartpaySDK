//
//  Extension.swift
//  KartpaySDK
//
//  Created by iMAC on 29/03/19.
//  Copyright © 2019 Saurabh.Chaudhari. All rights reserved.
//

import Foundation


extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
