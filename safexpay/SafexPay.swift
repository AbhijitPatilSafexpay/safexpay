//
//  SafexPay.swift
//  SafexPay
//
//  Created by Sandeep on 8/4/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import Foundation
//import KRProgressHUD
import UIKit
import SVProgressHUD

public protocol SafexPayProtocol {
    func onPaymentComplete(orderID: String, transactionID: String, paymentID: String, paymentStatus:String)
    func onPaymentCancelled(reasonMessage: String)
    func onInitiatePaymentFailure(errorMessage: String)
}


@objc open class SafexPay: NSObject {
    public static let sharedInstance = SafexPay()
    private var merchantId = String.empty
    private var BrandDetails: BrandingDetail?
    public var delegate: SafexPayProtocol?
    
    override init() {
        super.init()
    }
    
    @objc open func configure(MerchantId: String, key: String){
        decryptKeyDy = key
        self.configureSafex(merchantId: MerchantId)
        
    }
    
    private func configureSafex(merchantId: String){
        self.merchantId = merchantId
        self.getBrandingDetails(merchantId: self.merchantId)
    }
    
    @objc open func showPaymentGateway(on viewController: UIViewController, price: String, orderId: String) {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onInitiatePaymentFailure),
            name: NSNotification.Name(rawValue: "onInitiatePaymentFailure"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onPaymentComplete),
            name: NSNotification.Name(rawValue: "onPaymentComplete"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onPaymentCancelled),
            name: NSNotification.Name(rawValue: "onPaymentCancelled"),
            object: nil)
        
        let vc = ContactDetailsVC()
        vc.modalPresentationStyle = .fullScreen
        vc.price = price
        vc.orderId = orderId
        vc.mechantId = self.merchantId
        vc.BrandDetails = self.BrandDetails
        viewController.present(vc, animated: true, completion: nil)
    }
    
    @objc func onPaymentComplete( _ notification: NSNotification) {
        if let delegate = self.delegate {
            NotificationCenter.default.removeObserver(self)
            if let orderID = notification.userInfo?["orderID"] as? String, let transactionID = notification.userInfo?["transactionID"] as? String, let paymentID = notification.userInfo?["paymentID"] as? String, let paymentStatus = notification.userInfo?["paymentStatus"] as? String {
            delegate.onPaymentComplete(orderID: orderID, transactionID: transactionID, paymentID: paymentID, paymentStatus: paymentStatus)
            }
        }
    }
    
    @objc func onPaymentCancelled(_ notification: NSNotification) {
        NotificationCenter.default.removeObserver(self)
        if let delegate = self.delegate {
            if let reasonMessage = notification.userInfo?["reasonMessage"] as? String {
            delegate.onPaymentCancelled(reasonMessage: reasonMessage)
            }
        }
    }
    
    @objc func onInitiatePaymentFailure(_ notification: NSNotification) {
        NotificationCenter.default.removeObserver(self)
        if let delegate = self.delegate {
            if let errorMessage = notification.userInfo?["onInitiatePaymentFailure"] as? String {
            delegate.onInitiatePaymentFailure(errorMessage: errorMessage)
            }
        }
    }
    
}

extension SafexPay{
    private func getBrandingDetails(merchantId: String){
//        KRProgressHUD.show()
//        DispatchQueue.main.async {
            SVProgressHUD.show()
//        }
        
        DataClient.getBrandingDetails(merchantId: merchantId) { (status, data) in
            if status{
                if let details = data{
                    self.decryptBrandingDetail(encData: details)
                }
            }else{
//                KRProgressHUD.dismiss()
                
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
                Console.log(ErrorMessages.somethingWentWrong)
            }
        }
    }
    
    private func decryptBrandingDetail(encData: String){
        let payloadResponse = AESClient.AESDecrypt(dataToDecrypt: encData, decryptionKey: AESData.decryptKey)
        let dataDict = convertToDictionary(text: payloadResponse)
        do{
            let data2 = try JSONSerialization.data(withJSONObject: dataDict! , options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                self.BrandDetails = try decoder.decode(BrandingDetail.self, from: data2)
                if let details = self.BrandDetails{
                    headerColor = UIColor(hexString: details.merchantThemeDetails.headingBgcolor)
                    bgColor = UIColor(hexString: details.merchantThemeDetails.bgcolor)
                }
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
            } catch {
                print("error: ", error)
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
            }
        } catch {
            Console.log(error.localizedDescription)
            DispatchQueue.global(qos: .default).async(execute: {
                SVProgressHUD.dismiss()
            })
        }
    }
}
