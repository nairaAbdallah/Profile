//
//  AlbumDetailsViewController.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import UIKit
import NVActivityIndicatorView

class AlbumDetailsViewController: UIViewController {
    
    //MARK: - Variables && Constant
    let refreshControl = UIRefreshControl()
    var refreshFlag = true
    lazy var photosViewModel: PhotosViewModel = {
        return PhotosViewModel()
    }()
    var albumVM: AlbumsViewModel?{
        didSet{
            self.customNavLabel(labelText: albumVM?.title ?? "")
            self.getAlbumData(albumId: albumVM?.id ?? 0)
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var searchOuterView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    //MARK: - IBActions
    @IBAction func searchBtnAction(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackBtn()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupView(){
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        albumCollectionView.contentInset = adjustForTabbarInsets
        albumCollectionView.scrollIndicatorInsets = adjustForTabbarInsets
        
        //MARK: - Register cells
        albumCollectionView.register(UINib(nibName: AlbumCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        albumCollectionView.addSubview(refreshControl)
        
        // to Hide keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        searchOuterView.viewCorner(3)
        searchTF.attributedPlaceholder = NSAttributedString(
            string: "Search in images",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
        )
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTF.becomeFirstResponder()
    }
    
    //MARK: - Refreshing tableView method
    @objc func refresh(_ sender: AnyObject) {
        refreshFlag = false
        OperationQueue().addOperation { [weak self] in
            sleep(2)
            OperationQueue.main.addOperation {
                self?.getAlbumData(albumId: self?.albumVM?.id ?? 0)
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
//MARK: - UITextFieldDelegate Methods
extension AlbumDetailsViewController: UITextFieldDelegate{
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        photosViewModel.filterPhotos(searchText: textField.text ?? "")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK: - UICollectionViewDataSource Methods
extension AlbumDetailsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosViewModel.photosViewMoel?.count ?? 0 > 0 ? (photosViewModel.photosViewMoel?.count ?? 0) : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath)
                as? AlbumCollectionViewCell else {
            fatalError("Cell not exists in cell")
        }
        if photosViewModel.photosViewMoel?.count ?? 0 > indexPath.row {
            cell.initPhoto = photosViewModel.photosViewMoel?[indexPath.row].url ?? ""
        }
        cell.imagePressed = {[weak self] in
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PhotosDetailsViewController.identifier) as? PhotosDetailsViewController else {
                fatalError("controller not exists in controllers")
            }
            if self?.photosViewModel.photosViewMoel?.count ?? 0 > indexPath.row {
                controller.initView = self?.photosViewModel.photosViewMoel?[indexPath.row]
                controller.image = cell.albumImage.image
            }
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate Methods
extension AlbumDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
    }
  
}
//MARK: - setup binding
extension AlbumDetailsViewController{
    func getAlbumData(albumId: Int){
        photosViewModel.apiSuccess = {[weak self] in
            DispatchQueue.main.async(execute: {
                self?.albumCollectionView.reloadData()
            })
        }
        photosViewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.photosViewModel.state {
                case .empty, .error:
                    UIView.animate(withDuration: 0.2, animations: {
                        activityIndicatorView.stopAnimating()
                    })
                case .loading:
                    self.initActivityIndicator(activity: activityIndicatorView)
                case .populated:
                    UIView.animate(withDuration: 0.2, animations: {
                        activityIndicatorView.stopAnimating()
                    })
                }
            }
        }
        photosViewModel.getPhotos(albumId: albumId)
    }
}
