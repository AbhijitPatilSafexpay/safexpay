//
//  NetbankingView.swift
//  SafexPay
//
//  Created by Sandeep on 8/6/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
import RSSelectionMenu
import SVProgressHUD
//import KRProgressHUD

protocol DetailViewProtocol {
    func openWebURL(html: String)
    func backToMain()
}

class NetbankingView: UIView {
    
    // MARK:- Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bankNameLbl: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    
    // MARK:- Properties
    let bankImages = ["axis","hdfc","icici","kotakbank","yesbank","sbi"]
    let bankNames = ["Axis","HDFC","ICICI","Kotak","Yes","SBI"]
    var delegate: DetailViewProtocol?
    var mechantId = String.empty
    var price = String.empty
    var orderId = String.empty
    var netbankingData: [PaymentModeDetailsList]?
    private var pgId = String.empty
    private var pgMode = String.empty
    private var schemeId = String.empty
    var view = UIViewController()
    
    // MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK:- Helpers
    
    func setupNetbankingView(info: PaymentMode){
        self.titleLbl.text = info.paymentMode
        self.titleImg.image = UIImage(named: info.payModeID, in: safexBundle, compatibleWith: nil)
        self.payBtn.backgroundColor = headerColor
        self.payBtn.layer.cornerRadius = 2
        self.payBtn.layer.masksToBounds = true
        self.pgMode = info.payModeID
        self.setupCollectionView()
    }
    
    private func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "NetbankingCell", bundle: safexBundle), forCellWithReuseIdentifier: "NetbankingCell")
        
        let textViewRecognizer = UITapGestureRecognizer()
        textViewRecognizer.addTarget(self, action: #selector(openBankList))
        self.bankNameLbl.addGestureRecognizer(textViewRecognizer)
    }
    
    func updateBank(on ViewController: UIViewController) {
        guard let bankData = self.netbankingData else {return}
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: bankData) { (cell, data, index) in
            cell.textLabel?.text = data.pgDetailsResponse.pgName
        }
        let selectedItems = [PaymentModeDetailsList]()
        selectionMenu.setSelectedItems(items: selectedItems) { (text, index, selected, selectedItems) in
            if let bankName = text {
                print("selected Bank: \(bankName)")
                self.bankNameLbl.text = bankName.pgDetailsResponse.pgName
                self.pgId = bankName.pgDetailsResponse.pgID
                self.schemeId = bankName.schemeDetailsResponse.schemeID
            }
        }
        selectionMenu.cellSelectionStyle = .tickmark
        selectionMenu.showEmptyDataLabel(text: "No Data Found")
        selectionMenu.show(style: .alert(title: "Select your bank", action: "Done", height: nil), from: ViewController)
    }
    
    @objc private func openBankList(){
        self.updateBank(on: self.view)
    }
    
    @IBAction func payBtnPressed(_ sender: UIButton) {
        if self.pgId.isEmpty {
            view.showAlert(title: "", message: "Please select a bank.")
            return
        }
        self.startPayment()
    }
    
    @IBAction func backToMainPressed(_ sender: UIButton) {
        self.delegate?.backToMain()
    }
    
}

extension NetbankingView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.netbankingData{
            let data2 = Array(data.prefix(6))
            return data2.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetbankingCell", for: indexPath) as! NetbankingCell
        if let data = self.netbankingData{
            let data2 = Array(data.prefix(6))
            cell.setData(data: data2[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = self.netbankingData?[indexPath.row]{
            self.pgId = data.pgDetailsResponse.pgID
            self.schemeId = data.schemeDetailsResponse.schemeID
            self.bankNameLbl.text = data.pgDetailsResponse.pgName
        }
    }
    
}

extension NetbankingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension NetbankingView{
    private func startPayment(){
//        KRProgressHUD.show()
//        DispatchQueue.main.async {
            SVProgressHUD.show()
//        }
        DataClient.paymentCallback(merchantId: self.mechantId, orderId: self.orderId, orderAmount: self.price, countryCode: "IND", currency: "INR", txnType: "SALE", pgId: self.pgId, pgMode: self.pgMode, schemeId: self.schemeId, installmentMonths: "7", customerName: "Sandeep Ahuja", customerEmail: "sandyahuja4@gmail.com", customerMobile: "8800693003", customerUniqueId: "12354", isCustomerLoggedIn: "Y") { (status, data) in
            if status{
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
                if let datahtml = data{
                    self.delegate?.openWebURL(html: datahtml)
                }
            }else{
                DispatchQueue.global(qos: .default).async(execute: {
                    SVProgressHUD.dismiss()
                })
                Console.log(ErrorMessages.somethingWentWrong)
            }
        }
        
    }
    
//    private func decryptBrandingDetail(encData: String){
//        let payloadResponse = AESClient.AESDecrypt(dataToDecrypt: encData, decryptionKey: AESData.decryptKey)
//        let dataDict = convertToArrayDictionary(text: payloadResponse)
//        KRProgressHUD.dismiss()
//        do{
//            let data2 = try JSONSerialization.data(withJSONObject: dataDict , options: .prettyPrinted)
//            let decoder = JSONDecoder()
//            do {
//                self.paymodes = try decoder.decode([PaymentMode].self, from: data2)
//                KRProgressHUD.dismiss()
//                self.setupPaymentView()
//            } catch let DecodingError.dataCorrupted(context) {
//                print(context)
//                KRProgressHUD.dismiss()
//            } catch let DecodingError.keyNotFound(key, context) {
//                print("Key '\(key)' not found:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//                KRProgressHUD.dismiss()
//            } catch let DecodingError.valueNotFound(value, context) {
//                print("Value '\(value)' not found:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//                KRProgressHUD.dismiss()
//            } catch let DecodingError.typeMismatch(type, context)  {
//                print("Type '\(type)' mismatch:", context.debugDescription)
//                print("codingPath:", context.codingPath)
//                KRProgressHUD.dismiss()
//            } catch {
//                print("error: ", error)
//                KRProgressHUD.dismiss()
//            }
//        } catch {
//            Console.log(error.localizedDescription)
//            KRProgressHUD.dismiss()
//        }
//    }
    
}
