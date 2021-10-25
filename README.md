# 오픈 마켓 프로젝트

---

1. [프로젝트 개요](#1-프로젝트-개요)
   - [MVC](#mvc)
   - [기술 스택](#기술-스택)
   - [AutoLayout](#autolayout)
2. [주요기능](#2-주요기능)
   - [상품 목록 확인](#상품-목록)
   - [상품등록](#상품등록)
   - [상품 수정](#상품-수정)
   - [상품 삭제](#상품-삭제)
3. [설계 및 상세구현](#3-설계-및-상세구현)
   - [UML](#uml)
   - [상품 목록 구현](#상품-목록-구현)
     - [상품 리스트 GET 시나리오](#상품-리스트-get-시나리오)
     - [Infinite Scrolling 시나리오](#infinite-scrolling-시나리오)
   - [상품 등록화면 구현](#상품-등록화면-구현)
     - [사진 첨부 시나리오](#사진-첨부-시나리오)
     - [상품 등록 시나리오](#상품-등록-시나리오)
   - [상품 상세화면 구현](#상품-상세화면-구현)
     - [상세 화면 이미지 로드 시나리오](#상세-화면-이미지-로드-시나리오)
   - [상품 수정화면 구현](#상품-수정화면-구현)
     - [화면 이동 /수정 시나리오](#화면-이동-수정-시나리오)
   - [상품 삭제화면 구현](#상품-삭제화면-구현)
     - [상품 삭제 시나리오](#상품-삭제-시나리오)
4. [유닛 테스트](#4-유닛-테스트)
   - [Unit Test의 중요성](#unit-test의-중요성)
     - [Unit Test가 필요한 이유](#unit-test가-필요한-이유)
     - [네트워크에 의존하지 않는 테스트 구현](#네트워크에-의존하지-않는-테스트-구현)
     - [비즈니스 로직에 대한 테스트 진행](#비즈니스-로직에-대한-테스트-진행)
5. [고민한 내용](#5-고민한-내용)
   - [더 객체지향적으로 프로젝트를 개선할 수 있을까](#더-객체지향적으로-프로젝트를-개선할-수-있을까)
     - [리팩토링의 필요성](#리팩토링의-필요성)
     - [단일 책임 원칙을 지키지 않았을 때의 문제점](#단일-책임-원칙을-지키지-않았을-때의-문제점)
     - [리팩토링: 객체의 모듈화](#리팩토링-객체의-모듈화)
     - [의존관계 역전 원칙을 더한 모듈화](#의존관계-역전-원칙을-더한-모듈화)
6. [Trouble Shooting](#6-trouble-shooting)
   - [alertController가 곂치는 문제 해결](https://velog.io/@inwoodev/June-22-2021-TIL-Today-I-Learned-present-modally-TroubleShooting)
   - [log를 통한 multipart/form-data 문제 해결](https://velog.io/@inwoodev/June-23-2021-TIL-Today-I-Learned-로그를-찍어야-하는-이유)
   - [collectionView의 autolayout 문제 해결](https://velog.io/@inwoodev/Aug-25-2021-TIL-Today-I-Learned-이미지-전환과-UIPageControl)
   - [네트워크 응답을 받지 못하는 문제 해결](https://velog.io/@inwoodev/Sept-15-2021-TIL-Today-I-Learned-HTTPURLResponse-MIMEType-TroubleShooting)
   - [캐시처리가 안되는 문제 해결](https://velog.io/@inwoodev/Sept-26-2021-TIL-Today-I-Learned-Computed-Property-Extension-캐시처리가-안되는-문제-TroubleShooting)

# 1. 프로젝트 개요

**[REST API](https://docs.google.com/spreadsheets/d/1_l6aPfEUchSF_ymIp0DjyH8Ic00GIoqvd8dO9f7_sx4/edit#gid=1153044612) 연동을 통해 상품을 확인, 등록, 수정 및 삭제를 할 수 있는 마켓 앱입니다.**

## MVC

MVC 패턴은 다음과 같은 장점이 있습니다

1. 대중성
2. 단순함
3. 신속성

이와 같은 장점이 있기에 이번 프로젝트에 MVC 아키텍처 기반으로 앱을 설계하였습니다.

다만 MVC패턴의 고질적인 문제점으로 대두되는 Masive ViewController가 만들어지는것을 방지하기 위해 뷰 컨트롤러의 존재하는 최대한 많은 로직을 별도의 클래스로 분리하였습니다.

## 기술 스택

| 카테고리    | 기술 스택                                                    |
| ----------- | ------------------------------------------------------------ |
| UI          | - UIKit                                                      |
| Network     | - URLSession                                                 |
| DataParsing | - Encodable / Decodable<br />- JSONEncoder / JSONDecoder<br />- multipart/form-data |
| Cache       | - NSCache                                                    |
| UnitTest    | - XCTest                                                     |



## AutoLayout

이번 프로젝트는 스토리보드를 사용하지 않고 오직 코드만을 활용하여 UI를 구현하였습니다.

#### [목차로 돌아가기](#오픈-마켓-프로젝트)
---

# 2. 주요기능

## 상품 목록

### 상품목록 스크롤

![Simulator Screen Recording - iPhone 12 Pro - 2021-10-06 at 14.55.44](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211006145810.gif) ![Simulator Screen Recording - iPhone 12 Pro - 2021-10-06 at 14.55.44](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211006145731.gif)



### 가로 모드 지원

![Simulator Screen Recording - iPhone 12 Pro - 2021-10-06 at 14.59.02](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211006150002.gif) ![Simulator Screen Recording - iPhone 12 Pro - 2021-10-06 at 15.00.35](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211006150055.gif)



## 상품등록

### 사진 첨부 및 첨부 삭제

![Simulator Screen Recording - iPhone 12 Pro - 2021-10-07 at 13.45.14](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007134620.gif) ![Simulator Screen Recording - iPhone 12 Pro - 2021-10-07 at 13.54.44](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007135457.gif)



### 상품 정보 입력 & 상품 등록

![Simulator Screen Recording - iPhone 12 Pro - 2021-10-07 at 13.56.33](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007135648.gif) ![Simulator Screen Recording - iPhone 12 Pro - 2021-10-07 at 13.57.25](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007135742.gif)



## 상품 수정

### 비밀번호 입력을 통해 수정화면 접근 & 잘못된 비밀번호 입력시 수정화면 접근 불가

![Simulator Screen Recording - iPhone 12 Pro - 2021-10-07 at 14.05.53](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007140613.gif)



### 상품 정보 수정

![Simulator Screen Recording - iPhone 12 Pro - 2021-10-07 at 14.07.50](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007140812.gif) ![Simulator Screen Recording - iPhone 12 Pro - 2021-10-07 at 14.10.48](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007141142.gif)



## 상품 삭제

### 올바른 비밀번호 입력시 상품 삭제

![Simulator Screen Recording - iPhone 12 Pro - 2021-10-07 at 14.13.36](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007141358.gif)

#### [목차로 돌아가기](#오픈-마켓-프로젝트)
---

# 3. 설계 및 상세구현

## UML

클래스가 내부적으로 자원에 의존해야 하는 경우 자원을 직접명시하지 않고 프로토콜을 활용한 의존 객체 주입을 사용하여 객체간의 느슨한 결합을 도모하였습니다.

![OpenMarketModel](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007142119.png)

![OpenMarketView&Controller](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007142158.png)



## 상품 목록 구현

### 상품 리스트 GET 시나리오

![Screen Shot 2021-10-08 at 12.14.32 AM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211008001453.png)

```swift
func insertOpenMarketItemList(page: Int, completion: @escaping ([OpenMarketItem], startItemCount, totalItemCount) -> ()) {
        dataManager.getOpenMarketItemModel(serverAPI: .itemList(page)) { [weak self] (itemList: OpenMarketItemList) in
            
            let startItemCount = self?.openMarketItems.count ?? 0
            let totalItemCount = startItemCount + itemList.items.count
            
            self?.openMarketItems.append(contentsOf: itemList.items)
            
            completion(self?.openMarketItems ?? [], startItemCount, totalItemCount)
        }
    }
```

`getOpenMarketItemModel()` 메서드를 통해 openMarketItemList를 받아온 뒤 `startIndex` 와 `endIndex` 에 대한 정보를 덧붙여서 collectionView에 insert할 작업을 준비합니다.

### Infinite Scrolling 시나리오

![Screen Shot 2021-10-07 at 11.40.39 PM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211007234105.png)

- 유저가 스크롤을 하여 scrollView의 contentOffset.y가 조건을 만족할 경우 `getOpenMarketItemList()` 메서드를 호출하여 상품목록을 추가로 `GET` 해 옵니다.

``` swift
private func getOpenMarketItemList() {
        if self.isLastItem {
            self.isLastItem = false
        }
        itemListDataStorage.insertOpenMarketItemList(page: nextPageToLoad) { itemList, startItemCount, totalItemCount in
            DispatchQueue.main.async {
                self.openMarketCollectionView.performBatchUpdates({
                    for index in startItemCount..<totalItemCount {
                        let indexPath = IndexPath(item: index, section: 0)
                        self.openMarketCollectionView.insertItems(at: [indexPath])
                    }
                }) { loadingFinished in
                    self.activityIndicator.stopAnimating()
                    self.nextPageToLoad += 1
                    self.refreshControl.endRefreshing()
                    self.isLastItem = true
                }
            }
        }
    }
```

- `isLastItem` 이라는 boolean 변수를 활용하여 `scrollViewDidScroll()` 메서드에 의해서 중복된 값을 호출하지 않도록 구현하였습니다.

```swift
extension OpenMarketViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        guard isLastItem else { return }
        
        if position > (scrollView.contentSize.height - scrollView.frame.height) {
            getOpenMarketItemList()
        }
    }
}
```

## 상품 등록화면 구현

### 사진 첨부 시나리오

![Screen Shot 2021-10-08 at 1.15.08 AM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211008011538.png)

```swift
extension OpenMarketItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage: UIImage = info[.originalImage] as? UIImage else { return }
        // 이미지 압축 작업
        ImageCompressor.compress(image: selectedImage, maxByte: 300000) { image in
            // dataStorage에 사진 추가
                                                                        self.multipartFormDataStorage.addImages([image ?? selectedImage])
            
            DispatchQueue.main.async {
              // collectionView reload
                self.thumbnailCollectionView.reloadData()
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}
```



### 상품 등록 시나리오

![Screen Shot 2021-10-08 at 1.34.35 AM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211008013443.png)

TextField에 사용자가 정보를 입력하면 정보의 유효성을 검사한 뒤 `multipartFormDataStorage`에 값을 저장하게 됩니다.

``` swift
func convertPasswordTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {
        multipartFormDataStorage.updateItemInformation(text, forKey: itemToPost.key)

        guard let validText = text,
              !validText.isEmpty else {
            alertInvalidPassword()
            return
        }
        
        multipartFormDataStorage.updateItemInformation(text, forKey: itemToPost.key)
    }
    
    func convertOptionalTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {

        guard let text = text,
              let number = Int(text) else { return }
        multipartFormDataStorage.updateItemInformation(number, forKey: itemToPost.key)
    }
    
    func convertTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?) {
        
        guard let text = text else { return }
        if let number = Int(text) {
            multipartFormDataStorage.updateItemInformation(number, forKey: itemToPost.key)
            
        } else {
            multipartFormDataStorage.updateItemInformation(text, forKey: itemToPost.key)
        }
    }
```



multipartFormdataStorage에 저장된 정보를 활용하여 `patch`  request를 보낸 뒤 서버로 부터 200~299 응답코드를 받게 되면 유저에게 수정이 완료되었음을 알려주게됩니다.

```swift
private func updateEditedItemInformation() {
        multipartFormDataStorage.patchOpenMarketItem(id: itemID) { response in
            DispatchQueue.main.async {
                if (200...299).contains(response.statusCode) {
                    self.alertSuccessfulResponseToUser()
                } else {
                    self.alertFailedResponseToUser()
                }
            }
        }
    }
```



## 상품 상세화면 구현

### 상세 화면 이미지 로드 시나리오

![Screen Shot 2021-10-08 at 2.27.27 AM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211008022806.png)



For문을 돌려 서버를 통해 전달받은 url을 받아서 다량의 이미지를 다운로드 받고 받은 데이터를 escaping closure를 통해 반환하는 메서드 입니다.

모든 이미지가 다 받아진 뒤 이미지 배열을 반환할 수 있게 dispatch group을 통해 group에 들어간 작업들이 끝나기를 기다렸다 작업이 모두 끝난 후에 @escaping closure를 통해 이미지 배열을 반환하도록 설계하였습니다.

```swift
func downloadImages(completion: @escaping ([UIImage]) -> Void) {
        guard let downloadedImageURLStrings = itemInformation?.thumbnails else {
            return
            
        }
        
        var imageArray = [UIImage]()
        let dispatchGroup = DispatchGroup()
        
        for urlString in downloadedImageURLStrings {
            dispatchGroup.enter()
            cachedImageLoader.loadImageWithCache(with: urlString) { image in
                imageArray.append(image)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.sliderImages.append(contentsOf: imageArray)
            completion(imageArray)
        }
    }
```



## 상품 수정화면 구현

### 화면 이동 /수정 시나리오

![Screen Shot 2021-10-08 at 8.54.27 PM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211008205509.png)

별도의 수정화면을 담당하는 View Controller를 생성하는 대신 기존에 상품 등록을 담당하는 ViewController을 재사용하여 상품목록 수정화면을 구현하였습니다. 수정화면과 등록화면의 차이점을 두기 위해 열거형의 case를 사용하였습니다.

```swift
private func proceedToEditItem(insert password: String) {
        let editItemViewController = OpenMarketItemViewController(mode: .edit)
        let itemInformation = itemInformationDataSource.accessItemInformation()
        let itemSliderImages = itemInformationDataSource.accessSliderImages()
        editItemViewController.setItemIdentityToPatch(idNumber: itemID)
        editItemViewController.receiveInformation(of: itemInformation, images: itemSliderImages, password: password)
        navigationController?.pushViewController(editItemViewController, animated: true)
    }
```



수정 버튼을 누를 경우 비밀번호 입력 알림창이 뜨게 되고 올바른 비밀 번호 입력값을 받아 `proceedToPatchOpenMarketItem()` 메서드를 실행하게 되고 응답코드가 200~299일 경우 올바른 패스워드가 입력 되었다 판단 하여 수정화면으로 화면이 전환되도록 구현하였습니다.

```swift
private func usePasswordToEditOrDeleteItem(userChoice: UserChoice, _ password: String) {
        
        switch userChoice {
        case .edit:
            itemInformationDataSource.proceedToPatchOpenMarketItem(id: itemID, password: password) { [weak self] response in
                DispatchQueue.main.async {
                    // 상품수정화면으로 전환해도 되는지 체크하는 메서드
                    self?.alertWhetherItemCanBeEditedOrNot(with: password, check: response)
                }
            }
        case .delete:
            // 상품 삭제 로직
        }
    }
```

```swift
private func alertWhetherItemCanBeEditedOrNot(with password: String, check response: HTTPURLResponse) {
        if (200...299).contains(response.statusCode) {
            self.proceedToEditItem(password)
        } else {
            self.alertInvalidPassword(.edit)
        }
    }
```



## 상품 삭제화면 구현

### 상품 삭제 시나리오

![Screen Shot 2021-10-08 at 9.39.33 PM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20211008214002.png)

"삭제 후 되돌릴 수 없습니다" 메세지를 사용자에게 알린 뒤 사용자가 ok를 텝할 경우 상품을 삭제하는 과정을 거치게 됩니다.

```swift
private func usePasswordToEditOrDeleteItem(userChoice: UserChoice, _ password: String) {
        
        switch userChoice {
        case .edit:
            // 상품 수정 로직
        case .delete:
            self.alertDeleteConfirmation(given: password)
        }
    }
```

itemInformationDataSource가 상품을 삭제한 뒤 서버로 부터 응답을 받게 됩니다.

```swift
private func alertDeleteConfirmation(given password: String) {
        let alertController = UIAlertController(title: "주의", message: "삭제 후 되돌릴 수 없습니다. 정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { ok in
            
            self.itemInformationDataSource.deleteOpenMarketItem(id: self.itemID, password: password) { [weak self] response in
                DispatchQueue.main.async {
                    self?.alertWhetherItemIsDeltedOrNot(check: response, with: alertController)
                }
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { cancel in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
```

서버 통신 후 받은 응답 코드에 따라 상품정보 삭제가 성공 또는 실패됐음을 알리는 알림창이 화면에 표시됩니다.

```swift
private func alertWhetherItemIsDeltedOrNot(check response: HTTPURLResponse, with alertController: UIAlertController) {
        if (200...299).contains(response.statusCode) {
            self.notifyThatAnItemIsDeleted()
            alertController.dismiss(animated: true) {
                self.alertSuccessfulDeletion()
            }
        } else {
            self.alertInvalidPassword(.delete)
        }
    }
```
#### [목차로 돌아가기](#오픈-마켓-프로젝트)
---


# 4. 유닛 테스트

## Unit Test의 중요성

### Unit Test가 필요한 이유

Unit Test가 제공하는 몇 가지 장점은 아래와 같습니다.

1. 불안감 없이 코드 작성을 할 수 있는 환경을 만들어줍니다.
2. 주어진 요구사항을 만족하는지에 대한 지속적인 추적이 가능해 집니다.

3. 각 각의 모듈의 부분적 결함을 바로 확인할 수 있습니다.

4. 더 나아가 이후 변경사항으로 인해 발생 가능한 결함을 찾아낼 수 있다는 메리트를 제공합니다.

이처럼 유닛테스트를 진행하여 비즈니스 로직의 부족한 점을 깨달을 수 있었고 더 나아가 테스트를 성공한 부분의 로직에 대한 확실성을 얻을 수 있었습니다. 



**이 외에도 이번 프로젝트를 통해 느낀 점은 Unit Test가 프로젝트를 더 객체지향적으로 설계할 수 있게 도와주고 보다 더 깔끔하고 재사용성이 좋은 코드 작업을 가능하게 해 준다는 것 입니다.**

- 각 기능 별 독립적인 테스트를 구상해야 하니 자연스럽게 하나의 공통된 기능을 보유한 모듈별로 객체를 나눌 수 있게 되었습니다. 이를 통해 단일책임원칙이 자연스럽게 프로젝트에 녹아들 수 있었습니다.
- `Network` 라는 모듈이 이러한 과정에서 생겼고 이렇게 단일책임을 지키는 모듈을 통해서  JSON파일을 가져오는 것 뿐 아니라 이미지를 가져오는 작업 그리고 멀티파트폼을 보내는 작업까지 해당 모듈을 재활용하여 프로젝트를 설계할 수 있었습니다. 덕분에  중복되는 코드를 제거할 수 있었습니다.



### 네트워크에 의존하지 않는 테스트 구현

실제 URLSession과 URLSessionDataTask를 대신할 [MockURLSession](https://github.com/inwoodev/ios-open-market-app/blob/step5-james/OpenMarket/OpenMarketNetworkTests/MockURLSession.swift) [MockURLSessionDataTask](https://github.com/inwoodev/ios-open-market-app/blob/step5-james/OpenMarket/OpenMarketNetworkTests/MockURLSessionDataTask.swift]) Test Double을 구현하였습니다.

Network 객체의 `urlSession`을 MockURLSession과 같이 `URLSessionProtocol` 을 채택하게 하여 테스트시 Network을 초기화 할 때 `MockURLSession` 을 주입받아서 네트워크에 종속되지 않은 프로그램된 결과를 받을 수 있도록 설계하였습니다.

`mockURLSession`의 `sessionDataTask`가 `resume()` 될 때 `buildRequestFail` 이라는 boolean 변수의 상태에 따라 escaping closure에  `successfulResponse` 또는 `failureResponse` 를 callback으로 넘겨주고 `URLSessionDataTask` 를 반환하도록 설계하였습니다.

request를 성공적으로 build하는 경우, request에 이미지만 포함하는 경우, 그리고 build fail 하는 경우 각각에 맞게 필요한 dummy 객체, stub객체를 callback으로 넘겨주도록 설계하였습니다.

```swift
sessionDataTask.resumeDidCall = {
            if self.buildRequestFail {
                completionHandler(nil, failureResponse, error)
            } else if self.isImageOnly {
                completionHandler(dummy_image_data, successfulResponse, nil)
            }
            else {
                completionHandler(stub_item_data, successfulResponse, nil)
            }
        }
```



### 비즈니스 로직에 대한 테스트 진행

- 네트워크로부터 데이터를 가져와서 가공하는 각 각의 모듈이 제대로 작동하는지 테스트 진행
  - 먼저 각 모듈이 독립적으로 테스트를 진행하기 위해 각 모듈에 속해 있는 프로퍼티에 필요한
    Mock, Spy, Stub 객체를 구현하였습니다.
  - 각 모듈의 프로퍼티를 프로토콜을 채택하게 하여 의존성 역전을 구현하였고 이를 통해 Test Double 객체들을 외부로부터 주입 받아 각 모듈의 기능을 독립적으로 테스트를 진행하였습니다.
  - 마지막으로 모듈을 총괄하는 OpenMarketDataManager와 CachedImagLoader의 메서드들을 테스트 하여 각 모듈이 필요한 기능을 수행하는지 테스트를 진행할 수 있었습니다.

#### [목차로 돌아가기](#오픈-마켓-프로젝트)
---

# 5. 고민한 내용

## 더 객체지향적으로 프로젝트를 개선할 수 있을까?

### 리팩토링의 필요성

로버트 마틴이 소개한 객체지향의 기본 원칙을 OpenMarket 프로젝트를 비춰봤을 때 리팩토링이 시급하다는 것을 느꼈습니다.

Single Responsibility Principle에 따르면 하나의 클래스는 단 한가지의 책임만을 가져야 합니다. 그런데 OpenMarket의 핵심 역할을 하는 Network Manager 같은 경우 한 가지 이상의 과도하게 많은 역할을 하는 것을 확인할 수 있습니다.

![Screen Shot 2021-09-25 at 4.26.04 PM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20210925162611.png)

- 네트워크에 필요한 `dataTask`와 `urlSession`을 프로퍼티로 갖고 있고

- Multipart/form-data 통신을 위한 `boundary`를 프로퍼티로 갖고 있고

- collectionview의 pagination을 위한 `isReadyToPaginate` bool 프로퍼티 또한 갖고 있습니다.

뿐 만 아니라 NetworkManager의 메서드를 자세히 살펴보면

```swift
func getItemList(page: Int, loadingFinished: Bool = false, completionHandler: @escaping (_ result: Result <OpenMarketItemList, Error>) -> Void) {
        
        if loadingFinished {
            isReadyToPaginate = false
        }
        
        guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(page)") else {
            return completionHandler(.failure(NetworkResponseError.badRequest))
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.description
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(NetworkResponseError.noData))
                print(dataError.localizedDescription)
            }
            if let urlResponse = response as? HTTPURLResponse {
                let urlResponseResult = self.handleNetworkResponseError(urlResponse)
                switch urlResponseResult {
                case .failure(let errorDescription):
                    print(errorDescription)
                    return completionHandler(.failure(NetworkResponseError.badRequest))
                case .success:
                    guard let itemListData = data else {
                        return completionHandler(.failure(NetworkResponseError.noData))
                    }
                    if let itemList = try? JSONDecoder().decode(OpenMarketItemList.self, from: itemListData) {
                        completionHandler(.success(itemList))
                        if loadingFinished {
                            self.isReadyToPaginate = true
                        }
                        
                    } else {
                        completionHandler(.failure(DataError.decoding))
                    }
                }
            }
        }.resume()
    }
```

하나의 메서드 안에서 여러가지 작업이 이루어지는 것을 볼 수 있습니다.

1. Pagination이 진행되야 하는지 유무를 검사하고

```swift
if loadingFinished {
            isReadyToPaginate = false
        }
```

2. String을 url로 변환하고

```swift
guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(page)") else {
            return completionHandler(.failure(NetworkResponseError.badRequest))
        }
```



3. URLRequest를 생성하고

```swift
var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.description
```

4. 네트워크 통신을 통해 data를 받아오고

```swift
urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(NetworkResponseError.noData))
                print(dataError.localizedDescription)
            }
            if let urlResponse = response as? HTTPURLResponse {
                let urlResponseResult = self.handleNetworkResponseError(urlResponse)
                switch urlResponseResult {
                case .failure(let errorDescription):
                    print(errorDescription)
                    return completionHandler(.failure(NetworkResponseError.badRequest))
                case .success:
                    guard let itemListData = data else {
                        return completionHandler(.failure(NetworkResponseError.noData))
                    }
```

5. 받아온 데이터를 사용가능한 타입으로 decoding하는 작업

```swift
if let itemList = try? JSONDecoder().decode(OpenMarketItemList.self, from: itemListData)
```

6. 이 외에도 multipart/form-data를 만들어주는 메서드까지

```swift
 private func openMarketItemMultipartFormDataTask(httpMethod: HTTPMethods, url: String, texts: [String : Any?], imageList: [UIImage]?, completionHandler: @escaping(_ result: Result <HTTPURLResponse, NetworkResponseError>) -> Void)
```

하나의 메서드 안에서 너무 많은 작업이 이루어지는 것 또한 단일책임 원칙상 적절하지 못한 것을 확인할 수 있습니다.

### 단일 책임 원칙을 지키지 않았을 때의 문제점

1. 유지보수가 힘들어집니다.

이렇게 하나의 메서드 안에서 많은 작업이 이루어지면 하나의 작업에 변화를 줄 경우 연쇄적으로 코드를 수정해야 하는 문제를 맞닥드릴 수 있다는 것을 깨달았습니다. 책임의 개수가 많아질 수록 각 책임의 기능 변화가 다른 책임에 주는 영향이 비례해서 증가하고 이는 코드를 절차 지향적으로 변화하게 하여 유지보수를 추후에 더더욱 힘들게 할 수 있다는 점을 인지하였습니다..

2. 재사용이 어려워집니다.

`getItemList()` 와 `getSingleItem()` 메서드는 request에 할당하는 url 그리고 decoding 하는 decodable model만 다를 뿐 dataTask를 통해서 data를 가져오는 과정은 동일합니다. 그런데 위와 같이 데이터를 가져와서 `OpenMarketItemList` 모델로 파싱하는 작업까지 진행을하게 되니 urlSession의 dataTask를 재사용하지 못하고 동일한 코드를 한 번 더 작성해야 하는 번거로움이 존재하였습니다.

```swift
func getSingleItem(itemURL: String, id: Int, completion: @escaping (_ result: Result <OpenMarketItemToGet, NetworkResponseError>) -> Void) {
  .
  .
  .
   dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let networkError = error {
                completion(.failure(NetworkResponseError.noData))
                NSLog(networkError.localizedDescription)
            }
            
            if let httpURLResponse = response as? HTTPURLResponse {
                let result = self.handleNetworkResponseError(httpURLResponse)
                switch result {
                case .success:
                    guard let completeData = data,
                          let singleItem = try? JSONDecoder().decode(OpenMarketItemToGet.self, from: completeData) else {
                        return completion(.failure(NetworkResponseError.noData))
                    }
                    completion(.success(singleItem))
                case .failure(let description):
                    NSLog(description)
                    completion(.failure(NetworkResponseError.badRequest))
                }
            }
        }
        dataTask?.resume()
}
```

만약 책임 원칙에 따라 책임이 분리되고 단순히 데이터만을 가져오는 객체가 있다면 해당 객체를 재사용하여 중복되는 코드를 줄일 수 있다는 것을 깨달았습니다.



### 리팩토링: 객체의 모듈화

로버트 마틴은 SingleResponsibility Principle을 다음과 같이 정의하였습니다.

> 하나의 모듈은 하나의, 오직 하나의 액터에 대해서만 책임져야 한다.

여기서 액터는 **시스템이 동일한 방식으로 변경되기를 원하는 사용자(클라이언트) 집단을** 뜻한다고 합니다.

저는 이 부분을 참고하여 네트워크에서 데이터를 받아와서 사용가능한 데이터로 가공하는 프로세스를 총 4가지로 나누어서 각 프로세스를 모듈화하였습니다.

![Screen Shot 2021-09-25 at 6.19.04 PM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20210925181917.png)

```swift
final class OpenMarketDataManager {
    private let network: Networkable
    private let dataParser: DataParsible?
    private let multipartFormDataBuilder: MultipartFormDataBuildable?
    private let requestBuilder: RequestBuildable
    
    init(network: Networkable, dataParser: DataParsible?, multipartFormDataBuilder: MultipartFormDataBuildable?, requestBuilder: RequestBuildable) {
        self.network = network
        self.dataParser = dataParser
        self.multipartFormDataBuilder = multipartFormDataBuilder
        self.requestBuilder = requestBuilder
    }
    
    func getOpenMarketItemModel< U: Decodable> (serverAPI: OpenMarketServerAPI<Int>, completion: @escaping (U) -> ()) {
        
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .get, httpBody: nil, headerField: nil, value: nil)
        
        self.network.load(request: request, completion: { [weak self] data, response, responseError in
            if let networkResponseError = responseError {
                NSLog(networkResponseError.description)
            }
            guard let validData = data,
                  let _ = response else { return }
            
            self?.dataParser.decodeData(validData, completion: { (_ result: Result<U, DataError>) in
                switch result {
                case .failure(let dataError):
                    NSLog(dataError.description)
                case .success(let decodable):
                    return completion(decodable)
                }
            })
        })
    }
```

`RequestBuilder` 는 네트워크 통신에 필요한 request를 생성하는 역할을 담당합니다.

```swift
 let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .get, httpBody: nil, headerField: nil, value: nil)
```



`Network` 객체는 네트워크에서 data를 load하는 책임을 담당합니다.

```swift
self.network.load(request: request, completion: { [weak self] data, response, responseError in
            if let networkResponseError = responseError {
                NSLog(networkResponseError.description)
            }
            guard let validData = data,
                  let _ = response else { return }
```



`DataParser` 객체는 받아온 데이터를 파싱하는 책임을 담당합니다.

```swift
self?.dataParser.decodeData(validData, completion: { (_ result: Result<U, DataError>) in
                switch result {
                case .failure(let dataError):
                    NSLog(dataError.description)
                case .success(let decodable):
                    return completion(decodable)
                }
```



`MultipartFormDataBuilder` 는 멀티파트데이터 통신에 필요한 form을 생성하는 역할을 담당합니다.

```swift
func postOpenMarketItemData(serverAPI: OpenMarketServerAPI<Int>, texts: [String : Any?], imageList: [UIImage], completionHandler: @escaping (HTTPURLResponse) -> Void) {
        
         guard let boundary = multipartFormDataBuilder?.generateBoundary() else { return }
        let multipartFormData = self.multipartFormDataBuilder?.buildMultipartFormData(texts, imageList, boundary: boundary)
        let value = "multipart/form-data;boundary=\(boundary)"
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .post, httpBody: multipartFormData, headerField: "Content-Type", value: value)
  . // 네트워크 객체의 load 기능 수행
  . // 응답 코드를 받아서 @escaping으로 반환하는 동작
  .
}
```

이렇게 책임을 분리하여 코드를 구현하니 get, post, patch, delete 하는 메서드 마다 필요한 모듈 객체가 책임을 나눠 갖고 독립적으로 각 각의 프로세스를 진행하도록 설계하였습니다. 또한 필수가 아닌 몇 몇 모듈을 옵셔널타입으로 선언하여 필요시에만 사용될 수 있도록 설계하였습니다. 



**이와 같은 설계는 다음과 같은 장점을 제공합니다.**

1. 네트워크, 파싱 등등 복잡한 로직(상호작용)을 캡슐화할 수 있습니다.

2. 추후 수정에 있어서 전체 코드를 절차적으로 수정하기 보다는 각 각의 모듈만을 수정하여 추후 확장에 더 유연하게 대처할 수 있다는 장점을 살릴 수 있었습니다(개방 폐쇄 원칙 [OCP])
3. 사용하지 않는 불필요한 인터페이스에 의존하지 않습니다.(인터페이스 분리 법칙 [ISP])



### 의존관계 역전 원칙을 더한 모듈화

`OpenMarketDataManager` 가 아래와 같이 설계되면 각 각의 모듈에 강한 결합을 가지게 될 수 있습니다.

```swift
final class OpenMarketDataManager {
    private let network = Network()
    private let dataParser = DataParser()
    private let multipartFormDataBuilder = MultipartFormDataBuilder()
    private let requestBuilder = RequestBuildable()
 }
```

![Screen Shot 2021-09-25 at 5.34.36 PM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20210925173441.png)

이렇게 프로젝트가 설계될 경우 OpenMarketDataManager는 각 각의 모듈 프로퍼티에 강한 의존성을 가지게 됩니다. 이 상황은 각 각의 모듈을 독립적으로 테스트하기가 불가능 해지고 객체간의 강한 결합을 가지게 된다는 문제가 생기게 됩니다.



이 문제를 해결하기 위해 저는 의존관계 역전 원칙에 따라 의존관계를 역전시켜보았습니다.

의존관계 역전 원칙은 다음과 같은 내용을 담고 있습니다.

>상위 모듈은 하위 모듈에 의존해서는 안된다. 상위 모듈과 하위 모듈 모두 추상화에 의존해야 한다.
>
>추상화는 세부 사항에 의존해서는 안된다. 세부사항이 추상화에 의존해야 한다.

각 모듈을 추상화 하기 위해서 모듈에 해당되는 프로토콜을 정의해줌으로서 각 모듈이 맡아야 할 책임을 정의 해 주었습니다.

```swift
protocol Networkable: AnyObject {    
    func load(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, NetworkResponseError?) -> ())
    
    func cancel()
}

protocol DataParsible {
    func decodeData<T: Decodable>(_ data: Data, completion: @escaping (_ result: Result<T, DataError>) -> Void)
    func encodeToJSON<T: Encodable> (data: T) -> Result<Data, DataError>
}

protocol MultipartFormDataBuildable {
    func buildMultipartFormData(_ texts: [String: Any?], _ imageList: [UIImage]?, boundary: String) -> Data
    func generateBoundary() -> String
}

등등
```

해당 프로토콜을 모듈들이 채택하게 하여 제어의 주체를 모듈(세부사항) 에서 프로토콜(추상화)로 반전시킬 수 있었습니다.

또한 **생성자 주입**을 통해 의존성을 외부에서 주입하여 객체간의 결합을 느슨하게 만들 수 있었습니다.

```swift
final class OpenMarketDataManager {
    private let network: Networkable
    private let dataParser: DataParsible?
    private let multipartFormDataBuilder: MultipartFormDataBuildable?
    private let requestBuilder: RequestBuildable
    
    init(network: Networkable, dataParser: DataParsible?, multipartFormDataBuilder: MultipartFormDataBuildable?, requestBuilder: RequestBuildable) {
        self.network = network
        self.dataParser = dataParser
        self.multipartFormDataBuilder = multipartFormDataBuilder
        self.requestBuilder = requestBuilder
    }
}
```

![Screen Shot 2021-09-25 at 5.54.29 PM](https://raw.githubusercontent.com/inwoodev/uploadedImages/uploadedFiles/20210925175435.png)

프로토콜이라는 Interface 통로를 통해 OpenMarketDataManager는 각 각의 모듈과 소통을 할 수 있게 되었고 

**위와 같은 리팩토링 과정을 통해 각 객체들은 테스트에 용이해지고, 재사용성이 올라가며, 결합도를 낮춰 유연성과 확장성이 향상될 수 있었습니다.**

#### [목차로 돌아가기](#오픈-마켓-프로젝트)
---

# 6. Trouble Shooting

Trouble Shooting 만큼 개발자에게 있어서 짜릿한 경험은 없는 것 같습니다.

문제를 해결했을 때의 그 희열감은 말로 표현할 수 없을만큼 기쁩니다.

하지만 troubleShooting이 단순히 짜릿한 감정에 지나지 않는다면 한층 더 성장할 기회를 잃게 됩니다.

**경험을 자세하게 기록하여 추후에 비슷한 문제를 맞닥드렸을 때 똑같은 실수를 반복하지 않아야만** 성장할 수 있습니다.

제가 겪은 문제와 문제 해결방법을 정리 해 보았고 해당 자료는 아래 제 블로그에서 확인하실 수 있습니다.

[alertController가 곂치는 문제 해결](https://velog.io/@inwoodev/June-22-2021-TIL-Today-I-Learned-present-modally-TroubleShooting)

[log를 통한 multipart/form-data 문제 해결](https://velog.io/@inwoodev/June-23-2021-TIL-Today-I-Learned-로그를-찍어야-하는-이유)

[collectionView의 autolayout 문제 해결](https://velog.io/@inwoodev/Aug-25-2021-TIL-Today-I-Learned-이미지-전환과-UIPageControl)

[네트워크 응답을 받지 못하는 문제 해결](https://velog.io/@inwoodev/Sept-15-2021-TIL-Today-I-Learned-HTTPURLResponse-MIMEType-TroubleShooting)

[캐시처리가 안되는 문제 해결](https://velog.io/@inwoodev/Sept-26-2021-TIL-Today-I-Learned-Computed-Property-Extension-캐시처리가-안되는-문제-TroubleShooting)

#### [목차로 돌아가기](#오픈-마켓-프로젝트)
---
