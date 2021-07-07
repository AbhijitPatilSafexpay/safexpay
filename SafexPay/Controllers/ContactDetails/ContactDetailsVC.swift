//
//  ContactDetailsVC.swift
//  SafexPay
//
//  Created by Sandeep on 8/13/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import KRProgressHUD

class ContactDetailsVC: UIViewController, UINavigationControllerDelegate {
    // MARK:- Outlets
    @IBOutlet weak var navBarTopView: UIView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var nameTxtFld: UnderLineImageTextField!
    @IBOutlet weak var emailTxtFld: UnderLineImageTextField!
    @IBOutlet weak var numberTxtFld: UnderLineImageTextField!
    
    // MARK:- Properties
    var mechantId = String.empty
    var BrandDetails: BrandingDetail?
    var price = String.empty
    var orderId = String.empty
    
    // MARK:- Lifecycle
    public init() {
        super.init(nibName: "ContactDetailsVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBrandingDetails(data: self.BrandDetails)
        let textFieldArray = [nameTxtFld,emailTxtFld,numberTxtFld]
        for x in textFieldArray {
            x?.addTxtFldBorder()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        self.setupView()
        self.amountLbl.text = Rupee + "" + "\(price)"
        self.orderLbl.text = "Order No." + "" + "\(orderId)"
    }
    // MARK:- Helpers
    func setupView(){
        self.proceedBtn.layer.cornerRadius = 2
        self.proceedBtn.layer.masksToBounds = true
        self.proceedBtn.backgroundColor = headerColor
        self.proceedBtn.applyGradient(colours: gradientColors)
        self.amountView.layer.masksToBounds = true
        self.amountView.addBorders(edges: [.all], color: UIColor.lightGray, thickness: 0.5)
        self.logoView.addBorders(edges: [.all], color: UIColor.lightGray, thickness: 0.5)
    }
    
    private func setBrandingDetails(data: BrandingDetail?){
        if let details = data{
            self.logoImg.setKfImage(with: details.logo)
        }
        self.navBarTopView.backgroundColor = headerColor
        self.navBarBottomView.backgroundColor = headerColor
        self.bgView.backgroundColor = bgColor
       
    }
    
    private func validation(){
        if let name = self.nameTxtFld.text, name.isBlank{
            showAlert(title: "", message: "Enter Customer Name.")
            return
        }
        if let emailText = self.emailTxtFld.text , emailText.isBlank {
            showAlert(title: "", message: "Enter Customer Email.")
            return
        }
        if let email = self.emailTxtFld.text?.replacingOccurrences(of: " ", with: "") , !email.isEmailValid {
            showAlert(title: "", message: "Enter valid Email ID.")
            return
        }
        if let numberText = self.numberTxtFld.text , numberText.isBlank {
            showAlert(title: "", message: "Enter Customer Number.")
            return
        }
        if let number = self.numberTxtFld.text, !number.isValidPhone {
            showAlert(title: "", message: "Enter valid Phone Number.")
            return
        }
//        customerName = self.nameTxtFld.text!
//        customerEmail =
        
        
        
        
        self.goToPaymentMethods()
    }
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        self.validation()
//        self.goToPaymentMethods()
    }
    
    private func goToPaymentMethods(){
        let vc = PaymentModesVC()
        vc.modalPresentationStyle = .fullScreen
        vc.price = self.price
        vc.orderId = self.orderId
        vc.mechantId = self.mechantId
        vc.BrandDetails = self.BrandDetails
        vc.customerName = self.nameTxtFld.text!
        vc.customerEmail = self.emailTxtFld.text!
        vc.customerPhone = self.numberTxtFld.text!
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func closePaymentGateway(_ sender: UIButton) {
        
        let object:[String: Any] = ["onInitiatePaymentFailure": "Cancelled"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onInitiatePaymentFailure"), object: nil, userInfo: object)
        self.dismiss(animated: true, completion: nil)
    }
    
}
