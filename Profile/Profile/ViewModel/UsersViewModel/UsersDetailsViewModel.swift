//
//  UsersDetailsViewModel.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import Foundation

struct UsersDetailsViewModel {
    let id: Int?
    let name, street, suite, city, zipcode: String?
    init(data: UsersModel) {
        self.id = data.id ?? 0
        self.name = data.name ?? ""
        self.street = data.address?.street ?? ""
        self.suite = data.address?.suite ?? ""
        self.city = data.address?.city ?? ""
        self.zipcode = data.address?.zipcode ?? ""
    }
}

