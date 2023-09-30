//
//  SavedTracksRequest.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Alamofire
import Foundation

enum SavedTracksRequest: RequestProtocol {
    
    case getSavedTracks
    case getBatchFrom(url: String)
    
    var host: String {
        switch self {
        case .getSavedTracks:
            return APIConstants.host
        case .getBatchFrom(let url):
            return url
        }
    }
    
    var path: String {
        switch self {
        case .getSavedTracks:
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
