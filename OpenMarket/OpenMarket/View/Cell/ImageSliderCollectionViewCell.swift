//
//  ImageSliderCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/08/25.
//

import UIKit

class ImageSliderCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageSliderCollectionViewCell"
    
    private var detailedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUIConstraint()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpUIConstraint() {
        self.contentView.addSubview(detailedImageView)
        
        NSLayoutConstraint.activate([
            detailedImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            detailedImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            detailedImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            detailedImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func setUpImage(_ images: [UIImage], index: Int) {
        detailedImageView.image = images[index]
    }
}
