//
//  DownloadImageTests.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/09/28.
//

import XCTest
@testable import OpenMarket

class DownloadImageTests: XCTestCase {
    var sut_image_downloader: ImageDownloadable!
    var mock_network: Networkable!
    var mock_urlSession: MockURLSession!
    var mock_dataTask: MockURLSessionDataTask!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // given
        mock_dataTask = MockURLSessionDataTask()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mock_dataTask = nil
    }

    func test_download_image_successful() {
        
        // given
        let expectation = XCTestExpectation()
        let dummy_url = "www.dummyURL".createURL()
        mock_urlSession = MockURLSession(buildRequestFail: false, isImageOnly: true)
        mock_network = Network(urlSession: mock_urlSession, dataTask: mock_dataTask)
        sut_image_downloader = ImageDownloader(network: mock_network)
        
        sut_image_downloader.downloadImage(url: dummy_url) { result in
            switch result {
            case .failure(let error):
                NSLog(error.localizedDescription)
            case .success(let image):
                XCTAssertNotNil(image)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
        
    }
    
    func test_download_image_failed() {
        
        // given
        let expectation = XCTestExpectation()
        let dummy_url = "www.dummyURL".createURL()
        mock_urlSession = MockURLSession(buildRequestFail: true)
        mock_network = Network(urlSession: mock_urlSession, dataTask: mock_dataTask)
        sut_image_downloader = ImageDownloader(network: mock_network)
        
        sut_image_downloader.downloadImage(url: dummy_url) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error as? NetworkResponseError, NetworkResponseError.badRequest)
                expectation.fulfill()
            case .success(_):
                NSLog("")
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_download_image_canceled() {
        
        // given
        var didDownloadImageCanceld = false
        mock_urlSession = MockURLSession(buildRequestFail: true)
        mock_network = Network(urlSession: mock_urlSession, dataTask: mock_dataTask)
        sut_image_downloader = ImageDownloader(network: mock_network)
        
        
        mock_dataTask.cancelDidCall = {
            // then
            didDownloadImageCanceld = true
            XCTAssertTrue(didDownloadImageCanceld)
        }
        
        // when
        sut_image_downloader.cancelDownloading()
    }
}
