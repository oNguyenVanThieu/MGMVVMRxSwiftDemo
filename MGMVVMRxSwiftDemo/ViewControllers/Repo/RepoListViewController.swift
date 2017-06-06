//
//  RepoListViewController.swift
//  MGMVVMRxSwiftDemo
//
//  Created by Tuan Truong on 6/5/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class RepoListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var refreshButton: UIBarButtonItem!
    
    let repoService = RepoService()
    let bag = DisposeBag()
    
    var repoList = Variable<[Repo]>([])
    
    var loadDataAction: Action<Void, RepoListOutput>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: RepoCell.cellIdentifier, bundle: nil),
                           forCellReuseIdentifier: RepoCell.cellIdentifier)
        
        repoList.asObservable()
            .subscribe ( onNext: { [weak self] repoList in
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        
        loadDataAction = Action { [weak self] in
            guard let strongSelf = self else { return Observable.just(RepoListOutput()) }
            return strongSelf.repoService.repoList(input: RepoListInput())
        }
        
        loadDataAction
            .elements
            .subscribe(onNext: { [weak self](output) in
                self?.repoList.value = output.repositories ?? []
            }, onError: { (error) in
                print("1)", error)
            })
            .disposed(by: bag)
        
        loadDataAction
            .errors
            .subscribe(onError: { (error) in
                print("2)", error)
            })
            .disposed(by: bag)
        
        refreshButton.rx
            .bind(to: loadDataAction) { _ in }
        
        loadDataAction.execute()

//        repoService.repoList(input: RepoListInput())
//            .subscribe(onNext: { [weak self] (output) in
//                self?.repoList.value = output.repositories ?? []
//            }, onError: { (error) in
//                print(error)
//            })
//            .disposed(by: bag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventList" {
            if let controller = segue.destination as? EventListViewController,
                let repo = sender as? Repo {
                controller.repo = Variable(repo)
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = repoList.value[indexPath.row]
        self.performSegue(withIdentifier: "showEventList", sender: repo)
    }
}


