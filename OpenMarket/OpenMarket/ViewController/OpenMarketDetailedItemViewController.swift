//
//  OpenMarketDetailedItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/08/25.
//

import UIKit

class OpenMarketDetailedItemViewController: UIViewController {
    
    var sliderImages = [UIImage]()
    private var bottomConstraint: NSLayoutConstraint?

    private var imageSliderCollectionView: UICollectionView = {
        let height = CGFloat(200)
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var imageSlider: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = sliderImages.count
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
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemStockLabel, itemPriceLabel, itemDiscountedPriceLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
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
        imageSliderCollectionView.dataSource = self
        imageSliderCollectionView.delegate = self
        setUpUIConstraint()
        self.view.backgroundColor = .white
    }
    
    private func setUpUIConstraint() {
        [imageSliderCollectionView, imageSlider, itemTitleLabel, labelStackView, itemDetailedDescriptionTextView].forEach { view in
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            imageSliderCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageSliderCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageSliderCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            imageSlider.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            imageSlider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            imageSlider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            imageSlider.topAnchor.constraint(equalTo: imageSliderCollectionView.bottomAnchor),
            
            itemTitleLabel.topAnchor.constraint(equalTo: imageSlider.bottomAnchor, constant: 5),
            itemTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            
            labelStackView.topAnchor.constraint(equalTo: itemTitleLabel.topAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            itemDetailedDescriptionTextView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 5),
            itemDetailedDescriptionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            itemDetailedDescriptionTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
            
        ])
        bottomConstraint = itemDetailedDescriptionTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5)
        bottomConstraint?.isActive = true
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

// MARK: - UIcollectionViewDelegate

extension OpenMarketDetailedItemViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let nextPage = Int(targetContentOffset.pointee.x / self.view.frame.width)
        self.imageSlider.currentPage = nextPage
        
    }
    
}
