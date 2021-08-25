//
//  ImagePickerCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/15.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ImagePickerCollectionViewCell"
    private var thumbnailList: [UIImage] = []
    var indexPath: IndexPath?
    
    // MARK: - Delegate
    
    weak var removeCellDelegate: RemoveDelegate?
    weak var imagePickerDelegate: ImagePickerDelegate?
    
    // MARK: - Properties
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.imageView?.tintColor = .lightGray
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickToRemoveThumbnail), for: .touchDown)
        return button
    }()
    private lazy var containerView: UIView = {
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
    
    @objc private func clickToRemoveThumbnail() {
        imagePickerDelegate?.clickButton()
    }
}
extension ImagePickerCollectionViewCell {
    
    // MARK: - configure UI
    
    func configureThumbnail(_ thumbnails: [UIImage]) {
        guard let validIndexPath = indexPath else { return }
        thumbnailImageView.image = thumbnails[validIndexPath.row]
    }
    
    private func addSubviews() {
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(removeButton)
        self.contentView.addSubview(containerView)
    }
    
    // MARK: - UI Constraint
    
    private func setUpUIConstraint() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            thumbnailImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: containerView.frame.height),
            thumbnailImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: containerView.frame.width),
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            thumbnailImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
            removeButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            removeButton.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20),
            removeButton.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 20),
            removeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
}

// MARK: - ImagePickerDelegate

extension ImagePickerCollectionViewCell: ImagePickerDelegate {
    func clickButton() {
        guard let validIndexPath = indexPath else { return }
        removeCellDelegate?.removeCell(validIndexPath)
    }
}
