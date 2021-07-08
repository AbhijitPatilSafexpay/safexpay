//
//  NetbankingCell.swift
//  SafexPay
//
//  Created by Sandeep on 8/6/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class NetbankingCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var bankImage: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    func setupView(){
        self.cellView.layer.masksToBounds = true
        self.cellView.layer.cornerRadius = 4
        self.cellView.addShadow(color: UIColor.darkGray)
    }
    
    func setData(data: PaymentModeDetailsList){
        self.bankName.text = data.pgDetailsResponse.pgName
        self.bankImage.image = UIImage(named: "NB", in: safexBundle, compatibleWith: nil)
    }
}
