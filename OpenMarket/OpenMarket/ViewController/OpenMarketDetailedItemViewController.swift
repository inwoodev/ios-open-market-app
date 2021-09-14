//
//  OpenMarketDetailedItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/08/25.
//

import UIKit

class OpenMarketDetailedItemViewController: UIViewController {
    
    // MARK: - Properties
    
    private let networkManager: NetworkManageable = NetworkManager()
    private var bottomConstraint: NSLayoutConstraint?
    var sliderImages = [UIImage]()
    var itemID: Int = 0
    
    // MARK: - Views
    
    private let imageSliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: ImagePickerCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    private let imageSlider: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = .systemGray
        pageControl.pageIndicatorTintColor = .systemGray3
        
        return pageControl
    }()
    
    private let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private let itemStockLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemStockTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let itemPriceCurrencyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        
        return label
    }()
    
    private let itemRegistrationDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private let itemDetailedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = false
        label.textAlignment = .natural
        
        return label
    }()
    
    // MARK: - StackViews
    
    private let stockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let moneyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let leftlabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.alignment = .leading
        
        return stackView
    }()
    
    // MARK: - Buttons
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapActionButton))
        return barButtonItem
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setUpNavigationItems()
        getOpenMarketItem()
        assignDelegates()
        addSubviews()
        setUpUIConstraint()
        self.view.backgroundColor = .white
    }
    
    private func addSubviews() {
        stockStackView.addArrangedSubview(itemStockLabel)
        stockStackView.addArrangedSubview(itemStockTextLabel)
        
        priceStackView.addArrangedSubview(itemPriceLabel)
        priceStackView.addArrangedSubview(itemDiscountedPriceLabel)
        
        moneyStackView.addArrangedSubview(itemPriceCurrencyLabel)
        moneyStackView.addArrangedSubview(priceStackView)
        
        leftlabelsStackView.addArrangedSubview(itemTitleLabel)
        leftlabelsStackView.addArrangedSubview(itemRegistrationDateLabel)
        
        
        [imageSliderCollectionView, imageSlider, stockStackView, leftlabelsStackView,  moneyStackView, itemDetailedDescriptionLabel].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    private func hideView(_ bool: Bool) {
        moneyStackView.isHidden = bool
        stockStackView.isHidden = bool
        
    }
    
    private func setUpUIConstraint() {
        NSLayoutConstraint.activate([
            imageSliderCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            imageSliderCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            imageSliderCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            imageSliderCollectionView.bottomAnchor.constraint(equalTo: imageSlider.topAnchor, constant: -5),
            
            imageSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageSlider.bottomAnchor.constraint(equalTo: leftlabelsStackView.topAnchor, constant: -5),
            
            leftlabelsStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            leftlabelsStackView.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2),
            
            stockStackView.widthAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.width / 2),
            stockStackView.topAnchor.constraint(equalTo: leftlabelsStackView.topAnchor),
            stockStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            
            moneyStackView.topAnchor.constraint(equalTo: stockStackView.bottomAnchor, constant: 5),
            moneyStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            moneyStackView.widthAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.width / 2),
            moneyStackView.bottomAnchor.constraint(equalTo: leftlabelsStackView.bottomAnchor),
            itemPriceCurrencyLabel.heightAnchor.constraint(equalTo: moneyStackView.heightAnchor),
            
            itemDetailedDescriptionLabel.topAnchor.constraint(equalTo: leftlabelsStackView.bottomAnchor, constant: 5),
            itemDetailedDescriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            itemDetailedDescriptionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
        ])
        bottomConstraint = itemDetailedDescriptionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        bottomConstraint?.isActive = true
    }
    
    private func setUpNavigationItems() {
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func getOpenMarketItem() {
        networkManager.getSingleItem(itemURL: OpenMarketAPI.urlForSingleItemToGetPatchOrDelete, id: itemID) { [weak self] result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self?.imageSliderCollectionView.reloadData()
                    self?.navigationItem.title = item.title
                    self?.applyUI(item)
                }
            case .failure(let error):
                return NSLog(error.description)
            }
        }
    }
    
    private func applyUI(_ item: OpenMarketItemToGet) {
        self.itemTitleLabel.text = item.title
        applyStockTextField(item)
        applyPriceTextField(item)
        self.itemRegistrationDateLabel.text = Date(timeIntervalSince1970: item.registrationDate).formattedString
        self.itemDetailedDescriptionLabel.text = item.descriptions
        self.applyImages(item) { [weak self] images in
            self?.sliderImages = images
        }
        self.setUpImageSliderPageControl()
    }
    
    private func assignDelegates() {
        imageSliderCollectionView.dataSource = self
        imageSliderCollectionView.delegate = self
    }
    
    private func applyStockTextField(_ item: OpenMarketItemToGet) {
        if item.stock > 999 {
            self.itemStockTextLabel.text = "999"
        } else {
            self.itemStockTextLabel.text = String(item.stock)
        }
    }
    
    private func applyPriceTextField(_ item: OpenMarketItemToGet){
        if let discountedPrice = item.discountedPrice {
            itemPriceCurrencyLabel.text = item.currency
            
            itemPriceLabel.textColor = .red
            itemPriceLabel.text = String(item.price)
            itemPriceLabel.attributedText = itemPriceLabel.text?.strikeThrough()
            
            itemDiscountedPriceLabel.text = String(discountedPrice)
        } else {
            itemDiscountedPriceLabel.isHidden = true
            
            itemPriceCurrencyLabel.text = item.currency
            itemPriceLabel.text = String(item.price)
        }
    }
    
    private func applyImages(_ item: OpenMarketItemToGet, completion: @escaping ([UIImage]) -> ()) {
        var downloadedImages: [UIImage] = []
        
        let downloadedImageURLStrings = item.thumbnails
        
        downloadedImageURLStrings.forEach { string in
            guard let imageURL = URL(string: string) else { return }
            let downloadedimage = downloadImage(url: imageURL)
            downloadedImages.append(downloadedimage)
        }
        completion(downloadedImages)
    }
    
    private func downloadImage(url: URL) -> UIImage {
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return UIImage() }
        return image
        
    }
    
    private func setUpImageSliderPageControl() {
        imageSlider.numberOfPages = sliderImages.count
    }
    
    private func alertEditOrDeleteItem() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let editAction = UIAlertAction(title: "수정", style: .default) { alertAction in
            self.navigationItem.rightBarButtonItem = self.editButtonItem
            self.setEditing(true, animated: true)
        }
        let deleteMode = UIAlertAction(title: "삭제", style: .default) { alertAction in
            
        }
        alertController.addAction(editAction)
        alertController.addAction(deleteMode)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func alertProceedToEditItem() {
        let alertController = UIAlertController(title: "상품 수정", message: "정말로 상품을 수정하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alertAction in
            print("alert")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in

        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didTapActionButton(_ sender: UIBarButtonItem) {
        alertEditOrDeleteItem()
    }
}

// MARK: - UICollectionViewDataSource

extension OpenMarketDetailedItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.identifier, for: indexPath) as? ImagePickerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureImage(sliderImages, indexPath: indexPath)
        cell.indexPath = indexPath
        cell.isRemoveImageButtonHidden(true)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension OpenMarketDetailedItemViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let nextPage = Int(targetContentOffset.pointee.x / imageSliderCollectionView.frame.width)
        self.imageSlider.currentPage = nextPage
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OpenMarketDetailedItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        
        return CGSize(width: width, height: height)
    }
}
