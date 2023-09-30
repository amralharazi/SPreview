//
//  TokenRequest.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Alamofire
import Foundation

enum TokenRequest: RequestProtocol {
    
    case getAuthKeys(code: String)
    case getRefreshedToken
    
    var host: String {
        "https://\(APIConstants.authHost)"
    }
    
    var path: String {
        "/api/token"
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.httpBody
    }
    
    var requestType: HTTPMethod {
        .post
    }
    
    var needsAuthKey: Bool {
        false
    }
    
    var params: [String : Any] {
        var params = [String : Any]()
        switch self {
        case .getAuthKeys(let code):
            params["grant_type"] = "authorization_code"
            params["code"] = code
            params["redirect_uri"] = APIConstants.redirectUri
        case .getRefreshedToken:
            params["grant_type"] = "refresh_token"
            params["refresh_token"] = TokenManager.shared.fetchRefreshToken()
        }
        return params
    }
    
    var headers: HTTPHeaders {
        let clientAndSecertKey = "\(SpotifyAuthKeys.clientId):\(SpotifyAuthKeys.secretKey)"
        let spotifyAuthKeyData = clientAndSecertKey.data(using: .utf8)
        let authKeyBase64 = spotifyAuthKeyData?.base64EncodedString() ?? ""
        let headers: HTTPHeaders = ["Authorization": "Basic \(authKeyBase64)",
                                    "Content-Type": "application/x-www-form-urlencoded"]
        return headers
    }
}

// MARK: Helpers
extension TokenRequest {
    static func getAccessTokenRequest() -> URLRequest? {
        let scopeAsString = APIConstants.scopes.joined(separator: " ")
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIConstants.authHost
        components.path = "/authorize"
        
        let params  = [
            "response_type": APIConstants.responseType,
            "client_id": SpotifyAuthKeys.clientId,
            "redirect_uri": APIConstants.redirectUri,
            "scope": scopeAsString]
        
        components.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
        
        guard let url = components.url else {return nil}
        return try? URLRequest(url: url, method: .get)
    }
}
