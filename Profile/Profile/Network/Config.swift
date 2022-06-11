//
//  Config.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import UIKit

struct Config {
    static let baseURL: String = "https://jsonplaceholder.typicode.com"
    struct EndpointPath {
        static let getUsers = "/users"
        static let getAlbums = "/albums"
        static let getPhotos = "/photos"
    }
}
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case securitykey = "secKey"
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}

public enum State {
    case loading
    case error
    case empty
    case populated
}

