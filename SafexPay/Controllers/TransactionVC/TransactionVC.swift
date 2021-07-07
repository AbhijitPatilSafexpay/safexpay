//
//  TransactionVC.swift
//  SafexPay
//
//  Created by Sandeep on 8/18/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class TransactionVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var navBarTopView: UIView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    
    // MARK:- Properties
    var isSucess = true
    var BrandDetails: BrandingDetail?
    var price = String.empty
    var orderId = String.empty
    var failureReason = String.empty
    var transactionID = String.empty
    var paymentID = String.empty
    var paymentStatus = String.empty
    // MARK:- Lifecycle
    public init() {
        super.init(nibName: "TransactionVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        if let details = self.BrandDetails{
            self.logoImg.setKfImage(with: details.logo)
        }
        self.navBarBottomView.backgroundColor = headerColor
        self.navBarTopView.backgroundColor = headerColor
        self.logoView.addBorders(edges: [.all], color: UIColor.lightGray, thickness: 0.5)
        self.tryAgainBtn.backgroundColor = headerColor
        self.tryAgainBtn.layer.cornerRadius = 2
        self.tryAgainBtn.layer.masksToBounds = true
        if self.isSucess{
            self.setupSuccessView()
        }else{
            self.setupFailureView()
        }
    }
    
    func setupFailureView(){
        let failedView = UINib(nibName: "TransactionView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! TransactionView
        failedView.frame = self.contentView.bounds
        failedView.paymentFailed(amount: self.price, orderNo: self.orderId)
//        self.tryAgainBtn.isHidden = false
//        self.tryAgainView.isHidden = false
        self.tryAgainBtn.setTitle("TRY AGAIN", for: .normal)
        self.isSucess = false
        self.contentView.addSubview(failedView)
    }
    
    func setupSuccessView(){
        let successView = UINib(nibName: "TransactionView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! TransactionView
        successView.frame = self.contentView.bounds
        successView.paymentSuccess(amount: self.price, orderNo: self.orderId)
//        self.tryAgainBtn.isHidden = true
//        self.tryAgainView.isHidden = true
        self.tryAgainBtn.setTitle("DONE", for: .normal)
        self.isSucess = true
        self.contentView.addSubview(successView)
    }
    
    func backTwo() {
//        let object:[String: Any] = ["orderID": self.orderId, "transactionID": self.tr]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onPaymentComplete"), object: nil, userInfo: imageDataDict)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func tryAgainPressed(_ sender: UIButton) {
            if self.isSucess{
                let object:[String: Any] = ["orderID": self.orderId, "transactionID": self.transactionID, "paymentID": self.paymentID, "paymentStatus": self.paymentStatus]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onPaymentComplete"), object: nil, userInfo: object)
            }else{
                let object:[String: Any] = ["failureReason": self.failureReason]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onInitiatePaymentFailure"), object: nil, userInfo: object)
            }
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
}
