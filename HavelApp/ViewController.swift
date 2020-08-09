//
//  ViewController.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    typealias GaleryController = CollectionViewController

    var tags: Results<Tag>!
    var notificationToken: NotificationToken?
    var refreshControl: UIRefreshControl?

    private var selectedTag: Tag?
    private var selectedTagCell: TagCell? {
        willSet { selectedTagCell?.removeHighlight() }
        didSet { selectedTagCell?.highlight() }
    }

    var pageController: UIPageViewController?
    var pageControllerContents = [GaleryController]()
    weak var selectedPageController: GaleryController? {
        didSet {
//            selectedPageController?.collectionView.adjustHeight(for: pageControllerHeightConstraint)
        }
    }
    var dataSource: CollectionViewDataSource<TagCell, Tag>!

    @IBOutlet weak var pageControllerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .top
        scrollView.contentInsetAdjustmentBehavior = .never

        tags = Tag.all()
        dataSource = .make(items: Array(tags), collection: collectionView)

        notificationToken = tags.observe({ [weak self] change in
            guard let _self = self, !_self.tags.isInvalidated else { return }

            _self.dataSource.reload(data: Array(_self.tags))
        })
        setupPageController()
        refreshControl = scrollView.setupRefreshControl(delegate: self)
        syncData()
    }

    override func refreshValueDidChange() {
        syncData()
    }

    func syncData() {
        Biography.sync { _ in
            self.refreshControl?.endRefreshing()
            self.selectedPageController?.collectionView.adjustHeight(for: self.pageControllerHeightConstraint)
        }
    }

    deinit {
        notificationToken?.invalidate()
    }

    func select(tag: Tag?, animate: Bool) {
        var indexPath: IndexPath!

        if let category = tag,
           let categoryIndex = tags.index(of: category) {

            indexPath = IndexPath(row: categoryIndex, section: 0)
        } else {
            indexPath = IndexPath(row: 0, section: 0)
        }

        var delay: DispatchTime! = .now()
        if animate {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            delay = .now() + 0.3
        }

        DispatchQueue.main.asyncAfter(deadline: delay) {
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? TagCell else {
                return
            }

            self.selectedTag = cell.item
            self.selectedTagCell = cell

            if self.selectedPageController?.tag != tag,
                let controller = self.pageControllerContents.first(where: { $0.tag == tag }) {
                self.selectedPageController = controller
                self.pageController?.setViewControllers([controller], direction: .forward,
                                                        animated: false, completion: nil)
            }
        }
    }
}

extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func setupPageController() {
        pageController = nil
        pageController = self.children.last as? UIPageViewController
        pageController?.delegate = self

        pageControllerContents.append(contentsOf:
            tags.map({ GaleryController.instantiate(tag: $0) })
        )

        pageController?.dataSource = pageControllerContents.count > 1 ? self : nil

        if let content = pageControllerContents.first, pageController?.viewControllers?.isEmpty ?? true {
            pageController?.setViewControllers([content], direction: .forward, animated: false, completion: nil)
            selectedPageController = pageController?.viewControllers?.first as? GaleryController
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pageControllerContents.firstIndex(
            of: viewController as! GaleryController) else {
                return nil
        }
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return pageControllerContents.last
        }
        guard pageControllerContents.count > previousIndex else { return nil }
        return pageControllerContents[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pageControllerContents.firstIndex(
            of: viewController as! GaleryController) else {
                return nil
        }
        let nextIndex = viewControllerIndex + 1

        guard pageControllerContents.count != nextIndex else {
            return pageControllerContents.first
        }
        guard pageControllerContents.count > nextIndex else { return nil }
        return pageControllerContents[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {

        guard completed else { return }
        if let controller = pageViewController.viewControllers?.first as? GaleryController {
            selectedPageController = controller
            select(tag: controller.tag, animate: true)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? TagCell
        select(tag: cell?.item, animate: false)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = tags[indexPath.row].name
        label.font = UIFont.systemFont(ofSize: 13)
        label.sizeToFit()

        let cellWidth = max(60, min(label.bounds.width, 200))
        return CGSize(width: cellWidth, height: 30)
    }
}
