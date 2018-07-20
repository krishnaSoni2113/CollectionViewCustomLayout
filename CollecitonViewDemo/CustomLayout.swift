//
//  CustomLayout.swift
//  CollecitonViewDemo
//
//  Created by mac-0005 on 20/07/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

protocol CollectionViewCustomLayoutDelegate: class {
    // 1. Method to ask the delegate for the height of the image
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
    func collectionView(_ collectionView:UICollectionView, widthForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
    func collectionView(_ collectionView:UICollectionView, selectedIndexPath indexPath:IndexPath) -> IndexPath?
    
}

class CustomLayout: UICollectionViewLayout
{
    //1.  Layout Delegate
    weak var delegate: CollectionViewCustomLayoutDelegate!
    
    //2. Configurable properties
    fileprivate var numberOfColumns = 1
    fileprivate var cellPadding: CGFloat = 0
    fileprivate var cellMaxSize: CGFloat = 100
    
    //3. Array to keep a cache of attributes.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    //4. Content height and size
    fileprivate var contentWidth: CGFloat = 0
    
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare()
    {
        // 1. Only calculate once
//        guard cache.isEmpty == true, let collectionView = collectionView else {
//            return
//        }

        // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        var columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var yOffset = [CGFloat]()
        
        for column in 0 ..< numberOfColumns {
            yOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var xOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // 3. Iterates through the list of items in the first section
        
        var previousCellFrame : CGRect?
        let count = collectionView?.numberOfItems(inSection: 0)
        for item in 0 ..< count!
        {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            var photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath)
            columnWidth = delegate.collectionView(collectionView!, widthForPhotoAtIndexPath: indexPath)
            
            if delegate.collectionView(collectionView!, selectedIndexPath: indexPath) == indexPath
            {
                photoHeight = cellMaxSize
                columnWidth = cellMaxSize
            }
            
            let height = cellPadding * 2 + photoHeight
            var frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            
            if previousCellFrame == nil{
             frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            }else
            {
                let xNew = (previousCellFrame?.origin.x)! + (previousCellFrame?.size.width)!
                frame = CGRect(x: xNew - 10, y: yOffset[column], width: columnWidth, height: height)
             
            }
            
            previousCellFrame = frame
            
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            attributes.zIndex = delegate.collectionView(collectionView!, selectedIndexPath: indexPath) == indexPath ? 1 : 0
            cache.append(attributes)
            
            // 6. Updates the collection view content height
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[column] = xOffset[column] + columnWidth
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
