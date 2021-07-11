//
//  BrandingDetail.swift
//  SafexPay
//
//  Created by Sandeep on 27/09/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import Foundation

struct BrandingDetail: Codable {
    let logo: String
    let integrationType: String
    let merchantThemeDetails: ThemeDetails

    enum CodingKeys: String, CodingKey {
        case logo
        case integrationType = "integration_type"
        case merchantThemeDetails
    }
}

struct ThemeDetails: Codable {
    let headingBgcolor, bgcolor, menuColor, footerColor: String

    enum CodingKeys: String, CodingKey {
        case headingBgcolor = "heading_bgcolor"
        case bgcolor
        case menuColor = "menu_color"
        case footerColor = "footer_color"
    }
}
