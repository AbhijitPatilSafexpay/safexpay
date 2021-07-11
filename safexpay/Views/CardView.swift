//
//  CardView.swift
//  SafexPay
//
//  Created by Sandeep on 8/17/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
import SVProgressHUD
class CardView: UIView {
    
    // MARK:- Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payBtn: UIButton!
    
    var mechantId = String.empty
    var price = String.empty
    var orderId = String.empty
    var netbankingData: [PaymentModeDetailsList]?
    private var pgId = String.empty
    private var pgMode = String.empty
    private var schemeId = String.empty
    
    private var cardName = String.empty
    private var cardNo = String.empty
    private var cardMonth = String.empty
    private var cardYear = String.empty
    private var cardCVV = String.empty
    
    // MARK:- Properties
    var isSectionExpanded = false
    var delegate: DetailViewProtocol?
    var customerName = String.empty
    var customerEmail = String.empty
    var customerPhone = String.empty
    var paymentModeDetails: [PaymentMode]?
    
    var datePicker:UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    // MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    // MARK:- Helpers
    func setupCardView(info: [PaymentMode]){
        self.titleLbl.text = info[0].paymentMode
        self.titleImg.image = UIImage(named: info[0].payModeID, in: safexBundle, compatibleWith: nil)
        self.payBtn.backgroundColor = headerColor
        self.payBtn.layer.cornerRadius = 2
        self.payBtn.layer.masksToBounds = true
        self.payBtn.applyGradient(colours: gradientColors)
        
        self.pgId = info[0].payModeID
        self.pgMode = info[0].paymentMode
        self.paymentModeDetails = info
        self.schemeId = info[0].paymentModeDetailsList[0].schemeDetailsResponse.schemeID
        self.setupTableView()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AddCardCell", bundle: safexBundle), forCellReuseIdentifier: "AddCardCell")
        self.tableView.register(UINib(nibName: "SavedCardCollection", bundle: safexBundle), forCellReuseIdentifier: "SavedCardCollection")
        self.tableView.register(UINib(nibName: "SavedCardsHeader", bundle: safexBundle), forHeaderFooterViewReuseIdentifier: "SavedCardsHeader")
    }
    
    @IBAction func backToMainPressed(_ sender: UIButton) {
        self.delegate?.backToMain()
    }
    
    @IBAction func payBtnPressed(_ sender: UIButton) {
        
        self.startPayment()
    }
}

extension CardView {
        private func startPayment(){
    //        KRProgressHUD.show()
    //        DispatchQueue.main.async {
                SVProgressHUD.show()
    //        }
            DataClient.paymentCallback(merchantId: self.mechantId, orderId: self.orderId, orderAmount: self.price, countryCode: "IND", currency: "INR", txnType: "SALE", pgId: self.pgId, pgMode: self.pgMode, schemeId: self.schemeId, installmentMonths: "7", customerName: self.customerName, customerEmail: self.customerEmail, customerMobile: self.customerPhone, customerUniqueId: "12354", isCustomerLoggedIn: "Y", cardDetails: "\(self.cardNo)|\(self.cardMonth)|\(self.cardYear)|\(self.cardCVV)|\(self.cardName)") { (status, data) in
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
        
}

extension CardView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isSectionExpanded{
                return 1
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardCollection") as! SavedCardCollection
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCardCell") as! AddCardCell
            cell.delegate = self
            cell.mechantId = "202105250008"
            cell.loadCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else {
            return 175
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SavedCardsHeader") as! SavedCardsHeader
            view.tag = section
            if isSectionExpanded {
                view.sectionExpandButton.setImage(UIImage(named: "up", in: safexBundle, compatibleWith: nil), for: .normal)
            } else {
                view.sectionExpandButton.setImage(UIImage(named: "down", in: safexBundle, compatibleWith: nil), for: .normal)
            }
            view.delegate = self
            view.setdata(headerLbl: "SAVED CARDS")
            return view
        } else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SavedCardsHeader") as! SavedCardsHeader
            view.tag = section
            view.sectionExpandButton.isHidden = true
            view.setdata(headerLbl: "ADD NEW CARD")
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
}

extension CardView: SavedCardsHeaderProtocol {
    
    func sectionExpandPressed(tag: Int, view: SavedCardsHeader) {
        if isSectionExpanded {
            self.isSectionExpanded = false
            let sections = IndexSet(integer: tag)
            tableView.reloadSections(sections, with: .top)
        } else {
            self.isSectionExpanded = true
            let sections = IndexSet(integer: tag)
            tableView.reloadSections(sections, with: .top)
        }
    }
}

extension CardView: AddCardCellDelegate {
    func addCardDetails(name: String?, cardNo: String?, cvv: String?, month: String?, year: String?, cardType: String?) {
        if let n = name {
            self.cardName = n
        } else if let c = cardNo {
            self.cardNo = c
        } else if let cv = cvv {
            self.cardCVV = cv
        } else if let ct = cardType {
            self.pgId = ct
            if let pmd = self.paymentModeDetails {
            for item in pmd {
                if item.payModeID == ct {
                    self.pgId = item.paymentModeDetailsList[0].pgDetailsResponse.pgID//item.payModeID
                    self.pgMode = ct
                    
                    self.schemeId = item.paymentModeDetailsList[0].schemeDetailsResponse.schemeID
                }
            }
            }
        }
        if let m = month {
            self.cardMonth = m
        }
        if let y = year {
            self.cardYear = y
        }
        
    }
}
