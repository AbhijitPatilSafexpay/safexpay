//
//  AddCardCell.swift
//  SafexPay
//
//  Created by Sandeep on 8/17/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

protocol AddCardCellDelegate {
    func addCardDetails(name: String?, cardNo:String?, cvv:String?, month:String?, year: String?, cardType: String?)
}
class AddCardCell: UITableViewCell {

    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var cardNoTxt: UITextField!
    
    @IBOutlet weak var cvvTxt: UITextField!
    
    @IBOutlet weak var dataTimeLbl: UILabel!
    
    @IBOutlet weak var dateTimeView: UIView!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    @IBAction func nameValueChanged(_ sender: Any) {
        if let delegate = self.delegate {
            
            delegate.addCardDetails(name: self.nameTxt.text, cardNo: nil, cvv: nil, month: nil, year: nil, cardType: nil)
            
        }
    }
    
    @IBAction func cardNoValueChanged(_ sender: Any) {
        if let delegate = self.delegate {
            
            delegate.addCardDetails(name: nil, cardNo: self.cardNoTxt.text, cvv: nil, month: nil, year: nil, cardType: nil)
            
        }
        
        if self.cardNoTxt.text?.count == 6 {
            DataClient.getCardType(merchantId: mechantId, cardBin: self.cardNoTxt.text!) { status, response in
                
                if (status) {
                                            self.decryptSavedCards(encData: response!)
                }
            }
        }
    }
    
    @IBAction func cvvValueChanged(_ sender: Any) {
        
        var targetCursorPosition = 0
        if let textField = sender as? UITextField {
            var cardNumberWithoutSpaces = ""
//            var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }

        if cardNumberWithoutSpaces.count > 3 {
            self.cvvTxt.text = cardNumberWithoutSpaces
       
            return
        }
        if let delegate = self.delegate {
            delegate.addCardDetails(name: nil, cardNo: nil, cvv: self.cvvTxt.text, month: nil, year: nil, cardType: nil)
        }
        }
    }
    
    var delegate: AddCardCellDelegate?
    var mechantId = String.empty
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCell()  {
        self.nameTxt.delegate = self
        self.cardNoTxt.delegate = self
        self.cvvTxt.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.datePickerPressed(_:)))
        self.dateTimeView.addGestureRecognizer(gesture)
        self.cardNoTxt.delegate = self
        self.cvvTxt.delegate = self
        self.cardNoTxt.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
//        self.cvvTxt.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
    }
}

extension AddCardCell: UITextFieldDelegate {
    
    @objc func datePickerPressed(_ sender:UITapGestureRecognizer){

        let myDatePicker = CLIVEDatePickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        
            let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
            alertController.view.addSubview(myDatePicker)
            let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                if let delegate = self.delegate {
                    delegate.addCardDetails(name: nil, cardNo: nil, cvv: nil, month: myDatePicker.date[0], year: myDatePicker.date[1], cardType: nil)
                }
                self.dataTimeLbl.text = "\(myDatePicker.date[0])/\(myDatePicker.date[1])"
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)
        self.viewContainingController()!.present(alertController, animated: true)
        
        }
    
    
    private func decryptSavedCards(encData: String){
        let payloadResponse = AESClient.AESDecrypt(dataToDecrypt: encData, decryptionKey: AESData.decryptKey)
        
        do{
            if let json = payloadResponse.data(using: String.Encoding.utf8){
                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                    print(jsonData)
                    if let delegate = self.delegate {
                        delegate.addCardDetails(name: nil, cardNo: nil, cvv: nil, month: nil, year: nil, cardType: (jsonData["card_type"] as! String))
                    }
                }
            }
        }catch {
            print(error.localizedDescription)

        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNoTxt {
           previousTextFieldContent = textField.text;
           previousSelection = textField.selectedTextRange;
        } else if textField == self.cvvTxt {
            if textField.text!.count > 2 {
//            if cardNumberWithoutSpaces.count > 3 {
//                self.cvvTxt.text = cardNumberWithoutSpaces
           
                return false
            }
        }
           return true
       }

       @objc func reformatAsCardNumber(textField: UITextField) {
           var targetCursorPosition = 0
           if let startPosition = textField.selectedTextRange?.start {
               targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
           }

           var cardNumberWithoutSpaces = ""
           if let text = textField.text {
               cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
           }

           if cardNumberWithoutSpaces.count > 16 {
               textField.text = previousTextFieldContent
               textField.selectedTextRange = previousSelection
               return
           }

           let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
           textField.text = cardNumberWithSpaces

           if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
               textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
           }
       }

       func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
           var digitsOnlyString = ""
           let originalCursorPosition = cursorPosition

           for i in Swift.stride(from: 0, to: string.count, by: 1) {
               let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
               if characterToAdd >= "0" && characterToAdd <= "9" {
                   digitsOnlyString.append(characterToAdd)
               }
               else if i < originalCursorPosition {
                   cursorPosition -= 1
               }
           }

           return digitsOnlyString
       }

       func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
           // Mapping of card prefix to pattern is taken from
           // https://baymard.com/checkout-usability/credit-card-patterns

           // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
           let is456 = string.hasPrefix("1")

           // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
           // as 4-6-5-4 to err on the side of always letting the user type more digits.
           let is465 = [
               // Amex
               "34", "37",

               // Diners Club
               "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
           ].contains { string.hasPrefix($0) }

           // In all other cases, assume 4-4-4-4-3.
           // This won't always be correct; for instance, Maestro has 4-4-5 cards according
           // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
           // know what prefixes identify particular formats.
           let is4444 = !(is456 || is465)

           var stringWithAddedSpaces = ""
           let cursorPositionInSpacelessString = cursorPosition

           for i in 0..<string.count {
               let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
               let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
               let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)

               if needs465Spacing || needs456Spacing || needs4444Spacing {
                   stringWithAddedSpaces.append(" ")

                   if i < cursorPositionInSpacelessString {
                       cursorPosition += 1
                   }
               }

               let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
               stringWithAddedSpaces.append(characterToAdd)
           }

           return stringWithAddedSpaces
       }
}
