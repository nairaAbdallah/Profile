//
//  PhotosService.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import Foundation
import Alamofire

protocol PhotosService {
    func getPhotos(albumId: Int, completion: @escaping (AFResult<[PhotosModel]>) -> Void)
}

class PhotosServiceImplementation: PhotosService {
    private let service = NetworkService()
    func getPhotos(albumId: Int, completion: @escaping (AFResult<[PhotosModel]>) -> Void) {
        service.performRequest(route: .getPhotos(albumId: albumId), completion: completion)
    }
}


