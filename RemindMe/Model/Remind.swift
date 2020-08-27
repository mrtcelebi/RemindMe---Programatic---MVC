//
//  Remind.swift
//  RemindMe
//
//  Created by Catalina on 20.08.2020.
//  Copyright © 2020 Catalina. All rights reserved.
//

import Foundation
import RealmSwift

class Remind: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var identifier: String = ""
    @objc dynamic var done: Bool = true
}
