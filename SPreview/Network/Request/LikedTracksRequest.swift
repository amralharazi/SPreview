//
//  LikedTracksRequest.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Alamofire
import Foundation

enum LikedTracksRequest: RequestProtocol {
    
    case getLikedTracks
    case getBatchFrom(url: String)
    
    var host: String {
        switch self {
        case .getLikedTracks:
            return APIConstants.host
        case .getBatchFrom(let url):
            return url
        }
    }
    
    var path: String {
        switch self {
        case .getLikedTracks:
           return "/v1/me/tracks"
        case .getBatchFrom(_):
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
    
    var requestType: HTTPMethod {
        .get
    }
    
    var needsAuthKey: Bool {
        true
    }
}
