//
//  CollectionViewCell.swift
//  HavelApp
//
//  Created by Havelio Henar on 09/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import UIKit

class TagCell: BaseCollectionViewCell<Tag> {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var nameLabelWidthConstraint: NSLayoutConstraint!

    override var item: Tag! {
        didSet {
            nameLabel.text = item.name
            nameLabel.sizeToFit()
            nameLabelWidthConstraint.constant = self.frame.width
            layoutIfNeeded()
        }
    }

    func highlight() {
        DispatchQueue.main.async {
            self.separator.isHidden = false
            self.nameLabel.textColor = .systemTeal
        }
    }

    func removeHighlight() {
        DispatchQueue.main.async {
            self.separator.isHidden = true
            self.nameLabel.textColor = .lightGray
        }
    }
}

class BiographyCell: BaseCollectionViewCell<Biography> {
    @IBOutlet weak var imageView: UIImageView!

    override var item: Biography! {
        didSet {
            imageView.setImage(url: item.imageUrl)
        }
    }
}
