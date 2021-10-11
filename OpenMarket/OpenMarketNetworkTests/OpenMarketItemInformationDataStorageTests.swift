//
//  OpenMarketItemInformationDataStorageTests.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/10/02.
//

import XCTest
@testable import OpenMarket
class OpenMarketItemInformationDataStorageTests: XCTestCase {
    var sut_item_information_datastorage: OpenMarketItemInformationDataStorage!
    var mock_data_manager: OpenMarketDataManageable!
    var mock_cached_image_loader: CachedImageLoadable!
    var mock_network: Networkable!
    var mock_urlsession: URLSessionProtocol!
    let dummy_item_id = 1
    let dummy_password = "qwe123"
    
    override func setUpWithError() throws {
        
        // given
        mock_urlsession = MockURLSession(buildRequestFail: false, isImageOnly: false)
        mock_network = Network(urlSession: mock_urlsession, dataTask: MockURLSessionDataTask())
        
        let multipartFormBuilder = MultipartFormDataBuilder(multipartFormDataConverter: MultipartFormDataConverter())
        
        let mock_urlsession_for_image = MockURLSession(buildRequestFail: false, isImageOnly: true)
        let mock_network_for_image = Network(urlSession: mock_urlsession_for_image, dataTask: MockURLSessionDataTask())
        
        let imageDownloader = MockImageDownloader(network: mock_network_for_image)
        
        mock_cached_image_loader = MockCachedImageLoader(mock_image_downloader: imageDownloader)
        
        mock_data_manager = MockOpenMarketDataManager(network: mock_network, dataParser: DataParser(), multipartFormDataBuilder: multipartFormBuilder, requestBuilder: RequestBuilder())
        sut_item_information_datastorage = OpenMarketItemInformationDataStorage(dataManager: mock_data_manager, cachedImageLoader: mock_cached_image_loader)
    }

    override func tearDownWithError() throws {
        sut_item_information_datastorage = nil
        mock_data_manager = nil
        mock_cached_image_loader = nil
        mock_network = nil
    }

    func test_insert_open_market_information() {
        
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut_item_information_datastorage.insertOpenMarketItemInformation(id: 1) { item in
            
            guard let insertedItem = self.sut_item_information_datastorage.accessItemInformation() else { return }
            
            // then
            XCTAssertNotNil(insertedItem)
            XCTAssertEqual(item.id, insertedItem.id)
            XCTAssertEqual(item.title, item.title)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_downloadImages_from_given_item_information() {
        
        // given
        let expectation = XCTestExpectation()
        let emptyImageList = sut_item_information_datastorage.accessSliderImages()
        XCTAssertEqual(emptyImageList.count, 0)
        
        sut_item_information_datastorage.insertOpenMarketItemInformation(id: dummy_item_id) { items in
            
            // when
            self.sut_item_information_datastorage.downloadImages { images in
                let imageListAfterDownload = self.sut_item_information_datastorage.accessSliderImages()
                XCTAssertEqual(images, imageListAfterDownload)
                expectation.fulfill()
            }
            self.wait(for: [expectation], timeout: 1)
        }
    }
    
    func test_proceed_to_patch_item() {
        
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut_item_information_datastorage.proceedToPatchOpenMarketItem(id: dummy_item_id, password: dummy_password) { response in
            
            XCTAssertEqual(response.statusCode, 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_delete_item() {
        
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut_item_information_datastorage.deleteOpenMarketItem(id: dummy_item_id, password: dummy_password) { response in
            
            XCTAssertEqual(response.statusCode, 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
