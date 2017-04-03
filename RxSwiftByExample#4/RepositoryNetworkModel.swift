//
//  RepositoryNetworkModel.swift
//  RxSwiftByExample#4
//
//  Created by ParkSunJae on 2017. 4. 3..
//  Copyright © 2017년 Heaven. All rights reserved.
//

import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

struct RepositoryNetworkModel {
    
    lazy var rxRepositories: Driver<[Repository]> = self.fetchRepositories()
    private var repositoryName: Observable<String>
    
    init(with nameObservable: Observable<String>) {
        self.repositoryName = nameObservable
    }
    
    private func fetchRepositories() -> Driver<[Repository]> {
        return repositoryName
            .subscribeOn(MainScheduler.instance)
            .do { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { text in
                return RxAlamofire
                    .requestJSON(.get, "https://api.github.com/users/\(text)/repos")
                    .debug()
                    .catchError { _ in Observable.never() }
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { response, json -> [Repository] in
                guard let repos = Mapper<Repository>().mapArray(JSONArray: json as! [[String : Any]]) else { return [] }
                
                return repos
            }
            .observeOn(MainScheduler.instance)
            .do { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            .asDriver(onErrorJustReturn: [])
    }
}
