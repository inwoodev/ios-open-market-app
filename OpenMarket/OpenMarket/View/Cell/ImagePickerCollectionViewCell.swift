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
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.imageView?.tintColor = .darkGray
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickToRemoveThumbnail), for: .touchDown)
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
            
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            thumbnailImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
            removeButton.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: -5),
            removeButton.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 5)
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
