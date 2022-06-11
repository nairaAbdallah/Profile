//
//  NetworkRouter.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
    // MARK: - cases
    case getUsers
    case getAlbums(userId: Int)
    case getPhotos(albumId: Int)
    
    // MARK: - methods
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    // MARK: - paths
    var path: String {
        switch self {
        case .getUsers:
            return Config.EndpointPath.getUsers
        case .getAlbums:
            return Config.EndpointPath.getAlbums
        case .getPhotos:
            return Config.EndpointPath.getPhotos
        }
    }
    
    // MARK: - parameters
    var parameters: Parameters? {
        switch self {
        case .getAlbums(let userId):
            let parameters = ["userId":userId] as [String : Any]
            return parameters
        case .getPhotos(let albumId):
            let parameters = ["albumId":albumId] as [String : Any]
            return parameters
        default:
            return nil
        }
    }
    
    // MARK: - URLRequest
    func asURLRequest() throws -> URLRequest {
        let url = try Config.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        switch self {
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
    
}

