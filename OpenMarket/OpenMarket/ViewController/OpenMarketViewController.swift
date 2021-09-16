//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    private var layoutType = OpenMarketCellLayoutType.list
    private var networkManager: NetworkManageable = NetworkManager()
    private var isPageRefreshing: Bool = false
    private var nextPageToLoad: Int = 1
    private var openMarketItems: [OpenMarketItem] = []
    
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
        fetchOpenMarketItems()
        notifiedToRefreshData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        openMarketCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Setup CollectionView
    
    private func setUpCollectionView() {
        self.view.addSubview(openMarketCollectionView)
        openMarketCollectionView.delegate = self
        openMarketCollectionView.dataSource = self
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
    
    private func fetchOpenMarketItems() {
        networkManager.getItemList(page: nextPageToLoad, loadingFinished: false) { [weak self] result in
            switch result {
            case .success(let itemList):
                self?.openMarketItems.append(contentsOf: itemList.items)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.openMarketCollectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.networkManager.isReadyToPaginate = true
                }
            case .failure(let error):
                print(error.localizedDescription)
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
        let firstPage = 0
        nextPageToLoad = firstPage
        openMarketItems = []
        openMarketCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - UICollectionViewDataSource

extension OpenMarketViewController: UICollectionViewDataSource {
    
    // MARK: - Cell Data
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return openMarketItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutType {
        case .list:
            guard let cell: OpenMarketListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketListCollectionViewCell.identifier, for: indexPath) as? OpenMarketListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(openMarketItems, indexPath: indexPath.row)
            return cell
            
        case .grid:
            guard let cell: OpenMarketGridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketGridCollectionViewCell.identifier, for: indexPath) as? OpenMarketGridCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(openMarketItems, indexPath: indexPath.row)
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
        detailedItemViewController.itemID = openMarketItems[indexPath.item].id
        navigationController?.pushViewController(detailedItemViewController, animated: false)
        
    }
}

// MARK: - UIScrollViewDelegate

extension OpenMarketViewController: UIScrollViewDelegate {
    
    // MARK: - Fetch Data After Dragging
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (position > (scrollView.contentSize.height - 100 - scrollView.frame.size.height)) {
            
            guard  networkManager.isReadyToPaginate == true else { return }
            
            nextPageToLoad += 1
            fetchAdditionalData()
        }
    }
    
    private func fetchAdditionalData() {
        networkManager.getItemList(page: nextPageToLoad, loadingFinished: true) { [weak self] result in
            switch result {
            case .success(let additionalItemList):
                
                guard let self = self else { return }
                
                let range = self.openMarketItems.count..<additionalItemList.items.count + self.openMarketItems.count
                self.openMarketItems.append(contentsOf: additionalItemList.items)
                DispatchQueue.main.async {
                    self.openMarketCollectionView.performBatchUpdates({
                        for item in range {
                            let indexPath = IndexPath(row: item, section: 0)
                            self.openMarketCollectionView.insertItems(at: [indexPath])
                        }
                    }, completion: nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
