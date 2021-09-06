//
//  OpenMarketDetailedItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/08/25.
//

import UIKit

class OpenMarketDetailedItemViewController: UIViewController {
    
    let networkManager: NetworkManageable = NetworkManager()
    var itemID: Int = 0
    var sliderImages = [UIImage]()
    private var bottomConstraint: NSLayoutConstraint?
    
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
    
    private let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private let itemStockLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let itemRegistrationDateLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
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
        getOpenMarketItem()
        imageSliderCollectionView.dataSource = self
        imageSliderCollectionView.delegate = self
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
    
    private func getOpenMarketItem() {
        networkManager.getSingleItem(itemURL: OpenMarketAPI.urlForSingleItem, id: itemID) { [weak self] result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self?.imageSliderCollectionView.reloadData()
                    self?.applyUI(item)
                }
            case .failure(let error):
                return NSLog(error.description)
            }
        }
    }
    
    private func applyUI(_ item: OpenMarketItemToGet) {
        self.itemTitleLabel.text = item.title
        self.itemStockLabel.text = "남은 수량 : \(item.stock)"
        self.itemPriceLabel.text = "\(item.currency)\(item.price)"
        self.itemDiscountedPriceLabel.text = applyDiscountedPrice(item)
        self.itemDetailedDescriptionTextView.text = item.descriptions
        self.itemRegistrationDateLabel.text = Date(timeIntervalSince1970: item.registrationDate).formattedString
        self.applyImages(item) { [weak self] images in
            self?.sliderImages = images
        }
        self.setUpImageSliderPageControl()
    }
    
    private func applyDiscountedPrice(_ item: OpenMarketItemToGet) -> String? {
        if let discountedPrice = item.discountedPrice {
            itemPriceLabel.textColor = .red
            itemPriceLabel.attributedText = itemPriceLabel.text?.strikeThrough()
            return "\(item.currency)\(discountedPrice)"
        } else {
            return nil
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
        let nextPage = Int(targetContentOffset.pointee.x / self.view.frame.width)
        self.imageSlider.currentPage = nextPage
        
    }
    
}
