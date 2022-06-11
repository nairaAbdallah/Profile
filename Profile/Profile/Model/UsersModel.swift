//
//  UsersModel.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import Foundation

// MARK: - UsersModel
struct UsersModel: Codable {
    let id: Int?
    let name, username, email, phone, website: String?
    let address: AddressModel?
    let company: CompanyModel?
}
// MARK: - AddressModel
struct AddressModel: Codable {
    let street, suite, city, zipcode: String?
    let geo: GeoModel?
}
// MARK: - GeoModel
struct GeoModel: Codable {
    let lat, lng: String?
  
}

// MARK: - CompanyModel
struct CompanyModel: Codable {
    let name, catchPhrase, bs: String?
}

