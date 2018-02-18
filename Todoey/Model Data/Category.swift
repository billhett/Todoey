//
//  Category.swift
//  Todoey
//
//  Created by William Hettinger on 2/16/18.
//  Copyright © 2018 William Hettinger. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
