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
    var isFetching: Bool = false
    var searchedRecently: String = ""
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? GridLayout {
            layout.delegate = self
            layout.set(columns: 3, cellPadding: 5)
        }
        collectionView.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    private func requestSearch(text: String?) {
        isFetching = true
        guard let keyword = text, keyword.count > 0 else { return }
        if keyword == searchedRecently {
            currentPage += 1
        }
        else {
            currentPage = 1
        }
        let request = SearchRequest()
        request.makeSearchRequest(keyword: keyword, pageNo: currentPage ) { (model: SearchModel?, error: Error?) in
            DispatchQueue.main.async {
                if self.searchModel?.photos != nil && self.currentPage > 1 {
                    self.searchModel?.photos?.append(contentsOf: model?.photos ?? [])
                }
                else {
                    self.searchModel = model
                    self.searchedRecently = keyword
                }
                self.collectionView.reloadData()
                self.isFetching = false
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchModel?.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ImageCell
        guard let arr = searchModel?.photos, indexPath.item < arr.count else {
            return cell
        }
        cell.configureCell(photo: arr[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let arr = searchModel?.photos else { return }
        if indexPath.item >= arr.count - 1 && !isFetching  {
            print("Fetch data for next page")
            requestSearch(text: searchedRecently)
        }
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
