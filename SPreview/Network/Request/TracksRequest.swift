//
//  TracksRequest.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Alamofire
import Foundation

enum TracksRequest: RequestProtocol {
    
    case getLikedTracks
    case getSongsWith(searchTerm: String)
    case getBatchFrom(url: String)
    
    var host: String {
        switch self {
        case .getBatchFrom(let url):
            return url
        default:
            return APIConstants.host
        }
    }
    
    var path: String {
        switch self {
        case .getLikedTracks:
            return "/v1/me/tracks"
        case .getSongsWith(_):
            return "/v1/search"
        case .getBatchFrom(_):
            return ""
        }
    }
    
    var params: [String : Any] {
        var params = [String : Any]()
        switch self {
        case .getSongsWith(let searchTerm):
            params["q"] = searchTerm
            params["type"] = "track"
        default:
            break
        }
        return params
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
