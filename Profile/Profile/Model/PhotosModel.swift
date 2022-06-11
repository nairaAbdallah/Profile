//
//  PhotosModel.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import Foundation

// MARK: - PhotosModel
struct PhotosModel: Codable {
    let albumId, id: Int?
    let title, url, thumbnailUrl: String?
}

