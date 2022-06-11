//
//  AlbumsViewModel.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import Foundation

struct AlbumsViewModel {
    let id: Int?
    let title: String?
    init(data: AlbumsModel) {
        self.id = data.id ?? 0
        self.title = data.title ?? ""
    }
}


