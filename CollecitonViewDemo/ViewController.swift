//
//  ViewController.swift
//  CollecitonViewDemo
//
//  Created by mac-0005 on 20/07/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var arrUserList : [[String:String]]?
    var selectedIndePath : IndexPath?
    @IBOutlet var collUserList : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collUserList?.collectionViewLayout as? CustomLayout {            
            layout.delegate = self
        }
        
        arrUserList = [["size":"50"],["size":"40"],["size":"30"],["size":"80"],["size":"90"],["size":"60"],["size":"30"],["size":"55"],["size":"75"],["size":"100"],["size":"37"],["size":"67"],["size":"27"],["size":"59"],["size":"42"],["size":"31"],["size":"33"],["size":"80"],["size":"90"],["size":"60"],["size":"30"],["size":"55"],["size":"75"],["size":"100"],["size":"37"],["size":"67"],["size":"27"],["size":"59"],["size":"42"],["size":"31"],["size":"33"],["size":"80"]]
        collUserList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrUserList?.count ?? 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let dic = arrUserList![indexPath.item]
//        let cellHeight = Double(dic["size"]!)
//        return CGSize(width: cellHeight!, height: cellHeight!)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        
        if indexPath.item % 2 == 0{
            cell.backgroundColor = UIColor.red
            cell.imgUser.image = UIImage.init(named: "2.jpg")
        }
        else
        {
            cell.backgroundColor = UIColor.green
            cell.imgUser.image = UIImage.init(named: "1.jpg")
        }
        
        cell.layer.cornerRadius = cell.frame.size.height/2
        
        if selectedIndePath == indexPath{
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 1
            cell.bringSubview(toFront: collUserList)
            
            UIView.animate(withDuration: 0.3) {
                cell.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
            }
            
            
        }else
        {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        
        
        return cell
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collUserList.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndePath == indexPath
        {
            return
        }
        selectedIndePath = indexPath
        collUserList.collectionViewLayout.invalidateLayout()
        collUserList.reloadData()
        
    }
}

//MARK: -  LAYOUT DELEGATE
extension ViewController : CollectionViewCustomLayoutDelegate {
    
    // 1. Returns the cell height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let dic = arrUserList![indexPath.item]
        let cellHeight = Double(dic["size"]!)
        return CGFloat(cellHeight!)
    }
    
    // 1. Returns the cell width
    func collectionView(_ collectionView:UICollectionView, widthForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat{
        let dic = arrUserList![indexPath.item]
        let cellHeight = Double(dic["size"]!)
        return CGFloat(cellHeight!)
    }
    
    func collectionView(_ collectionView:UICollectionView, selectedIndexPath indexPath:IndexPath) -> IndexPath?{
        return selectedIndePath
    }
    
}



