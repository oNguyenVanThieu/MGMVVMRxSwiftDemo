//
//  EventList.swift
//  MGMVVMRxSwiftDemo
//
//  Created by Tuan Truong on 6/5/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import ObjectMapper

class EventListInput: APIInput {
    init(repoFullName: String) {
        super.init(urlString: String(format: URLs.eventList, repoFullName),
                   parameters: nil,
                   requestType: .get)
    }
}

struct EventListOutput {
    let events: [Event]
}
