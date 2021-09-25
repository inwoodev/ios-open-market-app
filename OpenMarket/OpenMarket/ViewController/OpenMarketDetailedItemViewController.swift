//
//  OpenMarketDetailedItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/08/25.
//

import UIKit

class OpenMarketDetailedItemViewController: UIViewController {
    
    enum UserChoice {
        case edit, delete
    }
    
    // MARK: - Properties
    
    private let networkManager: NetworkManageable = NetworkManager()
    private var bottomConstraint: NSLayoutConstraint?
    private var openMarketItem: OpenMarketItemToGet?
    var sliderImages = [UIImage]()
    var itemID = Int()
    
    
    // MARK: - Views
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (_) in
            self.imageSliderCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
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
            contentView.addSubview(view)
        }
        
        contentScrollView.addSubview(contentView)
        self.view.addSubview(contentScrollView)
    }
    
    private func setUpUIConstraint() {
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentViewHeight,
            
            imageSliderCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageSliderCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageSliderCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            imageSliderCollectionView.bottomAnchor.constraint(equalTo: imageSlider.topAnchor, constant: -5),
            imageSliderCollectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2),
            imageSlider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageSlider.bottomAnchor.constraint(equalTo: leftlabelsStackView.topAnchor, constant: -5),
            
            leftlabelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            leftlabelsStackView.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2),
            
            stockStackView.widthAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.width / 2),
            stockStackView.topAnchor.constraint(equalTo: leftlabelsStackView.topAnchor),
            stockStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            
            moneyStackView.topAnchor.constraint(equalTo: stockStackView.bottomAnchor, constant: 5),
            moneyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            moneyStackView.widthAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.width / 2),
            moneyStackView.bottomAnchor.constraint(equalTo: leftlabelsStackView.bottomAnchor),
            itemPriceCurrencyLabel.heightAnchor.constraint(equalTo: moneyStackView.heightAnchor),
            
            itemDetailedDescriptionLabel.topAnchor.constraint(equalTo: leftlabelsStackView.bottomAnchor, constant: 5),
            itemDetailedDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            itemDetailedDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            itemDetailedDescriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
            
        ])
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
                    self?.openMarketItem = item
                }
            case .failure(let error):
                return NSLog(error.description)
            }
        }
    }
    
    private func applyUI(_ item: OpenMarketItemToGet) {
        self.itemTitleLabel.text = item.title
        self.itemStockLabel.text = "재고: "
        applyStockTextLabel(item)
        applyPriceTextLabel(item)
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
    
    private func applyStockTextLabel(_ item: OpenMarketItemToGet) {
        if item.stock > 999 {
            self.itemStockTextLabel.text = "999"
        } else {
            self.itemStockTextLabel.text = String(item.stock)
        }
    }
    
    private func applyPriceTextLabel(_ item: OpenMarketItemToGet){
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
            self.alertInsertPassword(userChoice: .edit)
            
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { alertAction in
            self.alertInsertPassword(userChoice: .delete)
        }
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc private func didTapActionButton(_ sender: UIBarButtonItem) {
        alertEditOrDeleteItem()
    }
}

// MARK: - Edit Item

extension OpenMarketDetailedItemViewController {
    
    private func alertInsertPassword(userChoice: UserChoice) {
        let alertController = UIAlertController(title: "패스워드 입력", message: "패스워드 입력이 필요합니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { ok in
            
            guard let passwordTextField = alertController.textFields?.first,
                  let insertedPassword = passwordTextField.text else { return }
            
            self.usePasswordToEditOrDeleteItem(userChoice: userChoice, insertedPassword)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { cancel in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "패스워드를 입력 해 주세요"
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func usePasswordToEditOrDeleteItem(userChoice: UserChoice, _ password: String) {
        
        switch userChoice {
        case .edit:
            networkManager.patchSingleItem(url: "\(OpenMarketAPI.urlForSingleItemToGetPatchOrDelete)\(itemID)", texts: [OpenMarketItemToPostOrPatch.password.key: password], images: nil) { [weak self] response in
                DispatchQueue.main.async {
                    if (200...299).contains(response.statusCode) {
                        self?.proceedToEditItem(password)
                    } else if response.statusCode == 404 {
                        self?.alertInvalidPassword(.edit)
                    }
                }
            }
        case .delete:
            networkManager.deleteSingleItem(url: "\(OpenMarketAPI.urlForSingleItemToGetPatchOrDelete)", id: itemID, password: password) { [weak self] response in
                DispatchQueue.main.async {
                    if (200...299).contains(response.statusCode) {
                        self?.alertDeleteConfirmation()
                    } else {
                        self?.alertInvalidPassword(.delete)
                    }
                }
            }
        }
    }
    
    private func proceedToEditItem(_ password: String) {
        let editItemViewController = OpenMarketItemViewController(mode: .edit)
        editItemViewController.setItemIdentityToPatch(idNumber: itemID)
        editItemViewController.receiveInformation(of: openMarketItem, images: sliderImages, password: password)
        navigationController?.pushViewController(editItemViewController, animated: true)
    }
    
    private func alertDeleteConfirmation() {
        let alertController = UIAlertController(title: "주의", message: "삭제 후 되돌릴 수 없습니다. 정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { ok in
            self.notifyThatAnItemIsDeleted()
            alertController.dismiss(animated: true) {
                self.alertSuccessfulDeletion()
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { cancel in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func alertSuccessfulDeletion() {
        let alertController = UIAlertController(title: "상품 삭제 완료", message: "상품이 정상적으로 삭제되었습니다.", preferredStyle: .alert)
        
        self.present(alertController, animated: true) {
            let delay = DispatchTime.now() + 1
            
            DispatchQueue.main.asyncAfter(deadline: delay) {
                alertController.dismiss(animated: true) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    private func notifyThatAnItemIsDeleted() {
        NotificationCenter.default.post(name: .needToRefreshItemList, object: nil)
    }
    
    private func alertInvalidPassword(_ userChoice: UserChoice) {
        let alertController = UIAlertController(title: "패스워드 오류", message: "잘못된 패스워드입니다.", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "재시도", style: .default) { [weak self] retry in
            self?.alertInsertPassword(userChoice: userChoice)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { cancel in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
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
