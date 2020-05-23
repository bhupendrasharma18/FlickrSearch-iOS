//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Bhupendra Sharma on 22/05/20.
//  Copyright © 2020 Bhupendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    let identifier = "ImageCellIdentifier"
    var searchModel: SearchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? GridLayout {
            layout.delegate = self
            layout.set(columns: 3, cellPadding: 5)
        }
        collectionView.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func requestSearch(text: String?) {
        let pageNo = 1
        guard let keyword = text, keyword.count > 0 else { return }
        let request = SearchRequest()
        request.makeSearchRequest(keyword: keyword, pageNo: pageNo ) { (model: SearchModel?, error: Error?) in
            DispatchQueue.main.async {
                self.searchModel = model
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchModel?.photos?.count ?? 0//30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ImageCell
        guard let arr = searchModel?.photos, indexPath.item < arr.count else {
            return cell
        }
        cell.configureCell(photo: arr[indexPath.item])
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        requestSearch(text: searchBar.text)
    }
}

extension ViewController: GridLayoutDelegate {
    func imageAspectRatioAtIndexpath(indexPath: IndexPath) -> CGFloat {
        guard let arr = searchModel?.photos, indexPath.item < arr.count else {
            return 1
        }
        let photo = searchModel?.photos?[indexPath.item]
        return photo?.aspectRatio ?? 1
    }
}
