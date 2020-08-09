//
//  ImageVIiewController.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import UIKit
import RealmSwift

class CollectionViewController: UIViewController {
    
    var tag: Tag?
    var biographies: Results<Biography>!
    var dataSource: CollectionViewDataSource<BiographyCell, Biography>!
    var notificationToken: NotificationToken?

    @IBOutlet weak var collectionView: UICollectionView!

    class func instantiate(tag: Tag? = nil) -> CollectionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: "CollectionViewController") as! CollectionViewController

        controller.tag = tag
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        biographies = Biography.all()
        dataSource = .make(items: Array(biographies), collection: collectionView)

        notificationToken = biographies.observe({ [weak self] change in
            guard let _self = self, !_self.biographies.isInvalidated else { return }

            _self.dataSource.reload(data: Array(_self.biographies))
        })
    }

    deinit {
        notificationToken?.invalidate()
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth = (view.frame.width - 43) / 2
        return CGSize(width: cellWidth, height: cellWidth) // 1:1
    }
}
