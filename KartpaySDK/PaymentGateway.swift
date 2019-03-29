//
//  PaymentGateway.swift
//  KartpaySDK
//
//  Created by iMAC on 28/03/19.
//  Copyright © 2019 Saurabh.Chaudhari. All rights reserved.
//

import Foundation
import Alamofire


let header = ["Content-Type": "application/json"]

public func transactionRequest(merchant_id : String, access_key: String, currency: String, order_id: String, order_amount: String, customer_email: String, customer_phone: String, billing_name: String, billing_Address: String, billing_city: String, billing_state: String, billing_zip: String, billing_phone: String, billimg_email: String, shipping_name: String, shipping_Address: String, shipping_city: String, shipping_state: String, shipping_zip: String, shipping_phone: String, shipping_email: String, hash: String, language: String,  completion: @escaping (Bool, String, String) -> Void) {
    
    let url = "https://live.kartpay.me/api/v1/payments"
    let succFailUrl = "https://live.kartpay.me/api/v1/sdk_app_result"
    let parameter  = ["merchant_id": merchant_id, "access_key": access_key, "currency": currency, "order_id": order_id, "order_amount": order_amount, "customer_email": customer_email, "customer_phone": customer_phone, "success_url": succFailUrl, "failed_url": succFailUrl, "api_option": "hosted", "billing_name": billing_name, "billing_address": billing_Address, "billing_city": billing_city, "billing_state": billing_state, "billing_zip": billing_zip, "billing_phone": billing_phone, "billing_email": billimg_email, "shipping_name": shipping_name, "shipping_address": shipping_Address, "shipping_city": shipping_city, "shipping_state": shipping_state, "shipping_zip": shipping_zip, "shipping_phone": shipping_phone, "shipping_email": shipping_email, "hash": hash, "language": language] as [String : Any]
    
    Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
        switch response.result {
        case .success:
            guard let responseObj = response.result.value as? [String: Any] else {
                return
            }
            
            var errorMessage = ""
            let url = responseObj["url"] as? String
            if url == nil {
                let error = responseObj["errors"] as? [String: Any]
                if let message = error!["401"] as? String {
                    errorMessage = message
                } else if let message1 = error!["400"] as? String {
                    errorMessage = message1
                } else if let message2 = error!["301"] as? String {
                    errorMessage = message2
                } else if let message3 = error!["303"] as? String {
                    errorMessage = message3
                } else if let message4 = error!["305"] as? String {
                    errorMessage = message4
                } else if let message5 = error!["307"] as? String {
                    errorMessage = message5
                } else {
                    errorMessage = "Alert message : All parameters are compulsary"
                }
                completion(false, url ?? "", errorMessage)
            } else {
                let paymentUrl = url
                completion(true, paymentUrl!, errorMessage)
            }
            
        case .failure(let error):
            completion(false, error.localizedDescription, "Server timeout error if u still face this issue again and again please notify at help@Kartpay.com")
        }
    }
}


public func transactionStatus(merchant_id: String, access_key: String, order_id: String, hash: String, completion: @escaping (Bool, TransactionStatus, String) -> Void) {
    
    let url = "https://live.kartpay.me/api/v1/txn_status" + "?merchant_id=\(merchant_id)" + "&access_key=\(access_key)" + "&order_id=\(order_id)" + "&hash=\(hash)"
    var transactionStatusR = TransactionStatus(kartpayId: 0, orderId: "", orderAmount: "", status: "", hash: "")
    
    Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
        switch response.result {
        case .success:
            guard let responseObj = response.result.value as? [String: Any] else {
                return
            }
            
            var errorMessage = ""
            let error = responseObj["errors"] as? [String: Any]
            if error == nil {
                let kartpayID = responseObj["kartpay_id"] as? Int
                let orderID = responseObj["order_id"] as? String
                let orderAmt = responseObj["order_amount"] as? String
                let status = responseObj["status"] as? String
                let hash = responseObj["hash"] as? String
                transactionStatusR = TransactionStatus(kartpayId: kartpayID!, orderId: orderID!, orderAmount: orderAmt!, status: status!, hash: hash!)
                completion(true, transactionStatusR, "")
            } else {
                if let message = error!["400"] as? String {
                    errorMessage = message
                } else if let message1 = error!["301"] as? String {
                    errorMessage = message1
                } else {
                    errorMessage = "Alert message : All parameters are compulsary"
                }
                completion(false, transactionStatusR, errorMessage)
            }
            
        case .failure:
            completion(false, transactionStatusR, "Server timeout error if u still face this issue again and again please notify at help@Kartpay.com")
        }
    }
    
}


public func refundRequest(merchant_id: String, access_key: String, kartpay_id: String, order_id: String, refund_amount: String, reason: String, hash: String, completion: @escaping (Bool, Refunds, String) -> Void) {
    
    let url = "https://live.kartpay.me/api/v1/refunds"
    let parameter = ["merchant_id": merchant_id, "access_key": access_key, "kartpay_id": kartpay_id, "order_id": order_id, "refund_amount": refund_amount, "reason" : reason,"hash": hash]
    var refundsObj = Refunds(requestId: 0, kartpayId: 0, reason: "", status: "")
    
    Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
        switch response.result {
        case .success:
            guard let responseObj = response.result.value as? [String: Any] else {
                return
            }
            var errorMessage = ""
            let error = responseObj["errors"] as? [String: Any]
            if error == nil {
                let reqId = responseObj["request_id"] as? Int
                let kartpayId = responseObj["kartpay_id"] as? Int
                let reason = responseObj["reason"] as? String
                let status = responseObj["status"] as? String
                
                refundsObj = Refunds(requestId: reqId!, kartpayId: kartpayId!, reason: reason!, status: status!)
                completion(true, refundsObj, "")
            } else {
                if let message = error!["401"] as? String {
                    errorMessage = message
                } else {
                    errorMessage = "Alert message : All parameters are compulsary"
                }
                completion(false, refundsObj, errorMessage)
            }
            
        case .failure:
            completion(false, refundsObj, "Server timeout error if u still face this issue again and again please notify at help@Kartpay.com")
        }
    }
}


public func refundStatus(merchant_id: String, access_key: String, order_id: String, orderAmount: String, hash: String, completion: @escaping (Bool, RefundStatus, String) -> Void) {
    
    let url = "https://live.kartpay.me/api/v1/refund_status" + "?merchant_id=\(merchant_id)" + "&access_key=\(access_key)" + "&order_id=\(order_id)" + "&order_amount=\(orderAmount)" + "&hash=\(hash)"
    var refundStaObj = RefundStatus(kartpayId: 0, requestId: 0, status: "", reason: "")
    
    Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
        switch response.result {
        case .success:
            guard let responseObj = response.result.value as? [String: Any] else {
                return
            }
            var errorMessage = ""
            let error = responseObj["errors"] as? [String: Any]
            if error == nil {
                let reqid = responseObj["request_id"] as? Int
                let kartpayid = responseObj["kartpay_id"] as? Int
                let reason = responseObj["reason"] as? String
                let status = responseObj["status"] as? String
                
                refundStaObj = RefundStatus(kartpayId: kartpayid!, requestId: reqid!, status: status!, reason: reason)
                completion(true, refundStaObj, "")
            } else {
                if let message = error!["401"] as? String {
                    errorMessage = message
                } else {
                    errorMessage = "Alert message : All parameters are compulsary"
                }
               completion(false, refundStaObj, errorMessage)
            }
            
        case .failure:
            completion(false, refundStaObj, "Server timeout error if u still face this issue again and again please notify at help@Kartpay.com")
        }
    }
}
