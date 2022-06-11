//
//  PhotosViewModel.swift
//  Profile
//
//  Created by naira bassam on 11/06/2022.
//

import Foundation

class PhotosViewModel {
   
    init(apiService: PhotosService = PhotosServiceImplementation()){
        self.apiService = apiService
    }

    //MARK: - Variables && Constant
    let apiService: PhotosService
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
    
    var getPhotos: [PhotosModel]?{
        didSet {
            self.processFetchedPhotos(photos: getPhotos)
            self.apiSuccess?()
        }
    }
    
    var photosViewMoel: [PhotosDetailsViewModel]?{
        didSet {
            self.apiSuccess?()
        }
    }
    var photosCopyViewMoel: [PhotosDetailsViewModel]?{
        didSet {
            self.apiSuccess?()
        }
    }
    
    func filterPhotos(searchText: String){
        photosViewMoel = photosCopyViewMoel
        var photosSearchResult: [PhotosDetailsViewModel] = []
        photosViewMoel = photosViewMoel?.filter({ (photo: PhotosDetailsViewModel) in
            if photo.title?.lowercased().contains(searchText.lowercased()) == true{
                photosSearchResult.append(photo)
            }
            return photo.title?.lowercased().contains(searchText.lowercased()) != nil
        })
        if searchText == ""{
            photosViewMoel = photosCopyViewMoel
        }else{
            photosViewMoel = photosSearchResult
        }
    }
    
    private func processFetchedPhotos(photos: [PhotosModel]?){
        var photosVM: [PhotosDetailsViewModel] = []
        if photos?.count ?? 0 > 0 {
            photos?.forEach({ data in
                photosVM.append(PhotosDetailsViewModel(data: data))
            })
        }
        self.photosViewMoel = photosVM
        self.photosCopyViewMoel = photosVM
    }
    
    func getPhotos(albumId: Int){
        state = .loading
        apiService.getPhotos(albumId: albumId){[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                if data.count > 0{
                    self.getPhotos = data
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
