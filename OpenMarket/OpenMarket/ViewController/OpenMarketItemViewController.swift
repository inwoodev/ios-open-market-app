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
    private let textViewDefaultMessage: String = "상품 정보를 입력 해 주세요."
    private let networkManager: NetworkManageable = NetworkManager()
    private var itemThumbnails: [UIImage] = []
    private var itemInformation: [String: Any?] = [:]
    
    // MARK: - Views
    
    private let titleTextField = TitleTextField()
    private let priceTextField = PriceTextField()
    private let discountedPriceTextField = DiscountedPriceTextField()
    private let stockTextField = StockTextField()
    private let passwordTextField = PasswordTextField()
    private let currencyTextField = CurrencyTextField()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.text = "개"
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let detailedInformationTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = "상품 정보를 입력 해 주세요."
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.white
        
        return pickerView
    }()
    
    private lazy var currencyPickerViewToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: currencyPickerView.frame.width, height: currencyPickerView.frame.height / 5))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.donePicker))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
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
    
    private let thumbnailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: ImagePickerCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let pricesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let currencyAndPricesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    private let stockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    private let itemRegistrationInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let sendItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        return sendItem
    }()
    
    // MARK: - ViewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        setUpNavigationItems()
        addSubviews()
        setUpUIConstraints()
        setDelegates()
        applyCurrencyTextField()
    }
    
    private func applyCurrencyTextField() {
        currencyTextField.textFieldDelegate = self
        currencyTextField.inputView = currencyPickerView
        currencyTextField.inputAccessoryView = currencyPickerViewToolbar
    }
    
    // MARK: - assign Delegates
    
    private func setDelegates() {
        titleTextField.textFieldDelegate = self
        priceTextField.textFieldDelegate = self
        discountedPriceTextField.textFieldDelegate = self
        stockTextField.textFieldDelegate = self
        passwordTextField.textFieldDelegate = self
        detailedInformationTextView.delegate = self
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
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
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    // MARK: - setUp UI Constraints
    
    private func addSubviews() {
        
        pricesStackView.addArrangedSubview(priceTextField)
        pricesStackView.addArrangedSubview(discountedPriceTextField)
        
        currencyAndPricesStackView.addArrangedSubview(currencyTextField)
        currencyAndPricesStackView.addArrangedSubview(pricesStackView)
        
        stockStackView.addArrangedSubview(stockTextField)
        stockStackView.addArrangedSubview(stockLabel)
        
        [titleTextField, passwordTextField, currencyAndPricesStackView, stockStackView].forEach { view in
            itemRegistrationInformationStackView.addArrangedSubview(view)
        }
        self.view.addSubview(uploadImageButton)
        self.view.addSubview(thumbnailCollectionView)
        self.view.addSubview(itemRegistrationInformationStackView)
        self.view.addSubview(detailedInformationTextView)
    }
    
    private func setUpUIConstraints() {
        
        NSLayoutConstraint.activate([
            
            uploadImageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            uploadImageButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            uploadImageButton.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            thumbnailCollectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 6.5),
            thumbnailCollectionView.topAnchor.constraint(equalTo: uploadImageButton.bottomAnchor, constant: 5),
            thumbnailCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            thumbnailCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            itemRegistrationInformationStackView.topAnchor.constraint(equalTo: thumbnailCollectionView.bottomAnchor, constant: 5),
            itemRegistrationInformationStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            itemRegistrationInformationStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            itemRegistrationInformationStackView.bottomAnchor.constraint(equalTo: detailedInformationTextView.topAnchor, constant: -5),
            
            detailedInformationTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            detailedInformationTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            detailedInformationTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
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
    
    @objc private func cancelPicker() {
        currencyTextField.resignFirstResponder()
        currencyTextField.text = nil
        currencyPickerView.selectRow(0, inComponent: 0, animated: true)
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
        itemInformation.updateValue(text, forKey: OpenMarketItemToPostOrPatch.descriptions.key)
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

extension OpenMarketItemViewController: PostingTextConvertible {
    
    func alertInvalidTextField(_ alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func convertPasswordTextToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {
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
    
    func convertOptionalTextToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {
        
        guard let text = text,
              let number = Int(text) else { return }
        itemInformation.updateValue(number, forKey: itemToPost.key)
    }
    
    func convertRequiredTextToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {
        
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
        cell.removeCellDelegate = self
        return cell
    }
}
extension OpenMarketItemViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Cell Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              windowScene.activationState == .foregroundActive else {
            return CGSize(width: 0, height: 0)
        }
        
        if windowScene.interfaceOrientation.isLandscape {
            let cellWidth = collectionView.frame.width / 5
            let cellHeight = collectionView.frame.height
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let cellWidth = collectionView.frame.width / 3
            let cellHeight = collectionView.frame.height
            return CGSize(width: cellWidth, height: cellHeight)
        }
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
