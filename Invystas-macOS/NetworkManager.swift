//
//  NetworkManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Cocoa

protocol URLSessionProtocol {
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
      -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    var didResume: Bool { get set }
    func resume()
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void)
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    var didResume: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {}
}

extension URLSession: URLSessionProtocol {
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url.url, completionHandler: completion)
    }

}

protocol NetworkManagerDelegate: AnyObject {
    func networkResponse(_ data: Data?,_ response: URLResponse?,_ error: Error?)
}

final class NetworkManager {
    
    private var session: URLSessionProtocol?
    weak var delegate: NetworkManagerDelegate?
    
    init(_ session: URLSessionProtocol?) {
        self.session = session
    }
    
    init() {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        config.urlCredentialStorage = nil
        config.httpCookieStorage = .none
        config.httpCookieAcceptPolicy = .never
        session = URLSession(configuration: config)
    }
    
    public func call(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session?.dataTaskWithUrl(url, completion: completion).resume()
    }
 
}
