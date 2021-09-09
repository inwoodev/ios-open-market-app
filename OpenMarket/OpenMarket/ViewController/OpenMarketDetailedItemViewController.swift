//
//  OpenMarketDetailedItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/08/25.
//

import UIKit

class OpenMarketDetailedItemViewController: UIViewController {
    
    private let networkManager: NetworkManageable = NetworkManager()
    private var itemInformation: [String: Any?] = [:]
    private var bottomConstraint: NSLayoutConstraint?
    var sliderImages = [UIImage]()
    var itemID: Int = 0
    
    private let imageSliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier)
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
    
    private let itemTitleTextView = DetailedItemTitleTextView()
    
    private let itemStockLabel: UILabel = {
        let label = UILabel()
        label.text = "재고: "
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemStockTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontForContentSizeCategory = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.textColor = .systemGray2
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    private let itemPriceCurrencyTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontForContentSizeCategory = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = OpenMarketItemToPostOrPatch.currency.placeholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isUserInteractionEnabled = false
        textField.contentVerticalAlignment = .top
        
        return textField
    }()
    
    private let itemPriceTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontForContentSizeCategory = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = OpenMarketItemToPostOrPatch.price.placeholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isUserInteractionEnabled = false
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let itemDiscountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontForContentSizeCategory = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = OpenMarketItemToPostOrPatch.discountedPrice.placeholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isUserInteractionEnabled = false
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let itemRegistrationDateLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private let itemDetailedDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.adjustsFontForContentSizeCategory = false
        textView.textAlignment = .natural
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.isEditable = false
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private let rightlabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
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
    
    private let middleLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        
        return stackView
    }()
    
    private let itemDetailedInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
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
        rightlabelsStackView.addArrangedSubview(itemStockLabel)
        rightlabelsStackView.addArrangedSubview(itemPriceLabel)
        rightlabelsStackView.addArrangedSubview(itemDiscountedPriceLabel)
        
        leftlabelsStackView.addArrangedSubview(itemTitleLabel)
        leftlabelsStackView.addArrangedSubview(itemRegistrationDateLabel)
        
        middleLabelsStackView.addArrangedSubview(leftlabelsStackView)
        middleLabelsStackView.addArrangedSubview(rightlabelsStackView)
        
        
        [imageSliderCollectionView, imageSlider, middleLabelsStackView].forEach { view in
            self.itemDetailedInformationStackView.addArrangedSubview(view)
        }
        
        self.view.addSubview(itemDetailedInformationStackView)
        self.view.addSubview(itemDetailedDescriptionTextView)
    }
    
    private func setUpUIConstraint() {
        NSLayoutConstraint.activate([
            itemDetailedInformationStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            itemDetailedInformationStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            itemDetailedInformationStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            itemDetailedInformationStackView.bottomAnchor.constraint(equalTo: itemDetailedDescriptionTextView.topAnchor, constant: -5),
            
            itemDetailedDescriptionTextView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 3),

            itemDetailedDescriptionTextView.topAnchor.constraint(equalTo: middleLabelsStackView.bottomAnchor, constant: 5),
            itemDetailedDescriptionTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            itemDetailedDescriptionTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            
        ])
        bottomConstraint = itemDetailedDescriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        bottomConstraint?.isActive = true
    }
    
    private func setUpNavigationItems() {
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func getOpenMarketItem() {
        networkManager.getSingleItem(itemURL: OpenMarketAPI.urlForSingleItem, id: itemID) { [weak self] result in
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
        self.itemTitleTextView.text = item.title
        applyStockTextField(item)
        applyPriceTextField(item)
        self.itemRegistrationDateLabel.text = Date(timeIntervalSince1970: item.registrationDate).formattedString
        self.itemDetailedDescriptionTextView.text = item.descriptions
        self.applyImages(item) { [weak self] images in
            self?.sliderImages = images
        }
        self.setUpImageSliderPageControl()
    }
    
    private func assignDelegates() {
        imageSliderCollectionView.dataSource = self
        imageSliderCollectionView.delegate = self
        itemTitleTextView.titleViewDelegate = self
    }
    
    private func applyStockTextField(_ item: OpenMarketItemToGet) {
        if item.stock > 999 {
            self.itemStockTextField.text = "999"
        } else {
            self.itemStockTextField.text = String(item.stock)
        }
    }
    
    private func applyPriceTextField(_ item: OpenMarketItemToGet){
        if let discountedPrice = item.discountedPrice {
            itemPriceCurrencyTextField.text = item.currency
            
            itemPriceTextField.textColor = .red
            itemPriceTextField.text = String(item.price)
            itemPriceTextField.attributedText = itemPriceTextField.text?.strikeThrough()
            
            itemDiscountedPriceTextField.text = String(discountedPrice)
        } else {
            itemDiscountedPriceTextField.text = nil
            
            itemPriceCurrencyTextField.text = item.currency
            itemPriceTextField.text = String(item.price)
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
    
//    private func alertEditOrDeleteItem() {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let editAction = UIAlertAction(title: "수정", style: .default) { alertAction in
//
//        }
        
//    }
    
    @objc private func didTapActionButton(_ sender: UIBarButtonItem) {

    }
}

// MARK: - UICollectionViewDataSource

extension OpenMarketDetailedItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSliderCollectionViewCell.identifier, for: indexPath) as? ImageSliderCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setUpImage(sliderImages, index: indexPath.item)
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

extension OpenMarketDetailedItemViewController: PatchingTextConvertible {
    func convertPasswordTextToDictionary(_ key: OpenMarketItemToPostOrPatch, _ text: String?) {
        print("hi")
    }
    
    func convertOptionalTextToDictionary(_ key: OpenMarketItemToPostOrPatch, _ text: String?) {
        itemInformation.updateValue(itemTitleTextView.text, forKey: OpenMarketItemToPostOrPatch.title.key)
    }
}
