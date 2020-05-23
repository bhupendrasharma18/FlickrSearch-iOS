//
//  NetworkRequest.swift
//  FlickrSearch
//
//  Created by Bhupendra Sharma on 23/05/20.
//  Copyright © 2020 Bhupendra. All rights reserved.
//

import UIKit

class NetworkRequest: NSObject {
    static func makeRequest(url: URL!, success: @escaping ((_ response: Any?) -> Void), failure: @escaping (_ error: Error?) -> Void) {
        let session = URLSession.init(configuration: .default)
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let imagesData = data {
                if let json = try? JSONSerialization.jsonObject(with: imagesData, options: .allowFragments) {
                    print(json)
                    success(json)
                }
            }
        }
        task.resume()
    }
}
