//
//  CollectionViewUtils.swift
//  HavelApp
//
//  Created by Havelio Henar on 09/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import UIKit

class CollectionViewDataSource<Cell: BaseCollectionViewCell<Model>, Model>: NSObject, UICollectionViewDataSource {
    typealias PrepareCell = (Cell, IndexPath) -> Void

    private var prepareCell: PrepareCell? = nil
    private var collection: UICollectionView? = nil

    var items: [Model]! {
        didSet { collection?.reloadData() }
    }

    static func make(items: [Model], collection: UICollectionView,
                     prepareCell: PrepareCell? = nil) -> CollectionViewDataSource {

        let colelctionDataSource = CollectionViewDataSource()
        colelctionDataSource.collection = collection
        colelctionDataSource.items = items
        colelctionDataSource.prepareCell = prepareCell

        collection.dataSource = colelctionDataSource
        return colelctionDataSource
    }

    func reload(data: [Model]) {
        self.items = data
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier,
                                                      for: indexPath) as! Cell
        cell.item = items[indexPath.row]
        prepareCell?(cell, indexPath)
        return cell
    }
}

class BaseCollectionViewCell<Model>: UICollectionViewCell {
    class var identifier: String { return String(describing: self) }
    var item: Model!
}
