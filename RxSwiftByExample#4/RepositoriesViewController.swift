//
//  RepositoriesViewController.swift
//  RxSwiftByExample#4
//
//  Created by ParkSunJae on 2017. 4. 3..
//  Copyright © 2017년 Heaven. All rights reserved.
//

import UIKit

import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

class RepositoriesViewController: UIViewController {
    
    // MARK: - Rx
    let disposeBag = DisposeBag()
    var repositoryNetworkModel: RepositoryNetworkModel!
    
    var rxSearchBarText: Observable<String> {
        return searchBar
            .rx.text
            .orEmpty    //  ?!?
            .filter { $0.characters.count > 0 }
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    func setupRx() {
        repositoryNetworkModel = RepositoryNetworkModel(with: rxSearchBarText)
        
        repositoryNetworkModel.rxRepositories
            .drive(tableView.rx.items) { tableView, row, repository in
                let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = repository.name
                
                return cell
            }
            .addDisposableTo(disposeBag)
        
        repositoryNetworkModel.rxRepositories.drive(onNext: { repositories in
            if repositories.count == 0 {
                let alert = UIAlertController(title: ":(", message: "No repositories for this user.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                if self.navigationController?.visibleViewController?.isMember(of: UIAlertController.self) != true {
                    self.present(alert, animated: true)
                }
            }
        })
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
    }
}

