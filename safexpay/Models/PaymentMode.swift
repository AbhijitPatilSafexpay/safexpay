//
//  PaymentMode.swift
//  SafexPay
//
//  Created by Sandeep on 9/3/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import Foundation

struct PaymentMode: Codable {
    let paymentMode, payModeID: String
    let paymentModeDetailsList: [PaymentModeDetailsList]

    enum CodingKeys: String, CodingKey {
        case paymentMode
        case payModeID = "payModeId"
        case paymentModeDetailsList
    }
}

struct PaymentModeDetailsList: Codable, Equatable {
    let schemeDetailsResponse: SchemeDetailsResponse
    let pgDetailsResponse: PGDetailsResponse
    let webViewURL: String?

    enum CodingKeys: String, CodingKey {
        case schemeDetailsResponse, pgDetailsResponse
        case webViewURL = "webViewUrl"
    }
}

struct PGDetailsResponse: Codable, Equatable {
    let pgID, pgName: String

    enum CodingKeys: String, CodingKey {
        case pgID = "pg_id"
        case pgName = "pg_name"
    }
}

// MARK: - SchemeDetailsResponse
struct SchemeDetailsResponse: Codable, Equatable {
    let schemeID: String
    let schemeName: String

    enum CodingKeys: String, CodingKey {
        case schemeID = "schemeId"
        case schemeName
    }
}

//static payment mode

struct StaticPaymentMode {
    let paymentMode:  String
    let payModeID: [String]
    let paymentModeDetailsList: [PaymentModeDetailsList]
}
