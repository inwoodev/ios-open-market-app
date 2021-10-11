//
//  MultipartFormBuildTests.swift
//  OpenMarketNetworkTests
//
//  Created by 황인우 on 2021/09/28.
//

import XCTest
@testable import OpenMarket
class MultipartFormBuildTests: XCTestCase {
    var sut_multipart_form_data_builder: MockMultipartFormDataBuilder!
    var spy_multipart_form_data_builder: SpyMultipartFormDataBuilder!
    var stub_texts: [String: Any?]!
    var stub_imageList: [UIImage]!
    let dummy_boundary = "boundary"

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // given
        spy_multipart_form_data_builder = SpyMultipartFormDataBuilder()
        sut_multipart_form_data_builder = MockMultipartFormDataBuilder(spy: spy_multipart_form_data_builder)
        stub_texts = ["itemTitle" : "stubName",
                      "itemNumber" : 1,
                      "itemQuantity" : 3,
                      "itemPrice" : 2300,
                      "itemDiscountedPrice" : 2100,
                      "itemDescription" : "stubDescription"]
        let trashImage = UIImage(systemName: "trash")!
        let pencilImage = UIImage(systemName: "pencil")!
        stub_imageList = [trashImage, pencilImage]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_multipart_form_data_builder = nil
        stub_texts = nil
        stub_imageList = nil
    }

    func test_correct_number_of_text_files_built_by_multipart_form_data_builder() {
        _ = sut_multipart_form_data_builder.buildMultipartFormData(stub_texts, nil, boundary: dummy_boundary)
        XCTAssertEqual(sut_multipart_form_data_builder.spy.numberOfTextFileInFormData, stub_texts.count)
        
    }
    
    func test_correct_number_of_image_files_built_by_multipart_form_data_builder() {
        _ = sut_multipart_form_data_builder.buildMultipartFormData(stub_texts, stub_imageList, boundary: dummy_boundary)
        XCTAssertEqual(sut_multipart_form_data_builder.spy.numberOfImageFileInFormData, stub_imageList.count)
    }
    
    func test_only_once_is_build_method_called() {
        _ = sut_multipart_form_data_builder.buildMultipartFormData(stub_texts, stub_imageList, boundary: dummy_boundary)
        XCTAssertEqual(sut_multipart_form_data_builder.spy.numberOfMethodDidCall, 1)
    }

}
