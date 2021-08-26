//
//  OpenMarketDetailedItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/08/25.
//

import UIKit

class OpenMarketDetailedItemViewController: UIViewController {

    private var imageSliderView: UICollectionView = {
        let height = UIScreen.main.bounds.height * 0.4
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var imageSlider: UIPageControl = {
        let viewSize = CGSize(width: 50, height: UIScreen.main.bounds.width * 0.8)
        let viewFrame = CGRect(origin: .zero, size: viewSize)
        let pageControl = UIPageControl(frame: viewFrame)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
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
        cell.setUpImage(sliderImages.first)
        return cell
    }
    
    
}
