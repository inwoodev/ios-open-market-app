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
    
    private lazy var imageSliderCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let height = self.view.frame.height * 0.6
        let width = self.view.frame.width
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private var imageSlider: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = .systemGray
        pageControl.pageIndicatorTintColor = .systemGray3
        return pageControl
    }()
    
    private var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var itemStockLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var itemRegistrationDateLabel: UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
            
    }
    
    private lazy var rightlabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemStockLabel, itemPriceLabel, itemDiscountedPriceLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var leftlabelsStackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()
    
    private var itemDetailedDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .natural
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOpenMarketItem()
        imageSliderCollectionView.dataSource = self
        imageSliderCollectionView.delegate = self
        setUpUIConstraint()
        self.view.backgroundColor = .white
    }
    
    private func setUpUIConstraint() {
        [imageSliderCollectionView, imageSlider, itemTitleLabel, rightlabelsStackView, itemDetailedDescriptionTextView].forEach { view in
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            imageSliderCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageSliderCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageSliderCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            imageSlider.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            imageSlider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            imageSlider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            imageSlider.bottomAnchor.constraint(equalTo: imageSliderCollectionView.bottomAnchor),
            
            itemTitleLabel.topAnchor.constraint(equalTo: imageSlider.bottomAnchor, constant: 5),
            itemTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            
            rightlabelsStackView.topAnchor.constraint(equalTo: itemTitleLabel.topAnchor),
            rightlabelsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            rightlabelsStackView.leadingAnchor.constraint(equalTo: itemTitleLabel.trailingAnchor, constant: 40),
            
            itemDetailedDescriptionTextView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2),
            itemDetailedDescriptionTextView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10),
            itemDetailedDescriptionTextView.topAnchor.constraint(equalTo: rightlabelsStackView.bottomAnchor, constant: 5),
            itemDetailedDescriptionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            itemDetailedDescriptionTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
            
        ])
        bottomConstraint = itemDetailedDescriptionTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5)
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
