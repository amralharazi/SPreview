//
//  AccessTokens.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

struct AccessTokens: Codable {
    let access_token: String?
    let token_type: String?
    let expires_in: Int?
    let refresh_token: String?
}
