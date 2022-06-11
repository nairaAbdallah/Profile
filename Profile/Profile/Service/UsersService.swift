//
//  UsersService.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import Foundation
import Alamofire

protocol UserService {
    func getUsers(completion: @escaping (AFResult<[UsersModel]>) -> Void)
    func getAlbums(userId: Int, completion: @escaping (AFResult<[AlbumsModel]>) -> Void)
}

class UserServiceImplementation: UserService {
    private let service = NetworkService()
    func getUsers(completion: @escaping (AFResult<[UsersModel]>) -> Void) {
        service.performRequest(route: .getUsers, completion: completion)
    }
    func getAlbums(userId: Int, completion: @escaping (AFResult<[AlbumsModel]>) -> Void) {
        service.performRequest(route: .getAlbums(userId: userId), completion: completion)
    }
}

