//
//  SearchModel.swift
//  FlickrSearch
//
//  Created by Bhupendra Sharma on 22/05/20.
//  Copyright © 2020 Bhupendra. All rights reserved.
//

import Foundation

struct SearchModel {
    var page: Int?
    var pages: Int?
    var perPage: Int?
    var total: Int?
    var photos: [PhotoModel]?
}
