//
//  ImageView.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(url: String) {
        self.kf.setImage(with: URL(string: url),
                         options: [.transition(.fade(0.2)), .cacheOriginalImage])
    }
}
