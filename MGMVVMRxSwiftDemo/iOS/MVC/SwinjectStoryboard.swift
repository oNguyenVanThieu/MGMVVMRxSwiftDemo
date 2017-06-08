//
//  SwinjectStoryboard.swift
//  MGMVVMRxSwiftDemo
//
//  Created by Tuan Truong on 6/8/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard
{
    class func setup ()
    {
        Container.loggingFunction = nil
        
        defaultContainer.register(RepoServiceProtocol.self, factory: { _ in return RepoService() })
        
        defaultContainer.storyboardInitCompleted(RepoListViewController.self) { (resolver, controller) in
            controller.repoService = resolver.resolve(RepoServiceProtocol.self)
        }
        defaultContainer.storyboardInitCompleted(EventListViewController.self) { (resolver, controller) in
            controller.repoService = resolver.resolve(RepoServiceProtocol.self)
        }
    }
}
