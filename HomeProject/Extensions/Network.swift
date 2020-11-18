//
//  Network.swift
//  HomeProject
//
//  Created by Viresh Kumar Sharma on 2020-11-17.
//

import Foundation

// MARK: - Network Extension for download json
extension URL {
func asyncDownload(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
    URLSession.shared.dataTask(with: self, completionHandler: completion)
    .resume()
}
}
