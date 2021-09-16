//
//  OpenMarketItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/06/14.
//

import UIKit

class OpenMarketItemViewController: UIViewController {
    
    enum Mode {
        case register, edit
    }
    
    // MARK: - Properties
    
    private let currencyList = ["KRW", "USD", "BTC", "JPY", "EUR", "GBP", "CNY"]
    private let imagePicker = UIImagePickerController()
    private let textViewDefaultMessage: String = "상품 정보를 입력 해 주세요."
    private let networkManager: NetworkManageable = NetworkManager()
    private var itemThumbnails: [UIImage] = []
    private var itemInformation: [String: Any?] = [:]
    private var itemID = Int()
    private let mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
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
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        
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
    
    private lazy var UIRightBarButtonItem: UIBarButtonItem = {
        let sendItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        return sendItem
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        setUpNavigationItems()
        addSubviews()
        setUpUIConstraints()
        setDelegates()
        applyCurrencyTextField()
        setUpPasswordTextField()
    }
    
    func setItemIdentityToPatch(idNumber: Int) {
        self.itemID = idNumber
    }
    
    func receiveInformation(of item: OpenMarketItemToGet?, images: [UIImage], password: String) {
        configureUIForEditMode(item, thumbnails: images, password: password)
    }
    
    private func applyCurrencyTextField() {
        currencyTextField.inputView = currencyPickerView
        currencyTextField.inputAccessoryView = currencyPickerViewToolbar
    }
    
    private func setUpPasswordTextField() {
        switch mode {
        case .edit:
            passwordTextField.isUserInteractionEnabled = false
            passwordTextField.textColor = .systemGray
            passwordTextField.delegate?.textFieldDidEndEditing?(passwordTextField)
        case .register:
            passwordTextField.isUserInteractionEnabled = true
        }
    }
    
    private func configureUIForEditMode(_ item: OpenMarketItemToGet?, thumbnails: [UIImage], password: String) {
        if mode == .edit,
           let validItem = item {
            
            self.titleTextField.text = validItem.title
            self.priceTextField.text = String(validItem.price)
            if let discountedPrice = validItem.discountedPrice {
                self.discountedPriceTextField.text = String(discountedPrice)
            } else {
                self.discountedPriceTextField.text = nil
            }
            self.stockTextField.text = String(validItem.stock)
            self.detailedInformationTextView.text = validItem.descriptions
            self.currencyTextField.text = validItem.currency
            self.itemThumbnails = thumbnails
            self.passwordTextField.text = password
        }
    }
    
    // MARK: - assign Delegates
    
    private func setDelegates() {
        titleTextField.delegate = self
        currencyTextField.delegate = self
        priceTextField.delegate = self
        discountedPriceTextField.delegate = self
        stockTextField.delegate = self
        passwordTextField.delegate = self
        detailedInformationTextView.delegate = self
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
}
extension OpenMarketItemViewController {
    
    // MARK: - Method: Send Information to Server
    
    private func examineRequiredInformationToPost() {
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
    
    private func alertConfirmationToPostItem() {
        let alertController = UIAlertController(title: "작성 완료", message: "틀린 내용이 없는지 꼼꼼히 확인 해 주세요. 정말로 상품을 마켓에 올리시겠습니까?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { action in
            
            self.postItemToServer()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func postItemToServer() {
        self.networkManager.postSingleItem(url: OpenMarketAPI.urlForSingleItemToPost.description, texts: self.itemInformation, imageList: self.itemThumbnails) { [weak self] response in
            DispatchQueue.main.async {
                if (200...299).contains(response.statusCode) {
                    self?.alertSuccessfulResponseToUser()
                } else {
                    self?.alertFailedResponseToUser()
                }
            }
        }
    }
    
    
    private func alertProceedToEditItem() {
        let alertController = UIAlertController(title: "상품 수정", message: "정말로 상품을 수정하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] alertAction in
            self?.updateEditedItemInformation()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func updateEditedItemInformation() {
        self.networkManager.patchSingleItem(url: "\(OpenMarketAPI.urlForSingleItemToGetPatchOrDelete)\(itemID)", texts: itemInformation, images: itemThumbnails) { [weak self] response in
            DispatchQueue.main.async {
                if (200...299).contains(response.statusCode) {
                    self?.alertSuccessfulResponseToUser()
                } else {
                    self?.alertFailedResponseToUser()
                }
            }
        }
    }
    
    private func alertSuccessfulResponseToUser() {
        let editTitle = "상품 수정 완료"
        let editMessage = "상품 수정이 정상적으로 완료되었습니다."
        let registerTitle = "상품 등록 완료"
        let registerMessage = "상품 등록이 정상적으로 완료되었습니다."
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        if mode == .register {
            alertController.title = registerTitle
            alertController.message = registerMessage
        } else {
            alertController.title = editTitle
            alertController.message = editMessage
        }
        
        self.present(alertController, animated: true) {
            
            let delay = DispatchTime.now() + 1
            
            DispatchQueue.main.asyncAfter(deadline: delay) {
                alertController.dismiss(animated: true) {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.notifyToRefreshItemList()
                }
            }
        }
    }
    
    private func alertFailedResponseToUser() {
        let editTitle = "상품 수정 실패"
        let editMessage = "상품 수정을 실패하였습니다."
        let registerTitle = "상품 등록 실패"
        let registerMessage = "상품 등록을 실패하였습니다."
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        if mode == .register {
            alertController.title = registerTitle
            alertController.message = registerMessage
        } else {
            alertController.title = editTitle
            alertController.message = editMessage
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        switch mode {
        case .edit:
            alertProceedToEditItem()
        case .register:
            examineRequiredInformationToPost()
            alertConfirmationToPostItem()
        }
    }
    
    private func notifyToRefreshItemList() {
        NotificationCenter.default.post(name: .needToRefreshItemList, object: nil)
    }

    // MARK: - Method: hide keyboard when tapped around
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - setUp NavigationItems
    
    private func setUpNavigationItems() {
        switch mode {
        case .edit:
            self.navigationItem.title = "상품수정"
        case .register:
            self.navigationItem.title = "상품등록"
        }
        self.navigationItem.rightBarButtonItem = UIRightBarButtonItem
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            convertTextFieldToDictionary(OpenMarketItemToPostOrPatch.title, textField.text)
        } else if textField == priceTextField {
            convertTextFieldToDictionary(OpenMarketItemToPostOrPatch.price, textField.text)
        } else if textField == discountedPriceTextField {
            convertOptionalTextFieldToDictionary(OpenMarketItemToPostOrPatch.discountedPrice, textField.text)
        } else if textField == currencyTextField {
            convertTextFieldToDictionary(OpenMarketItemToPostOrPatch.currency, textField.text)
        } else if textField == stockTextField {
            convertTextFieldToDictionary(OpenMarketItemToPostOrPatch.stock, textField.text)
        } else if textField == passwordTextField {
            convertPasswordTextFieldToDictionary(OpenMarketItemToPostOrPatch.password, textField.text)
        }
    }
}

// MARK: - Convert Texts to Dictionary

extension OpenMarketItemViewController {
    
    private func alertInvalidPassword() {
        let alertController = UIAlertController(title: "비밀번호 설정", message: "비밀번호를 영문, 숫자를 사용해서 입력 해 주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func convertPasswordTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {
        itemInformation.updateValue(text, forKey: itemToPost.key)
        
        guard let validText = text,
              !validText.isEmpty else {
            alertInvalidPassword()
            return
        }
        
        itemInformation.updateValue(text, forKey: itemToPost.key)
    }
    
    func convertOptionalTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {
        
        guard let text = text,
              let number = Int(text) else { return }
        itemInformation.updateValue(number, forKey: itemToPost.key)
    }
    
    func convertTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {
        
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
            alertUploadPhoto()
        } else {
            alertLimitNumberOfPhoto()
        }
    }
    
    private func alertUploadPhoto() {
        let alertController = UIAlertController(title: "상품사진", message: nil, preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "사진 앨범", style: .default) { action in
            self.openPhotoLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func alertLimitNumberOfPhoto() {
        let alertController = UIAlertController(title: "사진 제한", message: "사진은 총 5장으로 제한 됩니다.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func openPhotoLibrary() {
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
        cell.configureImage(itemThumbnails, indexPath: indexPath)
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
