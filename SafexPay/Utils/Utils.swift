//
//  Utils.swift
//  SafexPay
//
//  Created by Sandeep on 27/09/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import Foundation

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func convertToArrayDictionary(text: String) -> [[String: Any]]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func jsonToString(json: [String:String]) -> String?{
    do {
        let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//        print(convertedString) // <-- here is ur string
        return convertedString
    } catch let myJSONError {
        print(myJSONError)
        return nil
    }
}

func jsonToAny(json: [String:Any]) -> String?{
    do {
        let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
        return convertedString
    } catch let myJSONError {
        print(myJSONError)
        return nil
    }
    
}
