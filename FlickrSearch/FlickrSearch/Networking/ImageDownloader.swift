//
//  ImageDownloader.swift
//  MyMVVM
//
//  Created by Bhupendra Sharma on 07/04/20.
//  Copyright © 2020 Bhupendra. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    let cache = NSCache<NSString, UIImage>()
    static let sharedManger = ImageDownloader()
    private init() {}
    
    func downloadImage(urlStr: String, imgView: UIImageView) {
        if let url = URL.init(string: urlStr) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = self.cache.object(forKey: urlStr as NSString) {
                    DispatchQueue.main.async {
                        imgView.image = image
                    }
                }
                else {
                    if let data = try? Data.init(contentsOf: url) {
                        DispatchQueue.main.async {
                            if let img = UIImage.init(data: data) {
                                imgView.image = img
                                self.cache.setObject(img, forKey: urlStr as NSString)
                            }
                        }
                    }
                }
            }
        }
    }
}
