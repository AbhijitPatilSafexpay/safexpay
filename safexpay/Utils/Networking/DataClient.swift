//
//  DataClient.swift
//  SafexPay
//
//  Created by Sandeep on 11/09/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import Foundation

final class DataClient {
    
    private enum EndPoint {
        static let branding_url = "\(BASE_URL)/agcore/api/query/merchantBrandingDetails"
        static let paymode_scheme = "\(BASE_URL)/agcore/api/query/payModeAndSchemeAPI"
        static let payment_callback = "\(BASE_URL)/agcore/appPay"
        static let saved_cards = "\(BASE_URL)/agcore/api/query/getCardsByMerchant"
        static let card_type = "\(BASE_URL)/agcore/api/query/cardtype"
    }
    
    class func getBrandingDetails(merchantId: String,completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        let encMerchantId = AESClient.AESEncrypt(dataToEncrypt: merchantId, encryptionKey: AESData.encryptKey)
        let param = ["me_id":encMerchantId]
        DataService.instance.postRequest(url: EndPoint.branding_url, postParam: param, header: [
            "Content-Type": "application/json"
        ]) { (status, data) in
            if status{
                if let errorDetails = data?.value(forKey: "error_details") as? NSDictionary {
                    if errorDetails.value(forKey: "error_code") as? String == "1" {
                        if let details = data?.value(forKey: "merchantBrandingDetails") as? String{
                            completion(true,details)
                        }
                    }else {
                        completion(false,nil)
                    }
                }
            }else{
                completion(false,nil)
            }
        }
    }
    
    class func getPaymodes(merchantId: String,completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        let encMerchantId = AESClient.AESEncrypt(dataToEncrypt: merchantId, encryptionKey: AESData.encryptKey)
        let param = ["me_id":encMerchantId]
        DataService.instance.postRequest(url: EndPoint.paymode_scheme, postParam: param, header: [
            "Content-Type": "application/json"
        ]) { (status, data) in
            if status{
                if let errorDetails = data?.value(forKey: "error_details") as? NSDictionary {
                    if errorDetails.value(forKey: "error_code") as? String == "1" {
                        if let details = data?.value(forKey: "schemes") as? String{
                            completion(true,details)
                        }
                    }else {
                        completion(false,nil)
                    }
                }
            }else{
                completion(false,nil)
            }
        }
    }
    
    class func getSavedCards(merchantId: String,completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        _ = AESClient.AESEncrypt(dataToEncrypt: merchantId, encryptionKey: AESData.encryptKey)
        let param = ["me_id":"wtYe7WPbZqNbe+xJTSJerQ=="]
        DataService.instance.postRequest(url: EndPoint.saved_cards, postParam: param, header: [
            "Content-Type": "application/json"
        ]) { (status, data) in
            if status{
                if let errorDetails = data?.value(forKey: "error_Details") as? NSDictionary {
                    if errorDetails.value(forKey: "error_code") as? String == "1" {
                        if let details = data?.value(forKey: "cardsDetails") as? String{
                            completion(true,details)
                        }
                    }else {
                        completion(false,nil)
                    }
                }
            }else{
                completion(false,nil)
            }
        }
    }
    
    class func paymentCallback(merchantId: String, orderId: String, orderAmount: String, countryCode: String, currency: String, txnType: String, pgId: String, pgMode: String, schemeId: String, installmentMonths: String, customerName: String, customerEmail: String , customerMobile: String, customerUniqueId: String, isCustomerLoggedIn: String, cardDetails: String = "||||",completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        let txn_details = "paygate|\(merchantId)|\(orderId)|\(orderAmount)|\(countryCode)|\(currency)|\(txnType)|http://localhost/safexpay/response.php|http://localhost/safexpay/response.php|MOBILE"
        print(txn_details)
        let pg_details = "\(pgId)|\(pgMode)|\(schemeId)|\(installmentMonths)"
        print(pg_details)
        let card_details:String = cardDetails
        print(card_details)
        let cust_details = "\(customerName)|\(customerEmail)|\(customerMobile)|\(customerUniqueId)|\(isCustomerLoggedIn)"
        print(cust_details)
        let bill_details = "||||"
        print(bill_details)
        let ship_details = "||||||"
        print(ship_details)
        let item_details = "||"
        print(item_details)
        let other_details = "||||"
        print(other_details)
        
        let param: [String:Any] = [
            "txn_details":AESClient.AESEncrypt(dataToEncrypt: txn_details, encryptionKey: AESData.decryptKey),
            "pg_details":AESClient.AESEncrypt(dataToEncrypt: pg_details, encryptionKey: AESData.decryptKey),
            "card_details":AESClient.AESEncrypt(dataToEncrypt: card_details, encryptionKey: AESData.decryptKey),
            "cust_details":AESClient.AESEncrypt(dataToEncrypt: cust_details, encryptionKey: AESData.decryptKey),
            "bill_details":AESClient.AESEncrypt(dataToEncrypt: bill_details, encryptionKey: AESData.decryptKey),
            "ship_details":AESClient.AESEncrypt(dataToEncrypt: ship_details, encryptionKey: AESData.decryptKey),
            "item_details":AESClient.AESEncrypt(dataToEncrypt: item_details, encryptionKey: AESData.decryptKey),
            "other_details":AESClient.AESEncrypt(dataToEncrypt: other_details, encryptionKey: AESData.decryptKey),
            "me_id": "\(merchantId)"
        ]
        
        print(param.description)
        
        DataService.instance.postRequestString(url: EndPoint.payment_callback, postParam: param, header: [
            "Content-Type": "application/json"
        ]) { (status, data) in
            if status{
                if let datahtml = data as? String{
                    completion(true,datahtml)
                }
            }else{
                print("Errrorrr")
                completion(false,nil)
            }
        }
    }
    
    class func getCardType(merchantId: String,cardBin: String, completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        _ = AESClient.AESEncrypt(dataToEncrypt: cardBin, encryptionKey: AESData.encryptKey)
        let param = ["meid":"aBZuP+1ta4WfeWEBUNp+Lw==", "cardBin": cardBin]
        DataService.instance.postRequest(url: EndPoint.card_type, postParam: param, header: [
            "Content-Type": "application/json"
        ]) { (status, data) in
            if status{
                if let errorDetails = data?.value(forKey: "error_details") as? NSDictionary {
                    if errorDetails.value(forKey: "error_code") as? String == "1" {
                        if let details = data?.value(forKey: "cardType") as? String{
                            completion(true,details)
                        }
                    }else {
                        completion(false,nil)
                    }
                }
            }else{
                completion(false,nil)
            }
        }
    }
}
