//
//  OpenMarketListDataStorageTests.swift
//  OpenMarketNetworkTests
//
//  Created by 황인우 on 2021/10/02.
//

import XCTest
@testable import OpenMarket
class OpenMarketListDataStorageTests: XCTestCase {
    var sut_list_data_storage: OpenMarketListDataStorage!
    var mock_data_manager: OpenMarketDataManageable!
    
    let dummy_page_number = 1
    
    override func setUpWithError() throws {
        mock_data_manager = MockOpenMarketDataManager(network: Network(urlSession: MockURLSession(), dataTask: MockURLSessionDataTask()), dataParser: DataParser(), multipartFormDataBuilder: MultipartFormDataBuilder(multipartFormDataConverter: MultipartFormDataConverter()), requestBuilder: RequestBuilder())
        sut_list_data_storage = OpenMarketListDataStorage(dataManager: mock_data_manager)
    }

    override func tearDownWithError() throws {
        mock_data_manager = nil
        sut_list_data_storage = nil
    }

    func test_insert_data_to_datastorage() {
        
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut_list_data_storage.insertOpenMarketItemList(page: dummy_page_number) { items, startItemCount, totalItemCount in
            
            // then
            XCTAssertEqual(startItemCount, 0)
            XCTAssertEqual(totalItemCount, 3)
            XCTAssertEqual(items.count, 3)
            XCTAssertEqual(self.sut_list_data_storage.accessOpenMarketItemList().count, items.count)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_access_item_list() {
        
        // given
        let expectation = XCTestExpectation()
        sut_list_data_storage.insertOpenMarketItemList(page: 1) { itemsToInsert, startItemCount, totalItemCount in
            
            // when
            let insertedItems = self.sut_list_data_storage.accessOpenMarketItemList()
            
            // then
            XCTAssertEqual(insertedItems.count, itemsToInsert.count)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_access_item_at_first_element_and_verify_the_element() {
        
        // given
        let expectation = XCTestExpectation()
        sut_list_data_storage.insertOpenMarketItemList(page: 1) { itemsToInsert, startItemCount, totalItemCount in
            
            // when
            let accessedItemAtFirstIndex = self.sut_list_data_storage.accessItem(at: 0)
            
            // then
            XCTAssertEqual(accessedItemAtFirstIndex.id, itemsToInsert[0].id)
            XCTAssertEqual(accessedItemAtFirstIndex.title, itemsToInsert[0].title)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_remove_all_items() {
        
        // given
        let expectation = XCTestExpectation()
        sut_list_data_storage.insertOpenMarketItemList(page: 1) { itemsToInsert, startItemCount, totalItemCount in
            let storageBeforeRemoval = self.sut_list_data_storage.accessOpenMarketItemList()
            XCTAssertEqual(storageBeforeRemoval.count, 3)
            
            // when
            self.sut_list_data_storage.removeAllOpenMarketItemList()
            
            // then
            let storageAfterRemoval = self.sut_list_data_storage.accessOpenMarketItemList()
            XCTAssertEqual(storageAfterRemoval.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
