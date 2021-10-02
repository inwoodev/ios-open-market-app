//
//  OpenMarketMultipartFormDataStorageTests.swift
//  OpenMarketNetworkTests
//
//  Created by 황인우 on 2021/10/02.
//

import XCTest
@testable import OpenMarket

class OpenMarketMultipartFormDataStorageTests: XCTestCase {
    var sut_multipart_form_datastorage: OpenMarketMultipartFormDataStorage!
    var mock_data_manager: OpenMarketDataManageable!
    
    let stub_multipartform_post_texts: [String: Any?] = {
        var texts = [String: Any?]()
        texts.updateValue("stub_title", forKey: OpenMarketItemToPostOrPatch.title.key)
        texts.updateValue("KRW", forKey: OpenMarketItemToPostOrPatch.currency.key)
        texts.updateValue(123123, forKey: OpenMarketItemToPostOrPatch.price.key)
        texts.updateValue(12312, forKey: OpenMarketItemToPostOrPatch.discountedPrice.key)
        texts.updateValue(2, forKey: OpenMarketItemToPostOrPatch.stock.key)
        texts.updateValue("qwe123", forKey: OpenMarketItemToPostOrPatch.password.key)
        texts.updateValue("stub_description", forKey: OpenMarketItemToPostOrPatch.descriptions.key)
        return texts
    }()
    
    let stub_multipartform_images: [UIImage] = {
        guard let pencilImage = UIImage(named: "pencil"),
              let folderImage = UIImage(named: "folder") else {
                  return [UIImage()]
                  
              }
        return [pencilImage, folderImage]
    }()
    
    override func setUpWithError() throws {
        let mock_urlsession = MockURLSession()
        let multipartFormDataBuilder = MultipartFormDataBuilder(multipartFormDataConverter: MultipartFormDataConverter())
        
        mock_data_manager = MockOpenMarketDataManager(network: Network(urlSession: mock_urlsession, dataTask: MockURLSessionDataTask()), dataParser: nil, multipartFormDataBuilder: multipartFormDataBuilder, requestBuilder: RequestBuilder())
        sut_multipart_form_datastorage = OpenMarketMultipartFormDataStorage(dataManager: mock_data_manager)
    }

    override func tearDownWithError() throws {
        mock_data_manager = nil
        sut_multipart_form_datastorage = nil
    }

    func test_check_valid_multipart_form_data() {
        
        // given
        var itemInformationStorage = sut_multipart_form_datastorage.accessItemInformation()

        // when
        itemInformationStorage = stub_multipartform_post_texts
        
        // then
        XCTAssertEqual(itemInformationStorage[OpenMarketItemToPostOrPatch.title.key] as? String, stub_multipartform_post_texts[OpenMarketItemToPostOrPatch.title.key] as? String)
        
        
    }

    func test_validity_of_currency_list() {
        // given
        let firstCurrencyElement = 0
        let secondCurrencyElement = 1
        let currencyList = sut_multipart_form_datastorage.accessCurrencyList()
        
        // when
        let krw = sut_multipart_form_datastorage.getCurrency(at: firstCurrencyElement)
        let usd = sut_multipart_form_datastorage.getCurrency(at: secondCurrencyElement)
        
        // then
        XCTAssertEqual(currencyList.first, krw)
        XCTAssertEqual(currencyList.first?.description, "KRW")
        XCTAssertEqual(currencyList[secondCurrencyElement], usd)
        XCTAssertEqual(currencyList[secondCurrencyElement].description, "USD")
    }
    
    func test_add_image_to_image_list() {
        
        // given
        let dummy_image = UIImage()
        
        // when
        sut_multipart_form_datastorage.addImages([dummy_image])
        
        // then
        XCTAssertEqual(sut_multipart_form_datastorage.accessItemImages().count, 1)
    }
    
    func test_remove_image_from_image_list() {
        
        // given
        let dummy_image = UIImage()
        sut_multipart_form_datastorage.addImages([dummy_image])
        
        // when
        sut_multipart_form_datastorage.removeImage(at: 0)
        
        // then
        XCTAssertEqual(sut_multipart_form_datastorage.accessItemImages().count, 0)
    }
    
    func test_post_item_successfully_with_response_status_code_200() {
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut_multipart_form_datastorage.postOpenMarketItem { response in
            
            // then
            XCTAssertEqual(response.statusCode, 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_patch_item_successfully_with_response_status_code_200() {
        // given
        let expectation = XCTestExpectation()
        let dummy_item_id = 1
        
        // when
        sut_multipart_form_datastorage.patchOpenMarketItem(id: dummy_item_id) { response in
            
            // then
            XCTAssertEqual(response.statusCode, 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
}
