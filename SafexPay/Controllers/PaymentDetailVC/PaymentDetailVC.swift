//
//  PaymentDetailVC.swift
//  SafexPay
//
//  Created by Sandeep on 16/10/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class PaymentDetailVC: UIViewController {
    // MARK:- Outlets
    @IBOutlet weak var navBarTopView: UIView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK:- Properties
    var BrandDetails: BrandingDetail?
    var mechantId = String.empty
    var price = String.empty
    var orderId = String.empty
    var viewType: [PaymentMode]?
    
    var customerName = String.empty
    var customerEmail = String.empty
    var customerPhone = String.empty
    
    // MARK:- Lifecycle
    public init() {
        super.init(nibName: "PaymentDetailVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        if let modetype = self.viewType{
            self.setChosenView(of: modetype, on: self)
        }
    }

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
    
    func setupWebView(html: String){
        let vc = WebVC()
        vc.modalPresentationStyle = .fullScreen
        vc.htmlStr = html
        vc.price = self.price
        vc.orderId = self.orderId
        vc.BrandDetails = self.BrandDetails
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        
    }
    
}

extension PaymentDetailVC {
    func setChosenView(of type: [PaymentMode], on: UIViewController){
        switch type[0].paymentMode {
        case "Net Banking":
            setupNetbankingView(on: on, info: type[0])
        case "Credit Card":
            setupCardView(on: on, info: type)
        case "Debit Card":
            setupCardView(on: on, info: type)
        case "Wallet":
            setupWalletView(on: on, info: type[0])
        case "UPI":
            setupUpiView(on: on, info: type[0])
        default:
            print("No such option available")
        }
    }
    
    func setupNetbankingView(on VC: UIViewController, info: PaymentMode){
        let netbankingView = UINib(nibName: "NetbankingView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! NetbankingView
        netbankingView.frame = self.contentView.bounds
        netbankingView.mechantId = self.mechantId
        netbankingView.orderId = self.orderId
        netbankingView.price = self.price
        
        netbankingView.netbankingData = self.viewType?[0].paymentModeDetailsList
        netbankingView.delegate = self
        netbankingView.view = VC
        netbankingView.setupNetbankingView(info: info)
        self.contentView.addSubview(netbankingView)
    }
    
    func setupWalletView(on VC: UIViewController, info: PaymentMode){
        let walletView = UINib(nibName: "WalletView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! WalletView
        walletView.frame = self.contentView.bounds
        walletView.mechantId = self.mechantId
        walletView.orderId = self.orderId
        walletView.price = self.price
        walletView.walletData = self.viewType?[0].paymentModeDetailsList
        walletView.setupWalletView(info: info)
        walletView.delegate = self
        self.contentView.addSubview(walletView)
    }
    
    func setupCardView(on VC: UIViewController, info: [PaymentMode]){
        let cardView = UINib(nibName: "CardView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! CardView
        cardView.frame = self.contentView.bounds
        cardView.setupCardView(info: info)
        cardView.mechantId = self.mechantId
        cardView.orderId = self.orderId
        cardView.price = self.price
        cardView.delegate = self
//        cardView.netbankingData = self.viewType
        
        cardView.customerName = self.customerName
        cardView.customerEmail = self.customerEmail
        cardView.customerPhone = self.customerPhone
        self.contentView.addSubview(cardView)
    }
    
    func setupUpiView(on VC: UIViewController, info: PaymentMode){
        let upiView = UINib(nibName: "UpiView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! UpiView
        upiView.frame = self.contentView.bounds
        upiView.setupView(info: info)
        upiView.delegate = self
        self.contentView.addSubview(upiView)
    }
}

extension PaymentDetailVC: DetailViewProtocol {
    func openWebURL(html: String) {
        self.setupWebView(html: html)
    }
    
    func backToMain() {
        self.dismiss(animated: false, completion: nil)
    }
}
