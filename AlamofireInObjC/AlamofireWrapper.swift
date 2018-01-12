//
//  AlamofireWrapper.swift
//  Alamofire
//
//  Created by Catalina Turlea on 2/4/16.
//  Copyright © 2016 Alamofire. All rights reserved.
//

import Foundation
import Alamofire

@objc public enum RequestMethod: NSInteger {
    case OPTIONS = 0, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

@objc public enum RequestParameterEncoding: NSInteger {
    case URL, URLEncodedInURL, JSON
}

@objc class BodyPart: NSObject {
    var data: NSData
    var name: String
    var fileName: String?
    var mimeType: String?
    
    init(data: NSData, name: String) {
        self.data = data
        self.name = name
        super.init()
    }
}

@objc public class AlamofireWrapper: NSObject {
    
    // MARK: - Request Methods
    
    /**
    Creates a request using the shared manager instance for the specified method, URL string, parameters, and
    parameter encoding.
    
    - parameter method:     The HTTP method.
    - parameter URLString:  The URL string.
    - parameter parameters: The parameters. `nil` by default.
    - parameter encoding:   The parameter encoding. `.URL` by default.
    - parameter headers:    The HTTP headers. `nil` by default.
    - parameter success:    Block to be called in case of successful execution of the request.
    - parameter failure:    Block to be called in case of errors during the execution of the request.
    */
    
   @objc public static func request(
        method: RequestMethod,
        URLString: String,
        parameters: [String: NSObject]? = nil,
        encoding: RequestParameterEncoding = .URL,
        headers: [String: String]?,
        success: @escaping (_ request: URLRequest, _ response: HTTPURLResponse, _ json: Any) -> (),
        failure: @escaping (_ request: URLRequest, _ response: HTTPURLResponse, _ error: Error) -> ()) {
        
        let method = translateMethod(method: method)
        let encoding = translateEncoding(encoding: encoding)
        
        Alamofire.request(URLString, method: method, parameters: parameters, encoding: encoding, headers: headers)
        let request = Alamofire.request(URLString,method: method, parameters: parameters, encoding: encoding, headers: headers)
        request.responseJSON { (response) -> Void in
           // parseResponse(response, success: success, failure: failure)
            if let error = response.error{
            
                failure(response.request!, response.response!, error)
            }else{

                success(response.request!, response.response!, response.result.value!)
            }
        }
    }
    
    // MARK: - Upload Methods
    
    // MARK: MultipartFormData
    
    /**
    Creates an upload request using the shared manager instance for the specified method and URL string.
    
    - parameter method:                  The HTTP method.
    - parameter URLString:               The URL string.
    - parameter headers:                 The HTTP headers. `nil` by default.
    - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
    - parameter success:                 Block to be called in case of successful execution of the request.
    - parameter failure:                 Block to be called in case of errors during the execution of the request.
    */
//    public class func upload(
//        method: RequestMethod,
//        _ URLString: String,
//        headers: [String: String]? = nil,
//        multipartFormData: (() -> [BodyPart]),
//        success: ((_ request: URLRequest?, _  response: HTTPURLResponse?, _ json: [NSObject: AnyObject]?) -> ()),
//        failure: ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ error: NSError?) -> ())) {
//        let method = translateMethod(method: method)
//
//            Manager.sharedInstance.upload(method, URLString, headers: headers, multipartFormData: { (formData) -> Void in
//                let bodyParts = multipartFormData()
//                for part in bodyParts {
//                    if let fileName = part.fileName, let mimeType = part.mimeType {
//                        formData.appendBodyPart(data: part.data, name: part.name, fileName: fileName, mimeType: mimeType)
//                    } else {
//                        formData.appendBodyPart(data: part.data, name: part.name)
//                    }
//
//                }
//
//                }) { (result) -> Void in
//                    switch result {
//                    case .Success(let uploadRequest, _, _):
//                        uploadRequest.responseData({ (response) -> Void in
//                            parseResponse(response, success: success, failure: failure)
//                        })
//                    case .Failure(_):
//                        failure(request: nil, response: nil, error: NSError(domain: "Encoding error", code: 0, userInfo: nil))
//                    }
//            }
//    }
    
//    public class func downloadFileWithProgress(
//        address: String,
////        progressBlock: ((_ progress: Float) -> ()),
////        destination: String,
////        success: ((_ request: NSURLRequest?, _ response: HTTPURLResponse?, _ json: [NSObject: AnyObject]?) -> ()),
////        failure: ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ error: NSError?) -> ())) {
////
////
////        let request = Manager.sharedInstance.download(.GET, address) { (_, _) -> NSURL in
////            return NSURL.fileURLWithPath(destination, isDirectory: true)
////            }.progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
////                let progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
////                progressBlock(progress: progress)
////        }
////        
////        request.responseData { (response) -> Void in
////            parseResponse(response, success: success, failure: failure)
////        }
////    }

    
    private class func translateMethod(method: RequestMethod) -> HTTPMethod {
        switch(method) {
        case .GET:
            return .get
        case .POST:
            return .post
        case .DELETE:
            return .delete
        case .HEAD:
            return .head
        case .PUT:
            return .put
        case .PATCH:
            return .patch
        case .TRACE:
            return .trace
        case .CONNECT:
            return .connect
        case .OPTIONS:
            return .options
        }
    }
    
    private class func translateEncoding(encoding: RequestParameterEncoding) -> ParameterEncoding {
        switch (encoding) {
        case .JSON:
            return JSONEncoding.default
        case .URLEncodedInURL:
            return URLEncoding.default
        case .URL:
            return URLEncoding.httpBody
        }
    }
    
//    private class func parseResponse(response: Response<NSData, NSError>, success: (_ request: URLRequest?, _ response: HTTPURLResponse?, _ json: [NSObject: AnyObject]?) -> (),
//                                     failure: (_ request: NSURLRequest?, _ response: HTTPURLResponse?, _ error: NSError?) -> ()) {
//            switch (response.result) {
//            case .Success(let data):
//                if let json = try? JSONSerializationJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments), let parsed = json as? [NSObject: AnyObject] {
//                    success(request: response.request, response: response.response, json: parsed)
//                } else {
//                    success(request: response.request, response: response.response, json: [NSObject: AnyObject]())
//                }
//            case .Failure(let error):
//                failure(request: response.request, response: response.response, error: error)
//            }
//    }
    
//    private class func parseResponse(response: Response<AnyObject, NSError>, success: (_ request: NSURLRequest?, _ response: HTTPURLResponse?,_  json: [NSObject: AnyObject]?) -> (),
//                                     failure: (_ request: NSURLRequest?, _ response: HTTPURLResponse?, _ error: NSError?) -> ()) {
//            switch (response.result) {
//            case .Success(let json):
//                if let json = json as? [NSObject: AnyObject] {
//                    success(request: response.request, response: response.response, json: json)
//                } else {
//                    success(request: response.request, response: response.response, json: [NSObject: AnyObject]())
//                }
//            case .Failure(let error):
//                failure(request: response.request, response: response.response, error: error)
//            }
//    }
}


