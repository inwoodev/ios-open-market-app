//
//  ImageLoadingTests.swift
//  OpenMarketNetworkTests
//
//  Created by 황인우 on 2021/09/28.
//

import XCTest
@testable import OpenMarket
class ImageLoadingTests: XCTestCase {
    var sut_cached_image_loader: CachedImageLoadable!
    var mock_image_downloader: MockImageDownloader!
    var image_cache: ImageCache<NSString, UIImage>!
    var mock_network: Networkable!
    var mock_urlsession: MockURLSession!
    var mock_data_task: MockURLSessionDataTask!
    var stub_url_link = "www.dummy.com"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // given
        mock_data_task = MockURLSessionDataTask()
        mock_urlsession = MockURLSession()
        mock_network = Network(urlSession: mock_urlsession, dataTask: mock_data_task)
        mock_image_downloader = MockImageDownloader(network: mock_network)
        sut_cached_image_loader = CachedImageLoader(imageDownloader: mock_image_downloader)
        image_cache = CacheManager.cache
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mock_data_task = nil
        mock_urlsession = nil
        mock_network = nil
        mock_image_downloader = nil
        sut_cached_image_loader = nil
        CacheManager.cache.removeAllObjects()
    }

    func test_did_image_successfully_load() {
        
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut_cached_image_loader.loadImageWithCache(with: stub_url_link) { image in
            
            // then
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_was_image_successfully_stored_in_cache() {
        
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut_cached_image_loader.loadImageWithCache(with: stub_url_link) { image in
            
            // then
            XCTAssertEqual(self.image_cache[self.stub_url_link as NSString], image)
        }
        
        // when
        sut_cached_image_loader.loadImageWithCache(with: stub_url_link) { image in
            
            // then
            XCTAssertEqual(image, self.image_cache[self.stub_url_link as NSString])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_did_image_loading_canceled() {
        
        // given
        var didLoadingCanceled: Bool = false
        
        mock_image_downloader.cancelDownloadingDidCall = {
            didLoadingCanceled = true
            
            // then
            XCTAssertTrue(didLoadingCanceled)
            
        }
        
        // when
        sut_cached_image_loader.cancelLoading()
        
        
    }
}
