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
    var didResume: Bool { get }
    func resume()
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void)
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    var didResume: Bool {
        get {
            return false
        }
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {}
}

extension URLSession: URLSessionProtocol {
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url.url, completionHandler: completion)
    }

}

final class NetworkManager {
    
    private var session: URLSessionProtocol
    
    init(_ session: URLSessionProtocol? = nil) {
        if let session = session {
            self.session = session
        } else {
            let config = URLSessionConfiguration.default
            config.urlCache = nil
            config.urlCredentialStorage = nil
            config.httpCookieStorage = .none
            config.httpCookieAcceptPolicy = .never
            self.session = URLSession(configuration: config)
        }
    }
   
    public func call(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTaskWithUrl(url, completion: completion).resume()
    }
 
}
