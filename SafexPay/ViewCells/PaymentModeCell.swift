//
//  PaymentModeCell.swift
//  SafexPay
//
//  Created by Sandeep on 8/5/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class PaymentModeCell: UITableViewCell {

    @IBOutlet weak var paymentModeImage: UIImageView!
    @IBOutlet weak var paymentModeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(mode: StaticPaymentMode){
        self.paymentModeLabel.text = mode.paymentMode
        self.paymentModeImage.image = UIImage(named: mode.payModeID[0], in: safexBundle, compatibleWith: nil)
    }
    
}
