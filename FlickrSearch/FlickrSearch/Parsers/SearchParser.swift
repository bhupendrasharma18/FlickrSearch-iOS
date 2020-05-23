//
//  SearchParser.swift
//  FlickrSearch
//
//  Created by Bhupendra Sharma on 22/05/20.
//  Copyright © 2020 Bhupendra. All rights reserved.
//

import Foundation
import UIKit

class SearchParser {
    static func parseSearch(json: Any?) -> SearchModel? {
        if let dict = json as? [String : Any], let searched = dict["photos"] as? [String : Any] {
            var searchModel = SearchModel()
            searchModel.page = searched["page"] as? Int
            searchModel.pages = searched["pages"] as? Int
            searchModel.perPage = searched["perpage"] as? Int
            searchModel.total = searched["total"] as? Int
            searchModel.photos = parsePhotos(photos: searched["photo"] as? [AnyObject])
        }
        
        return nil
    }
    
    static func parsePhotos(photos: [AnyObject]?) -> [PhotoModel]? {
        guard let arr = photos, arr.count > 0 else { return nil }
        var arrPhotos: [PhotoModel] = .init()
        for dict in arr {
            guard let obj = dict as? [String : Any] else { continue }
            var photoModel = PhotoModel()
            photoModel.id = obj["id"] as? Int
            photoModel.title = obj["id"] as? String
            photoModel.urlString = obj["url_s"] as? String
            photoModel.width = obj["width_s"] as? CGFloat
            photoModel.height = obj["height_s"] as? CGFloat
            arrPhotos.append(photoModel)
        }
        return arrPhotos
    }
}
