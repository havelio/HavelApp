//
//  biographies.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import Foundation
import Just
import RealmSwift
import SwiftyJSON

class Biography: Object, Sync {
    static var syncUrl: String = "\(HOST)/api/biographies/"

    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var shortDesc = ""
    @objc dynamic var desc = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var position = 0
    @objc dynamic var created: Date!
    @objc dynamic var isActive = true

    let tags = List<Tag>()

    override static func primaryKey() -> String? {
        return "id"
    }

    class func all() -> Results<Biography> {
        let realm = try! Realm()
        return realm.objects(Biography.self).sorted(byKeyPath: "position")
    }

    class func by(tag: Tag) -> Results<Biography> {
        return all().filter("ANY tags.id == %@", tag.id)
    }

    static func handleSuccessSync(json: JSON) {
        let realm = try! Realm()
        realm.beginWrite()

        var ids = [Int]()

        for data in json["tags"].arrayValue {
            let tag = Tag()
            tag.id = data["id"].intValue
            tag.name = data["name"].stringValue

            realm.add(tag, update: .modified)
        }

        for data in json["biographies"].arrayValue {
            let biography = Biography()
            biography.id = data["id"].intValue
            biography.desc = data["desc"].stringValue
            biography.imageUrl = HOST + data["image_url"].stringValue
            biography.position = data["position"].intValue
            biography.shortDesc = data["short_description"].stringValue
            biography.created = .fromTimestamp(data["created"].intValue)
            biography.isActive = true

            let tagIds = data["tag_ids"].arrayValue.map({ $0.intValue })
            let tags = realm.objects(Tag.self).filter("id IN %@", tagIds)
            biography.tags.append(objectsIn: tags)

            realm.add(biography, update: .modified)
            ids.append(biography.id)
        }

        Biography.all().filter("NOT id IN %@", ids).setValue(false, forKey: "isActive")
        try! realm.commitWrite()
    }
}
