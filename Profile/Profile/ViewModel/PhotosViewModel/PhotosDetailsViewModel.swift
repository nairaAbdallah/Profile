//
//  PhotosDetailsViewModel.swift
//  Profile
//
//  Created by naira bassam on 11/06/2022.
//

import Foundation

struct PhotosDetailsViewModel {
    let title,url: String?
    init(data: PhotosModel) {
        self.title = data.title ?? ""
        self.url = data.url ?? ""
    }
}



