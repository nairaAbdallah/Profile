//
//  ProfileViewController.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import UIKit
import NVActivityIndicatorView

class ProfileViewController: UIViewController {
    
    //MARK: - Variables && Constant
    var refreshFlag = true
    let refreshControl = UIRefreshControl()
    lazy var userViewModel: UserViewModel = {
        return UserViewModel()
    }()
    
    //MARK: - IBOutlets
    @IBOutlet weak var profileTableView: UITableView!
    
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        setupTableView()
        getProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView(){
        profileTableView.dataSource = self
        profileTableView.delegate = self
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        profileTableView.contentInset = adjustForTabbarInsets
        profileTableView.scrollIndicatorInsets = adjustForTabbarInsets
        profileTableView.tableFooterView = UIView(frame: .zero)
        
        //MARK: - Register cells
        profileTableView.register(UINib(nibName: ProfileHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileHeaderTableViewCell.identifier)
        profileTableView.register(UINib(nibName: AlbumsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AlbumsTableViewCell.identifier)
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        profileTableView.addSubview(refreshControl)
        
    }
    
    //MARK: - Refreshing tableView method
    @objc func refresh(_ sender: AnyObject) {
        refreshFlag = false
        OperationQueue().addOperation { [weak self] in
            sleep(2)
            OperationQueue.main.addOperation {
                self?.getProfileData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

//MARK: - UITableViewDataSource Methods
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.userAlbumsViewMoel?.count ?? 0 > 0 ? (userViewModel.userAlbumsViewMoel?.count ?? 0) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumsTableViewCell.identifier, for: indexPath) as? AlbumsTableViewCell else {
            fatalError("Cell not exists in cell")
        }
        if userViewModel.userAlbumsViewMoel?.count ?? 0 > indexPath.row{
            cell.albumsTitle = userViewModel.userAlbumsViewMoel?[indexPath.row]
        }
        return cell
    }
}

//MARK: - UITableViewDelegate Methods
extension ProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderTableViewCell.identifier) as? ProfileHeaderTableViewCell else {
            fatalError("Cell not exists in cell")
        }
        if userViewModel.userViewModel != nil{
            cell.profileDetails = userViewModel.userViewModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AlbumDetailsViewController.identifier) as? AlbumDetailsViewController else {
            fatalError("controller not exists in controllers")
        }
        if userViewModel.userAlbumsViewMoel?.count ?? 0 > indexPath.row{
            controller.albumVM = userViewModel.userAlbumsViewMoel?[indexPath.row]
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - setup binding
extension ProfileViewController{
    func getProfileData(){
        userViewModel.apiSuccess = {[weak self] in
            DispatchQueue.main.async(execute: {
                self?.profileTableView.reloadData()
            })
        }
        userViewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.userViewModel.state {
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
        userViewModel.getUser()
    }
}
