//
//  Item.swift
//  Todoey
//
//  Created by William Hettinger on 2/16/18.
//  Copyright © 2018 William Hettinger. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
