//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    private var layoutType = OpenMarketCellLayoutType.list
    private var nextPageToLoad: Int = 1
    private let openMarketListDataStorage = OpenMarketListDataStorage()
    
    // MARK: - Views
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshItemList), for: .valueChanged)
        refreshControl.tintColor = .systemBlue
        return refreshControl
    }()
    
    private let openMarketCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.register(OpenMarketListCollectionViewCell.self, forCellWithReuseIdentifier: OpenMarketListCollectionViewCell.identifier)
        collectionView.register(OpenMarketGridCollectionViewCell.self, forCellWithReuseIdentifier: OpenMarketGridCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var segmentedController: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.sizeToFit()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var UIRightBarButtonItem: UIBarButtonItem = {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        return addItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpActivityIndicator()
        setUpNavigationItems()
        configureCollectionViewConstraint()
        getOpenMarketItemList()
        notifiedToRefreshData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (_) in
            self.openMarketCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    // MARK: - Setup CollectionView
    
    private func setUpCollectionView() {
        self.view.addSubview(openMarketCollectionView)
        openMarketCollectionView.delegate = self
        openMarketCollectionView.dataSource = self
        openMarketCollectionView.prefetchDataSource = self
        openMarketCollectionView.refreshControl = refreshControl
        
    }
    
    private func setUpActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
    }
    
    private func setUpNavigationItems() {
        self.navigationItem.titleView = segmentedController
        self.navigationItem.rightBarButtonItem = UIRightBarButtonItem
    }
    
    private func configureCollectionViewConstraint() {
        self.view.backgroundColor = .white
        
        let margins = view.safeAreaLayoutGuide
        openMarketCollectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        openMarketCollectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        openMarketCollectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        openMarketCollectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    // MARK: - Initial Data fetching
    
    private func getOpenMarketItemList() {
        openMarketListDataStorage.insertOpenMarketItemList(page: nextPageToLoad) { itemList, startItemCount, totalItemCount in
            
            var indexPaths = [IndexPath]()
            
            DispatchQueue.main.async {
                for index in startItemCount..<totalItemCount {
                    let indexPath = IndexPath(item: index, section: 0)
                    indexPaths.append(indexPath)
                }
                self.openMarketCollectionView.insertItems(at: indexPaths)
                self.activityIndicator.stopAnimating()
                self.nextPageToLoad += 1
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - ViewController action

extension OpenMarketViewController {
    
    // MARK: - Tap Segmented Control
    
    @objc private func didTapSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            layoutType = .list
            sender.tintColor = .gray
            self.openMarketCollectionView.reloadData()
        } else {
            layoutType = .grid
            sender.tintColor = .gray
            self.openMarketCollectionView.reloadData()
        }
    }
    
    // MARK: - Tap Rightbar Button
    
    @objc private func didTapAddButton(_ sender: UIBarButtonItem) {
        let openMarketItemViewController = OpenMarketItemViewController(mode: .register)
        navigationController?.pushViewController(openMarketItemViewController, animated: true)
    }
    
    func notifiedToRefreshData() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshItemList), name: .needToRefreshItemList, object: nil)
    }
    
    
    @objc private func refreshItemList() {
        let firstPage = 1
        nextPageToLoad = firstPage
        openMarketListDataStorage.removeAllOpenMarketItemList()
        CacheManager.shared.cache.removeAllObjects()
        getOpenMarketItemList()
        self.openMarketCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension OpenMarketViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if self.openMarketListDataStorage.accessOpenMarketItemList().count - 1 == indexPath.item {
                self.getOpenMarketItemList()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension OpenMarketViewController: UICollectionViewDataSource {
    
    // MARK: - Cell Data
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return openMarketListDataStorage.accessOpenMarketItemList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutType {
        case .list:
            guard let cell: OpenMarketListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketListCollectionViewCell.identifier, for: indexPath) as? OpenMarketListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(itemInformation: openMarketListDataStorage.accessOpenMarketItemList(), index: indexPath.item)
            return cell
            
        case .grid:
            guard let cell: OpenMarketGridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketGridCollectionViewCell.identifier, for: indexPath) as? OpenMarketGridCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(itemInformation: openMarketListDataStorage.accessOpenMarketItemList(), index: indexPath.item)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Cell Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              windowScene.activationState == .foregroundActive else {
            return CGSize(width: 0, height: 0)
        }
        
        switch layoutType {
        case .list:
            
            if windowScene.interfaceOrientation.isLandscape {
                let cellWidth = collectionView.frame.width
                let cellHeight = collectionView.frame.height / 3
                return CGSize(width: cellWidth, height: cellHeight)

            } else {
                let cellWidth = collectionView.frame.width
                let cellHeight = collectionView.frame.height / 9
                return CGSize(width: cellWidth, height: cellHeight)
            }

        case .grid:
            if windowScene.interfaceOrientation.isLandscape {
                let cellWidth = collectionView.frame.width / 3
                let cellHeight = collectionView.frame.height
                return CGSize(width: cellWidth, height: cellHeight)
            } else {
                let cellWidth = collectionView.frame.width / 2
                let cellHeight = collectionView.frame.height / 2
                return CGSize(width: cellWidth, height: cellHeight)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension OpenMarketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedItemViewController = OpenMarketDetailedItemViewController()
        detailedItemViewController.itemID = openMarketListDataStorage.accessItem(at: indexPath.item).id
        navigationController?.pushViewController(detailedItemViewController, animated: false)
        
    }
}
