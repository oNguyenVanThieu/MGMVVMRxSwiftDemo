//
//  RepoListViewController.swift
//  MGMVVMRxSwiftDemo
//
//  Created by Tuan Truong on 6/5/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import RxAlamofire
import RxSwift

class RepoListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let service = RepoService()
    let bag = DisposeBag()
    
    var repoList = Variable<[Repo]>([])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: RepoCell.cellIdentifier, bundle: nil),
                           forCellReuseIdentifier: RepoCell.cellIdentifier)
        
        repoList.asObservable()
            .subscribe ( onNext: { [weak self] repoList in
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        

        service.repoList(input: RepoListInput())
            .subscribe(onNext: { [weak self] (output) in
                self?.repoList.value = output.repositories ?? []
            }, onError: { (error) in
                print(error)
            })
            .disposed(by: bag)
    }

}

// MARK: - UITableViewDataSource
extension RepoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.cellIdentifier, for: indexPath)
        config(cell, at: indexPath)
        return cell
    }
    
    private func config(_ cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? RepoCell {
            cell.repo = repoList.value[indexPath.row]
        }
    }
}

// MARK: - UITableViewDelegate
extension RepoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}


