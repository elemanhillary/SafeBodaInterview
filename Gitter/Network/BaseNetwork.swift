//
//  BaseNetwork.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation
import Alamofire

typealias HttpSuccess = (_ data: Any, _ statusCode: Int) -> Void
typealias HttpFailure = (_ error: Error) -> Void

struct Messages {
    static let anErrorOccured = "An error occured"
    static let somethingWentWrong = "something went wrong, try again, try again later."
    static let networkOfflineError = "The Internet connection appears to be offline"
}

enum NetworkError: Int {
    case HttpRequestFailed = -1000, UrlResourceFailed = -2000
}

class BaseNetwork {
    static let shared = BaseNetwork()

    private let baseURL = "https://api.github.com"
    let NetWorkDomain: String = "eleman.gitter"

    static let reachabilityManager = { () -> NetworkReachabilityManager in
        let manager = NetworkReachabilityManager.init()
        return manager!
    }()

    static let sessionManager = {() -> Session in
        var manager = Session.default
        return manager
    }()
    
    static let authSessionManager = {() -> Session in
        var manager = Session.default
        return manager
    }()
    
    static let cancelRequest: () = {() -> () in
        sessionManager.session.getTasksWithCompletionHandler { (data, upload, download) in
            data.forEach { $0.cancel() }
            upload.forEach { $0.cancel() }
            download.forEach { $0.cancel() }
        }
    }()

    func processData(data: Any, statusCode: Int, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        if (data as AnyObject).count > 0 {
            success(data, statusCode)
        } else {
            let message: String = Messages.anErrorOccured
            let error = NSError.init(domain: NetWorkDomain, code: NetworkError.HttpRequestFailed.rawValue, userInfo: [NSLocalizedDescriptionKey: message])
            failure(error)
        }
    }

    func getRequest(urlPath: String, headers: HTTPHeaders?, request: BaseRequest, encoding: ParameterEncoding, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let baseUrl = baseURL + urlPath
        let parameters = request.toJSON()
        BaseNetwork.sessionManager.request(baseUrl, method: HTTPMethod.get, parameters: parameters ?? nil, encoding: encoding)
            .validate(statusCode: 200..<500)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                print("REQUEST", response.request)
                switch response.result {
                case .success:
                    if let data: [String: Any] = response.value as? [String: Any] {
                        self.processData(data: data, statusCode: response.response?.statusCode ?? 400, success: success, failure: failure)
                    } else {
                        let data: [Any] = response.value as! [Any]
                        self.processData(data: data, statusCode: response.response?.statusCode ?? 400, success: success, failure: failure)
                    }
                    break
                case .failure(let error):
                    let err: NSError = error as NSError
                    if NetworkReachabilityManager.init()?.status == .notReachable {
                        failure(err)
                        return
                    } else {
                        failure(err)
                    }
                    break
                }
            }
        )
    }
}
