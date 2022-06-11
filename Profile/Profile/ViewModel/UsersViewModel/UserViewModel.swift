//
//  UserViewModel.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import Foundation

class UserViewModel {
   
    init(apiService: UserService = UserServiceImplementation()){
        self.apiService = apiService
    }

    //MARK: - Variables && Constant
    let apiService: UserService
    var apiSuccess: (() -> Void)?
    var apiFailed: ((_ message: String) -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    // get user variables
    var selectedUser: UsersModel?{
        didSet {
            self.processFetchedUser(user: selectedUser)
            self.apiSuccess?()
        }
    }
    
    var userViewModel: UsersDetailsViewModel?{
        didSet {
            apiSuccess?()
        }
    }
    
    // get albums variables
    var userAlbums: [AlbumsModel]?{
        didSet {
            self.processFetchedAlbums(albums: userAlbums)
            self.apiSuccess?()
        }
    }
    var userAlbumsViewMoel: [AlbumsViewModel]?{
        didSet {
            self.apiSuccess?()
        }
    }
}

//MARK: - get user methods
extension UserViewModel{
    private func processFetchedUser(user: UsersModel?) {
        if let user = user {
            self.userViewModel = UsersDetailsViewModel(data: user)
            if let userId = user.id{
                self.getAlbums(userId: userId)
            }
        }
    }
    
    func getUser(){
        state = .loading
        apiService.getUsers(){[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                if data.count > 0{
                    self.selectedUser = data.randomElement()
                }
                self.apiSuccess?()
                self.state = .populated
            case .failure(let error):
                self.state = .error
                self.alertMessage = error.errorDescription
                return
            }
        }
    }
}
//MARK: - get albums methods
extension UserViewModel{
    private func processFetchedAlbums(albums: [AlbumsModel]?){
        var userAlbumsVM: [AlbumsViewModel] = []
        if albums?.count ?? 0 > 0 {
            albums?.forEach({ data in
                userAlbumsVM.append(AlbumsViewModel(data: data))
            })
        }
        self.userAlbumsViewMoel = userAlbumsVM
    }
    
    func getAlbums(userId: Int){
        state = .loading
        apiService.getAlbums(userId: userId){[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                if data.count > 0{
                    self.userAlbums = data
                }
                self.apiSuccess?()
                self.state = .populated
            case .failure(let error):
                self.state = .error
                self.alertMessage = error.errorDescription
                return
            }
        }
    }
}
