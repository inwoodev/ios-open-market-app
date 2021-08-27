//
//  OpenMarketDetailedItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/08/25.
//

import UIKit

class OpenMarketDetailedItemViewController: UIViewController {
    
    var sliderImages = [UIImage]()

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
        
        return collectionView
    }()
    
    private lazy var imageSlider: UIPageControl = {
        let viewSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let viewFrame = CGRect(origin: .zero, size: viewSize)
        let pageControl = UIPageControl(frame: viewFrame)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = sliderImages.count
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSliderCollectionView.dataSource = self
        setUpUIConstraint()
    }
    
    private func setUpUIConstraint() {
        self.view.addSubview(imageSlider)
        self.view.addSubview(imageSliderCollectionView)
        
        
        NSLayoutConstraint.activate([
            imageSliderCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageSliderCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageSliderCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageSliderCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200),
            
            imageSlider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            imageSlider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            imageSlider.bottomAnchor.constraint(equalTo: imageSliderCollectionView.bottomAnchor, constant: -20)
        ])
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
