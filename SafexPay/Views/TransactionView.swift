//
//  TransactionFailedView.swift
//  SafexPay
//
//  Created by Sandeep on 8/18/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class TransactionView: UIView {

    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var messageImg: UIImageView!
    
    // MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK:- Helpers
    
    func paymentFailed(amount: String, orderNo: String){
        self.amountLbl.textColor = UIColor.lightGray
        self.amountLbl.text = Rupee + "" + amount
        self.orderLbl.text = "Order No: \(orderNo)"
        self.paymentLbl.textColor = UIColor.lightGray
        self.messageImg.image = UIImage(named: "Failure", in: safexBundle, compatibleWith: nil)
        self.messageLbl.text = "TRANSACTION FAILED"
        self.messageLbl.textColor = #colorLiteral(red: 0.9084269404, green: 0, blue: 0, alpha: 1)
        self.orderLbl.textColor = #colorLiteral(red: 0.9084269404, green: 0, blue: 0, alpha: 1)
    }
    
    func paymentSuccess(amount: String, orderNo: String){
        self.amountLbl.textColor = #colorLiteral(red: 0.1058823529, green: 0.3725490196, blue: 0.7843137255, alpha: 1)
        self.amountLbl.text = Rupee + "" + amount
        self.orderLbl.text = "Order No: \(orderNo)"
        self.paymentLbl.textColor = #colorLiteral(red: 0.1058823529, green: 0.3725490196, blue: 0.7843137255, alpha: 1)
        self.messageImg.image = UIImage(named: "Success", in: safexBundle, compatibleWith: nil)
        self.messageLbl.text = "TRANSACTION SUCCESSFUL"
        self.messageLbl.textColor = #colorLiteral(red: 0.1058823529, green: 0.3725490196, blue: 0.7843137255, alpha: 1)
        self.orderLbl.textColor = #colorLiteral(red: 0.1058823529, green: 0.3725490196, blue: 0.7843137255, alpha: 1)
    }
}
