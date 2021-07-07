//
//  DataService.swift
//  SafexPay
//
//  Created by Sandeep on 11/09/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import Foundation
import Alamofire

class DataService {

    private init() {}
    static var instance = DataService()
    
    //User Defaults Reference
    let defaults = UserDefaults.standard

    func getRequest(url:String, header:HTTPHeaders?,completion: @escaping (_ status:Bool, _ data:Any?)->()) {
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header).responseString { response in
            if response.response?.statusCode == 200 {
                completion(true,response.value)
            }else{
                completion(false,nil)
            }
        }
    }
    
    func getRequestDictnry(url:String, header:HTTPHeaders?,completion: @escaping (_ sataus:Bool,_ data:NSDictionary?)->()) {
         AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            if let responseJson = response.value as? NSDictionary {
                if let errorDetails = responseJson.value(forKey: "error_details") as? NSDictionary {
                    if errorDetails.value(forKey: "error_code") as? String == "1" {
                        completion(true,responseJson)
                    }else {
                        completion(false,nil)
                    }
                }
            } else {
                completion(false,nil)
            }
        }
     }

    func postRequest(url:String, postParam: [String : Any], header:HTTPHeaders?,completion: @escaping (_ sataus:Bool,_ data:NSDictionary?)->()) {
        AF.request(url, method: .post, parameters: postParam, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if response.response?.statusCode == 200 {
                    if let data = response.value as? NSDictionary{
                        completion(true,data)
                    }else{
                        completion(false,nil)
                    }
                }else{
                    completion(false,nil)
                }
            case .failure(let error):
                print(error)
                completion(false,nil)
            }
            
        }
    }
    
    func postRequestString(url:String, postParam: [String : Any], header:HTTPHeaders?,completion: @escaping (_ sataus:Bool,_ data:Any?)->()) {
        AF.request(url, method: .post, parameters: postParam, encoding: JSONEncoding.default, headers: header).responseString { response in
            if response.response?.statusCode == 200 {
                completion(true,response.value)
            }else{
                completion(false,nil)
            }
        }
    }
    
}
