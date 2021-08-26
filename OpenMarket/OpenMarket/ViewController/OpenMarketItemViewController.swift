//
//  OpenMarketItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/06/14.
//

import UIKit

class OpenMarketItemViewController: UIViewController {
    
    // MARK: - Properties
    
    private let currencyList = ["KRW", "USD", "BTC", "JPY", "EUR", "GBP", "CNY"]
    private let imagePicker = UIImagePickerController()
    private var itemThumbnails: [UIImage] = []
    private var itemInformation: [String: Any?] = [:]
    private var textViewDefaultMessage: String = "상품 정보를 입력 해 주세요."
    private var networkManager: NetworkManageable = NetworkManager()
    
    // MARK: - Views
    
    private var titleTextField = TitleTextField()
    private var priceTextField = PriceTextField()
    private var discountedPriceTextField = DiscountedPriceTextField()
    private var stockTextField = StockTextField()
    private var passwordTextField = PasswordTextField()
    private var currencyTextField = CurrencyTextField()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.text = "개"
        label.textColor = .lightGray
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var detailedInformationTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = textViewDefaultMessage
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        pickerView.backgroundColor = UIColor.white
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    private lazy var currencyPickerViewToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: currencyPickerView.frame.width, height: currencyPickerView.frame.height / 5))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.donePicker))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.donePicker))
        
        toolbar.setItems([doneButton, cancelButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    private lazy var uploadImageButton: UIButton = {
        let button = UIButton()
        let uploadImage = UIImage(systemName: "camera")
        button.setImage(uploadImage, for: .normal)
        button.addTarget(self, action: #selector(didTapUploadPhoto(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var thumbnailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let viewWidth = self.view.frame.width / 2
        let viewHeight = self.view.frame.height / 5
        layout.itemSize = CGSize(width: viewWidth, height: viewHeight)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: ImagePickerCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var uploadImageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [uploadImageButton, thumbnailCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private lazy var pricesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceTextField, discountedPriceTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var UIRightBarButtonItem: UIBarButtonItem = {
        let sendItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        return sendItem
    }()
    
    // MARK: - ViewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpNavigationItems()
        addSubviews()
        setUpUIConstraints()
        titleTextField.textFieldDelegate = self
        priceTextField.textFieldDelegate = self
        discountedPriceTextField.textFieldDelegate = self
        stockTextField.textFieldDelegate = self
        passwordTextField.textFieldDelegate = self
        applyCurrencyTextField()
    }
    
    private func applyCurrencyTextField() {
        currencyTextField.textFieldDelegate = self
        currencyTextField.inputView = currencyPickerView
        currencyTextField.inputAccessoryView = currencyPickerViewToolbar
    }
}
extension OpenMarketItemViewController {
    
    // MARK: - Method: Send Information to Server
    
    private func examineRequiredInformation() {
        let alertController = UIAlertController(title: "입력 오류", message: "상품 사진 포함 필수항목을 모두 입력 해 주세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        [titleTextField, passwordTextField, priceTextField, stockTextField, currencyTextField].forEach { [weak self] textField in
            guard let text = textField.text else { return }
            if text.isEmpty && self?.presentedViewController == nil {
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        guard let detailedText = detailedInformationTextView.text else { return }
        if (detailedText.isEmpty || detailedText == textViewDefaultMessage) && self.presentedViewController == nil {
            self.present(alertController, animated: true, completion: nil)
        } else if itemThumbnails.count < 1 && self.presentedViewController == nil {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    private func alertConfirmationToUser() {
        let alertController = UIAlertController(title: "작성 완료", message: "틀린 내용이 없는지 꼼꼼히 확인 해 주세요. 정말로 상품을 마켓에 올리시겠습니까?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            
            guard let self = self else { return }
            
            self.networkManager.postSingleItem(url: OpenMarketAPI.urlForSingleItem.description, texts: self.itemInformation, imageList: self.itemThumbnails, completionHandler: { task in
            })
            
            DispatchQueue.main.async {
                self.dismissCurrentViewController()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        examineRequiredInformation()
        alertConfirmationToUser()
    }
    
    private func dismissCurrentViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Method: hide keyboard when tapped around
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - setUp NavigationItems
    
    private func setUpNavigationItems() {
        self.navigationItem.title = "상품등록"
        self.navigationItem.rightBarButtonItem = UIRightBarButtonItem
    }
    
    
    // MARK: - setUp UI Constraints
    
    private func addSubviews() {
        [titleTextField, passwordTextField, currencyTextField, pricesStackView, stockTextField, stockLabel, detailedInformationTextView, uploadImageButton, thumbnailCollectionView].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setUpUIConstraints() {
        
        NSLayoutConstraint.activate([
            
            uploadImageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            uploadImageButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            uploadImageButton.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            thumbnailCollectionView.heightAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.height / 10),
            thumbnailCollectionView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10),
            thumbnailCollectionView.topAnchor.constraint(equalTo: uploadImageButton.bottomAnchor, constant: 5),
            thumbnailCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            thumbnailCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            titleTextField.topAnchor.constraint(equalTo: thumbnailCollectionView.bottomAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            passwordTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            currencyTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            currencyTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            pricesStackView.topAnchor.constraint(equalTo: currencyTextField.topAnchor),
            pricesStackView.leadingAnchor.constraint(equalTo: currencyTextField.trailingAnchor, constant: 20),
            pricesStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            pricesStackView.bottomAnchor.constraint(equalTo: currencyTextField.bottomAnchor),
            
            stockTextField.topAnchor.constraint(equalTo: currencyTextField.bottomAnchor, constant: 20),
            stockTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            stockLabel.topAnchor.constraint(equalTo: stockTextField.topAnchor),
            stockLabel.leadingAnchor.constraint(equalTo: stockTextField.trailingAnchor, constant: 5),
            stockLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -200),
            stockLabel.bottomAnchor.constraint(equalTo: stockTextField.bottomAnchor),
            
            detailedInformationTextView.topAnchor.constraint(equalTo: stockTextField.bottomAnchor, constant: 20),
            detailedInformationTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            detailedInformationTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            detailedInformationTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
        ])
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension OpenMarketItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = currencyList[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencyList.count
    }
    
    @objc private func donePicker() {
        currencyTextField.resignFirstResponder()
        let row = currencyPickerView.selectedRow(inComponent: 0)
        pickerView(currencyPickerView, didSelectRow: row, inComponent: 0)
    }
}

// MARK: - UITextViewDelegate

extension OpenMarketItemViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewDefaultMessage {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewDefaultMessage
            textView.textColor = .lightGray
        }
        
        guard let text = textView.text else { return }
        itemInformation.updateValue(text, forKey: OpenMarketItemToPost.descriptions.key)
    }
}

// MARK: - UITextFieldDelegate

extension OpenMarketItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - TextFieldConvertible

extension OpenMarketItemViewController: TextFieldConvertible {
    
    func alertInvalidTextField(_ alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func convertPasswordTextFieldToDictionary(_ itemToPost: OpenMarketItemToPost, _ text: String?) {
        itemInformation.updateValue(text, forKey: itemToPost.key)
        let alertController = UIAlertController(title: "비밀번호 설정", message: "비밀번호를 영문, 숫자를 사용해서 입력 해 주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        guard let text = text,
              Int(text) == nil,
              !text.isEmpty else {
            alertInvalidTextField(alertController)
            return
        }
        
        itemInformation.updateValue(text, forKey: itemToPost.key)
    }
    
    func convertOptionalTextFieldToDictionary(_ itemToPost: OpenMarketItemToPost, _ text: String?) {
        
        guard let text = text,
              let number = Int(text) else { return }
        itemInformation.updateValue(number, forKey: itemToPost.key)
    }
    
    func convertTextFieldToDictionary(_ itemToPost: OpenMarketItemToPost, _ text: String?) {
        
        guard let text = text else { return }
        if let number = Int(text) {
            itemInformation.updateValue(number, forKey: itemToPost.key)
            
        } else {
            itemInformation.updateValue(text, forKey: itemToPost.key)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension OpenMarketItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage: UIImage = info[.originalImage] as? UIImage else { return }
        
        ImageCompressor.compress(image: selectedImage, maxByte: 300000) { image in
            self.itemThumbnails.append(image ?? selectedImage)
            
            DispatchQueue.main.async {
                self.thumbnailCollectionView.reloadData()
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func didTapUploadPhoto(_ sender: UIButton) {
        
        if itemThumbnails.count < 5 {
            let alertController = UIAlertController(title: "상품등록", message: nil, preferredStyle: .actionSheet)
            let photoLibrary = UIAlertAction(title: "사진 앨범", style: .default) { action in
                self.openLibrary()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(photoLibrary)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "사진 제한", message: "사진은 총 5장으로 제한 됩니다.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    private func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension OpenMarketItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemThumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.identifier, for: indexPath) as? ImagePickerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.indexPath = indexPath
        cell.configureThumbnail(itemThumbnails)
        cell.imagePickerDelegate = cell
        cell.removeCellDelegate = self
        return cell
    }
}
extension OpenMarketItemViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Cell Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 5
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - RemoveDelegate

extension OpenMarketItemViewController: RemoveDelegate {
    func removeCell(_ indexPath : IndexPath) {
        self.thumbnailCollectionView.performBatchUpdates {
            self.thumbnailCollectionView.deleteItems(at: [indexPath])
            self.itemThumbnails.remove(at: indexPath.row)
        } completion: { (_) in
            self.thumbnailCollectionView.reloadData()
        }
    }
}
