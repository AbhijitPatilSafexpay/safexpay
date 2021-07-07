//
//  WalletCell.swift
//  SafexPay
//
//  Created by Sandeep on 8/7/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class WalletCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var bankImage: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView(){
        self.cellView.layer.masksToBounds = true
        self.cellView.layer.cornerRadius = 4
        self.cellView.addShadow(color: UIColor.darkGray)
    }
    
    func setData(data: PaymentModeDetailsList){
        self.bankName.text = data.pgDetailsResponse.pgName
        self.bankImage.image = UIImage(named: "WA", in: safexBundle, compatibleWith: nil)
    }
    
}
