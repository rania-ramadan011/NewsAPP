//
//  TokenResponse.swift
//  MagrabiPP
//
//  Created by Rania Ramadan on 23/03/2023.
//  Copyright © 2023 sampleapp. All rights reserved.
//

import Foundation

struct TokenResponse:Codable {
    
    let accessToken, tokenType: String
    let expiresIn: Int
    let issued, expires: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case issued = ".issued"
        case expires = ".expires"
    }
}
