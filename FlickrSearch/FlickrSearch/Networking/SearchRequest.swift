//
//  SearchRequest.swift
//  FlickrSearch
//
//  Created by Bhupendra Sharma on 23/05/20.
//  Copyright © 2020 Bhupendra. All rights reserved.
//

import UIKit

class SearchRequest: NSObject {
    let APIKey = "3264f8a3442962793f611977d2589e03"
    
    func makeSearchRequest(keyword: String, pageNo: Int, completion: @escaping (_ searchModel: SearchModel?, _ error: Error?) -> Void) {
        let urlStr = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(APIKey)&format=json&text=.\(keyword)&nojsoncallback=true&per_page=20&extras=url_s&page=\(pageNo)"
        guard let url = URL.init(string: urlStr) else {
            return
        }
        
        NetworkRequest.makeRequest(url: url, success: { (json: Any?) in
            let model = SearchParser.parseSearch(json: json)
            completion(model, nil)
            
        }) { (error: Error?) in
            completion(nil, error)
        }
    }
}
