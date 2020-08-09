//
//  UIScrollView.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setupRefreshControl(delegate: UIViewController) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        self.alwaysBounceVertical = true
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: 50,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        refreshControl.addTarget(delegate, action: #selector(delegate.refreshValueDidChange), for: .valueChanged)

        let preferLargeTitles = delegate.navigationController?.navigationBar.prefersLargeTitles ?? false

        if delegate.navigationItem.largeTitleDisplayMode != .never && preferLargeTitles {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }

        return refreshControl
    }

    func applyParallaxEffect(to view: UIView) {
        // Update current offset
        let offset = self.contentOffset.y

        // If view controller is pulled down when it's at the top, enlarge header image
        if offset < 0 {
            var transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset, 0)
            let scaleFactor = 1 + (-1 * offset / (view.frame.height / 2))
            transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1)
            view.layer.transform = transform
        } else {
            view.layer.transform = CATransform3DIdentity
        }
    }
}
