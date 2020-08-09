//
//  tags.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import Foundation
import RealmSwift
import Just

class Tag: Object {

    @objc dynamic var id = 0
    @objc dynamic var name = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    class func all() -> Results<Tag> {
        let realm = try! Realm()
        return realm.objects(Tag.self)
    }
}

