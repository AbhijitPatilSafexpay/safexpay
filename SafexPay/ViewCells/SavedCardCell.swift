//
//  SavedCardCell.swift
//  SafexPay
//
//  Created by Sandeep on 8/24/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class SavedCardCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var expiryDate: UnderLineImageTextField!
    @IBOutlet weak var cvv: UnderLineImageTextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.masksToBounds = true
        cellView.layer.cornerRadius = 4
        self.cellView.backgroundColor = headerColor
    }

}
