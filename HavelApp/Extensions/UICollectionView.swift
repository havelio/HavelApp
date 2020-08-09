//
//  UICollectionView.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import UIKit

extension UICollectionView {
    func adjustHeight(for heighConstraint: NSLayoutConstraint) {
        self.layoutIfNeeded()
        heighConstraint.constant = self.contentSize.height
    }
}
