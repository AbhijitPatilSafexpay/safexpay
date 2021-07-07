//
//  PaymentModesVCViewController.swift
//  SafexPay
//
//  Created by Sandeep on 8/13/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
//import KRProgressHUD
import SVProgressHUD

class PaymentModesVC: UIViewController {
    // MARK:- Outlets
    @IBOutlet weak var navBarTopView: UIView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- Properties
    var BrandDetails: BrandingDetail?
    var mechantId = String.empty
    var price = String.empty
    var orderId = String.empty
    
    
    var customerName = String.empty
    var customerEmail = String.empty
    var customerPhone = String.empty
    
    private var paymodes: [PaymentMode]?
    private var staticPaymentModes: [StaticPaymentMode]?
    
    
    lazy var SavedModesSectionLbl:UILabel = {
        let lbl = UILabel.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        lbl.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9882352941, blue: 0.9960784314, alpha: 1)
        lbl.font = UIFont(name: "Helvetica Neue", size: 15)
        lbl.textAlignment = .left
        lbl.textColor = #colorLiteral(red: 0.4509803922, green: 0.4549019608, blue: 0.4666666667, alpha: 1)
        return lbl
    }()
    
    lazy var ModesSectionLbl:UILabel = {
        let lbl = UILabel.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        lbl.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9882352941, blue: 0.9960784314, alpha: 1)
        lbl.font = UIFont(name: "Helvetica Neue", size: 15)
        lbl.textAlignment = .left
        lbl.textColor = #colorLiteral(red: 0.4509803922, green: 0.4549019608, blue: 0.4666666667, alpha: 1)
        return lbl
    }()
    
    // MARK:- Lifecycle
    public init() {
        super.init(nibName: "PaymentModesVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPaymodes(merchantId: self.mechantId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.getSavedCards(merchantId: self.mechantId)
        setupView()
        setuptableView()
    }
    
    // MARK:- Helpers
    
    func setupView(){
        if let details = self.BrandDetails{
            self.logoImg.setKfImage(with: details.logo)
        }
        self.navBarBottomView.backgroundColor = headerColor
        self.navBarTopView.backgroundColor = headerColor
        self.logoView.addBorders(edges: [.all], color: UIColor.lightGray, thickness: 0.5)
        self.amountView.layer.masksToBounds = true
        self.amountView.addBorders(edges: [.all], color: UIColor.lightGray, thickness: 0.5)
        self.amountLbl.text = Rupee + "" + "\(price)"
        self.orderLbl.text = "Order No." + "" + "\(orderId)"
    }
    
    //
    
    func setuptableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PaymentModeCell", bundle: safexBundle), forCellReuseIdentifier: "PaymentModeCell")
        self.tableView.register(UINib(nibName: "SavedCardCollection", bundle: safexBundle), forCellReuseIdentifier: "SavedCardCollection")
        self.tableView.register(UINib(nibName: "SavedCardsHeader", bundle: safexBundle), forHeaderFooterViewReuseIdentifier: "SavedCardsHeader")
    }
    
    func removeSubview(tag: Int){
        guard let viewWithTag = self.view.viewWithTag(tag) else {return}
        viewWithTag.removeFromSuperview()
    }
    
    func setupDetailView(for type: [PaymentMode]){
        let vc = PaymentDetailVC()
        vc.modalPresentationStyle = .fullScreen
        vc.price = self.price
        vc.orderId = self.orderId
        vc.viewType = type
        vc.mechantId = self.mechantId
        vc.BrandDetails = self.BrandDetails
        
        vc.customerName = self.customerName
        vc.customerEmail = self.customerEmail
        vc.customerPhone = self.customerPhone
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func closePaymentGateway(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PaymentModesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return self.staticPaymentModes?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardCollection") as! SavedCardCollection
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeCell") as! PaymentModeCell
            if let mode = self.staticPaymentModes?[indexPath.row]{
                cell.setData(mode: mode)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else {
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SavedCardsHeader") as! SavedCardsHeader
            view.tag = section
            view.sectionExpandButton.isHidden = true
            view.setdata(headerLbl: "SAVED CARDS")
            return view
        } else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SavedCardsHeader") as! SavedCardsHeader
            view.tag = section
            view.sectionExpandButton.isHidden = true
            view.setdata(headerLbl: "PAYMENT METHODS")
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.SavedModesSectionLbl.frame.size.height
        } else {
            return self.ModesSectionLbl.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{

        } else {
            var modess:[PaymentMode] = []
            if let modes = self.staticPaymentModes?[indexPath.row]{
                
                for (_, item) in modes.payModeID.enumerated() {
                    
                        for mode in self.paymodes! {
                            if mode.payModeID == item {
                                modess.append(mode)
                            }
                        }
                    
                }
//            if let mode = self.paymodes?[indexPath.row]{
//                print(mode.paymentMode)
//                self.setupDetailView(for: mode)
//            }
            }
            self.setupDetailView(for: modess)
        }
    }
}

extension PaymentModesVC{
    private func getPaymodes(merchantId: String){
//        KRProgressHUD.show()
//        DispatchQueue.main.async {
            SVProgressHUD.show()
//        }
        DataClient.getPaymodes(merchantId: merchantId) { (status, data) in
            if status{
                if let details = data{
                    self.decryptBrandingDetail(encData: details)
                }
            }else{
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
                Console.log(ErrorMessages.somethingWentWrong)
            }
        }
    }
    
    private func decryptBrandingDetail(encData: String){
        let payloadResponse = AESClient.AESDecrypt(dataToDecrypt: encData, decryptionKey: AESData.decryptKey)
        let dataDict = convertToArrayDictionary(text: payloadResponse)
        DispatchQueue.global(qos: .default).async(execute: {
            SVProgressHUD.dismiss()
        })
        do{
            let data2 = try JSONSerialization.data(withJSONObject: dataDict! , options: .prettyPrinted)
           
            let decoder = JSONDecoder()
            do {
                self.paymodes = try decoder.decode([PaymentMode].self, from: data2)
                
                
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
                self.loadStaticPaymentMode()
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
    
    private func getSavedCards(merchantId: String){
//        KRProgressHUD.show()
//        DispatchQueue.main.async {
            SVProgressHUD.show()
//        }
        DataClient.getSavedCards(merchantId: merchantId) { (status, data) in
            if status{
                if let details = data{
                    print(details)
                    self.decryptSavedCards(encData: details)
                }
            }else{
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
                Console.log(ErrorMessages.somethingWentWrong)
            }
        }
    }
    
    private func decryptSavedCards(encData: String){
        let payloadResponse = AESClient.AESDecrypt(dataToDecrypt: encData, decryptionKey: AESData.decryptKey)
        let dataDict = convertToArrayDictionary(text: payloadResponse)
        DispatchQueue.global(qos: .default).async(execute: {
            SVProgressHUD.dismiss()
        })
        do{
            let data2 = try JSONSerialization.data(withJSONObject: dataDict! , options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                self.paymodes = try decoder.decode([PaymentMode].self, from: data2)
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
                self.tableView.reloadData()
                
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
                })            } catch {
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

//constants
extension PaymentModesVC {
    func loadStaticPaymentMode() {
        var debitCard = false
        var creditCard = false
        var netBanking = false
        var wallet = false
        var upi = false
        var payModeId:[String] = []
        
        for  payM in self.paymodes! {
            if payM.payModeID == "NB" {
                netBanking = true
            } else if payM.payModeID == "CC" {
                payModeId.append(payM.payModeID)
                creditCard = true
            } else if payM.payModeID == "DC" {
                payModeId.append(payM.payModeID)
                debitCard = true
            } else if payM.payModeID == "UP" {
                upi = true
            } else if payM.payModeID == "WA" {
                wallet = true
            }
        }
        
        var cardValue = ""
        
        if creditCard {
            cardValue = "CREDIT"
        }
        if debitCard {
            if cardValue != "" {
                cardValue = cardValue + "/"
            }
            cardValue = cardValue + "DEBIT/ATM CARD"
        }
        self.staticPaymentModes = []
        
        if cardValue != "" {
        self.staticPaymentModes?.append(StaticPaymentMode(paymentMode: cardValue, payModeID: payModeId, paymentModeDetailsList: []))
        }
        
        if netBanking {
            self.staticPaymentModes?.append(StaticPaymentMode(paymentMode: "NET BANKING", payModeID: ["NB"], paymentModeDetailsList: []))
        }
        if wallet {
            self.staticPaymentModes?.append(StaticPaymentMode(paymentMode: "WALLETS", payModeID: ["WA"], paymentModeDetailsList: []))
        }
        if upi {
            self.staticPaymentModes?.append(StaticPaymentMode(paymentMode: "UPI", payModeID: ["UP"], paymentModeDetailsList: []))
        }
        self.tableView.reloadData()
    }
    
    func conditionalBasePaymentMode() {
        
    }
}
