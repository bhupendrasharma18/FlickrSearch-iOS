//
//  ImageCell.swift
//  FlickrSearch
//
//  Created by Bhupendra Sharma on 22/05/20.
//  Copyright © 2020 Bhupendra. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    func configureCell(photo: PhotoModel?) {
        imgView.image = nil
        guard let model = photo, let urlStr = model.urlString else { return }
        ImageDownloader.sharedManger.downloadImage(urlStr: urlStr, imgView: imgView)
//        if let url = URL.init(string: urlStr) {
//            DispatchQueue.global().async {
//                if let data = try? Data.init(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.imgView.image = UIImage.init(data: data)
//                    }
//                }
//            }
//        }
    }

}
