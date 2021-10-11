//
//  ImagePickerCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/15.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ImagePickerCollectionViewCell"
    var indexPath: IndexPath?
    
    // MARK: - Delegate
    
    weak var removeCellDelegate: RemoveDelegate?
    
    // MARK: - Views
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var removeImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.imageView?.tintColor = .black
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickToRemoveImage), for: .touchDown)
        return button
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setUpUIConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    @objc private func clickToRemoveImage() {
        guard let validIndexPath = indexPath else { return }
        removeCellDelegate?.removeCell(validIndexPath)
    }
}
extension ImagePickerCollectionViewCell {
    
    // MARK: - configure UI
    
    func configureImage(_ images: [UIImage], indexPath: IndexPath) {
        itemImageView.image = images[indexPath.item]
    }
    
    func isRemoveImageButtonHidden(_ bool: Bool) {
        removeImageButton.isHidden = bool
    }
    
    private func addSubviews() {
        containerView.addSubview(itemImageView)
        containerView.addSubview(removeImageButton)
        self.contentView.addSubview(containerView)
    }
    
    // MARK: - UI Constraint
    
    private func setUpUIConstraint() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            itemImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            itemImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
            removeImageButton.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: -5),
            removeImageButton.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 5),
            removeImageButton.heightAnchor.constraint(equalTo: removeImageButton.widthAnchor)
        ])
    }
}
