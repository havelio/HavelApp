//
//  RealmUtils.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import Foundation
import Just
import UIKit
import RealmSwift
import SwiftyJSON

protocol Sync {
    static var syncUrl: String { get set }
    static func getHeaders() -> [String: String]
    static func handleSuccessSync(json: JSON)
    static func sync(onComplete: ((_ response: HTTPResult) -> Void)?)
}

extension Sync {
    static func getHeaders() -> [String: String] {
        return [
            "Authorization": "token " + API_TOKEN
        ]
    }

    static func sync(onComplete: ((_ response: HTTPResult) -> Void)? = nil) {
        Just.get(syncUrl, headers: getHeaders()) { response in
            DispatchQueue.main.async {
                switch response.result() {
                case .success(let json):
                    handleSuccessSync(json: json)

                case .failure: break
                }
                onComplete?(response)
            }
        }
    }
}
