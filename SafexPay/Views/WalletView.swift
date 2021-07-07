//
//  WalletView.swift
//  SafexPay
//
//  Created by Sandeep on 8/7/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
import SVProgressHUD
//import KRProgressHUD

class WalletView: UIView {

    // MARK:- Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var payBtn: UIButton!
    
    // MARK:- Properties
    let walletImages = ["w-airtel-money","w-freecharge","w-jio-money","w-mobikwik","w-olamoney","w-payumoney","w-payzapp"]
    var walletData: [PaymentModeDetailsList]?
    var delegate: DetailViewProtocol?
    var mechantId = String.empty
    var price = String.empty
    var orderId = String.empty
    private var pgId = String.empty
    private var pgMode = String.empty
    private var schemeId = String.empty
    
    // MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK:- Helpers
    func setupWalletView(info: PaymentMode){
        self.titleLbl.text = info.paymentMode
        self.titleImg.image = UIImage(named: info.payModeID, in: safexBundle, compatibleWith: nil)
        self.payBtn.backgroundColor = headerColor
        self.payBtn.layer.cornerRadius = 2
        self.payBtn.layer.masksToBounds = true
        
        self.pgMode = info.payModeID
        self.setupCollectionView()
    }
    
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "WalletCell", bundle: safexBundle), forCellWithReuseIdentifier: "WalletCell")
        
        self.payBtn.applyGradient(colours: gradientColors)
        self.payBtn.layer.cornerRadius = 2
        self.payBtn.layer.masksToBounds = true
    }
    
    @IBAction func backToMainPressed(_ sender: UIButton) {
        self.delegate?.backToMain()
    }
    
    @IBAction func payBtnPressed(_ sender: UIButton) {
        if self.pgId.isEmpty {
            print("select a Wallet")
            return
        }
        self.startPayment()
    }
}

extension WalletView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.walletData{
            return data.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCell", for: indexPath) as! WalletCell
        if let data = self.walletData{
            cell.setData(data: data[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = self.walletData?[indexPath.row]{
            print(data)
            self.pgId = data.pgDetailsResponse.pgID
            self.schemeId = data.schemeDetailsResponse.schemeID
        }
    }
}

extension WalletView: UICollectionViewDelegateFlowLayout {
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

extension WalletView{
    private func startPayment(){
//        KRProgressHUD.show()
//        DispatchQueue.main.async {
            SVProgressHUD.show()
//        }
        DataClient.paymentCallback(merchantId: self.mechantId, orderId: self.orderId, orderAmount: self.price, countryCode: "IND", currency: "INR", txnType: "SALE", pgId: self.pgId, pgMode: self.pgMode, schemeId: self.schemeId, installmentMonths: "7", customerName: "Sandeep Ahuja", customerEmail: "sandyahuja4@gmail.com", customerMobile: "8800693003", customerUniqueId: "12354", isCustomerLoggedIn: "Y") { (status, data) in
            if status{
//                KRProgressHUD.dismiss()
//                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
//                }
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
}
