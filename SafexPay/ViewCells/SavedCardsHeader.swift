//
//  SavedCardsHeader.swift
//  SafexPay
//
//  Created by Sandeep on 8/26/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

protocol SavedCardsHeaderProtocol {
    func sectionExpandPressed(tag: Int, view: SavedCardsHeader)
}

class SavedCardsHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionTypeLabel: UILabel!
    @IBOutlet weak var sectionExpandButton: UIButton!
    
    var delegate: SavedCardsHeaderProtocol?
    
    override func awakeFromNib() {}
    
    func setdata(headerLbl:String){
        self.sectionTypeLabel.text = headerLbl
    }
    
    @IBAction func sectionExpandPressed(_ sender: UIButton) {
        self.delegate?.sectionExpandPressed(tag: self.tag, view: self)
    }

}
