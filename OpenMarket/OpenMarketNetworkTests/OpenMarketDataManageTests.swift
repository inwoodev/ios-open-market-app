//
//  OpenMarketDataManageTests.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/09/29.
//

import XCTest
@testable import OpenMarket
class OpenMarketDataManageTests: XCTestCase {
    var sut_open_market_data_manager: OpenMarketDataManager!

    override func setUpWithError() throws {
        
        // given
        let mock_urlsession = MockURLSession()
        let mock_datatask = MockURLSessionDataTask()
        let mock_network = Network(urlSession: mock_urlsession, dataTask: mock_datatask)
        let multipartForm_converter = MultipartFormDataConverter()
        let multipart_form_data_builder = MultipartFormDataBuilder(multipartFormDataConverter: multipartForm_converter)
        let request_builder = RequestBuilder()
        let data_parser = DataParser()
        
        sut_open_market_data_manager = OpenMarketDataManager(network: mock_network, dataParser: data_parser, multipartFormDataBuilder: multipart_form_data_builder, requestBuilder: request_builder)
    }

    override func tearDownWithError() throws {
        sut_open_market_data_manager = nil
    }

    func test_get_openmarket_itemdata_successfully() {
        
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut_open_market_data_manager.getOpenMarketItemModel(serverAPI: .singleItemToGetPatchOrDelete(1)) { (item: OpenMarketItemWithDetailInformation) in
            
            XCTAssertEqual(item.id, 1)
            XCTAssertEqual(item.title, "MacBook Pro")
            XCTAssertEqual(item.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.\n최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.\n외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_post_openmarket_item_successfully() {
        
        // given
        let expectation = XCTestExpectation()
        let stub_texts: [String: Any?] = [OpenMarketItemToPostOrPatch.title.key: "stubItem", OpenMarketItemToPostOrPatch.price.key: 2000, OpenMarketItemToPostOrPatch.currency.key: "USD", OpenMarketItemToPostOrPatch.discountedPrice.key: 1900, OpenMarketItemToPostOrPatch.password.key: "qwe123", OpenMarketItemToPostOrPatch.descriptions.key: "stub description"]
        
        guard let pencilImage = UIImage(systemName: "pencil"),
              let folderImage = UIImage(systemName: "folder") else { return }
        let stub_images = [pencilImage, folderImage]
        
        // when
        sut_open_market_data_manager.postOpenMarketItemData(serverAPI: .singleItemToPost, texts: stub_texts, imageList: stub_images) { response in
            XCTAssertEqual(response.statusCode, 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_patch_openmarket_item_successfully() {
        
        // given
        let expectation = XCTestExpectation()
        let dummy_patchID = 12
        let stub_texts_to_edit: [String: Any?] = [OpenMarketItemToPostOrPatch.password.key: 123123, OpenMarketItemToPostOrPatch.price.key : 4000]
        
        // when
        sut_open_market_data_manager.patchOpenMarketItemData(serverAPI: .singleItemToGetPatchOrDelete(dummy_patchID), texts: stub_texts_to_edit, imageList: nil) { response in
            XCTAssertEqual(response.statusCode, 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_delete_openmarket_item_successfully() {
        
        // given
        let expectation = XCTestExpectation()
        let dummy_deleteID = 1
        let stub_password_to_delete = "qwe123"
        
        // when
        sut_open_market_data_manager.deleteItemData(serverAPI: .singleItemToGetPatchOrDelete(dummy_deleteID), password: stub_password_to_delete) { response in
            XCTAssertEqual(response.statusCode, 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
