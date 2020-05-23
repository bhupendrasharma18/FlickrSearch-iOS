//
//  GridLayout.swift
//  FlickrSearch
//
//  Created by Bhupendra Sharma on 22/05/20.
//  Copyright © 2020 Bhupendra. All rights reserved.
//

import UIKit

protocol GridLayoutDelegate: AnyObject {
    func imageAspectRatioAtIndexpath(indexPath: IndexPath) -> CGFloat
}

class GridLayout: UICollectionViewLayout {
    weak var delegate: GridLayoutDelegate?
    private var columns = 1
    private var cellPadding: CGFloat = 0
    private var arrAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
//        guard arrAttributes.isEmpty == true, let collectionView = collectionView else {
//            return
//        }
        
        arrAttributes.removeAll()
        guard arrAttributes.isEmpty == true || arrAttributes.isEmpty == false, let collectionView = collectionView else {
            return
        }
        contentHeight = 0
        
        let columnWidth = contentWidth / CGFloat(columns)
        var xOffset: [CGFloat] = []
        for column in 0..<columns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: columns)
      
      
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let ratio = delegate?.imageAspectRatioAtIndexpath(indexPath: indexPath) ?? 1
            let photoHeight = columnWidth / ratio
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
              
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            arrAttributes.append(attributes)
              
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
              
            column = column < (columns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the arrAttributes and look for items in the rect
        for attributes in arrAttributes {
            if attributes.frame.intersects(rect) {
              visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return arrAttributes[indexPath.item]
    }
    
    func set(columns: Int, cellPadding: CGFloat) {
        self.columns = columns
        self.cellPadding = cellPadding
    }
}
