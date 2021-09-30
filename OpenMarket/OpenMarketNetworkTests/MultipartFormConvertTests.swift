//
//  MultipartFormConvertTests.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/09/27.
//

import XCTest
@testable import OpenMarket
class MultipartFormConvertTests: XCTestCase {
    var sut_multipart_form_converter: MultipartFormDataConvertible!
    var stub_multipart_form_text_model: MultipartFormTextModel!
    var stub_multipart_form_file_model: MultipartFormFileModel!
    let dummy_boundary = "uuid\r\n"
    let dummy_multipartKey = "itemKey"

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // given
        sut_multipart_form_converter = MultipartFormDataConverter()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_multipart_form_converter = nil
        stub_multipart_form_text_model = nil
        stub_multipart_form_file_model = nil
    }

    func test_convertTextField_with_stub() {
        
        // given
        let dummy_multipartValue = "itemValue"
        stub_multipart_form_text_model = MultipartFormTextModel(key: dummy_multipartKey, value: dummy_multipartValue)
        let stub_multipart_form_data_text: String = {
            var fieldString = ""
            fieldString += "--\(dummy_boundary)\r\n"
            fieldString += "Content-Disposition: form-data; name=\"\(dummy_multipartKey)\"\r\n"
            fieldString += "\r\n"
            fieldString += "\(dummy_multipartValue)\r\n"
            return fieldString
        }()
        
        // when
        let multipartFormDataText = sut_multipart_form_converter.convertTextField(textModel: stub_multipart_form_text_model, boundary: dummy_boundary)
        
        // then
        XCTAssertEqual(multipartFormDataText, stub_multipart_form_data_text)
        
    }
    
    func test_convertFileData_with_stub() {
        
        // given
        let dummy_fileName = "fileName"
        let dummy_mimeType = MimeType.jpeg
        let stub_filedata = Data()
        stub_multipart_form_file_model = MultipartFormFileModel(key: dummy_multipartKey, fileName: dummy_fileName, mimeType: dummy_mimeType, fileData: stub_filedata)
        let stub_multipart_form_data_text: Data = {
            let data = NSMutableData()
            data.appendString("--\(dummy_boundary)\r\n")
            data.appendString("Content-Disposition: form-data; name=\"\(stub_multipart_form_file_model.key)\"; filename=\"\(stub_multipart_form_file_model.fileName)\"\r\n")
            data.appendString("Content-Type: \(stub_multipart_form_file_model.mimeType)\r\n\r\n")
            data.append(stub_multipart_form_file_model.fileData)
            data.appendString("\r\n")
            
            return data as Data
        }()
        
        // when
        let multipartFormDataFile = sut_multipart_form_converter.convertFileData(fileModel: stub_multipart_form_file_model, using: dummy_boundary)
        
        // then
        XCTAssertEqual(multipartFormDataFile, stub_multipart_form_data_text)
    }

}
