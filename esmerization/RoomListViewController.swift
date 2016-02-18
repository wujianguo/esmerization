//
//  RoomListViewController.swift
//  esmerization
//
//  Created by 吴建国 on 16/2/18.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class RoomCollectionCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        smallImage.layer.cornerRadius = smallImage.frame.width / 2
        smallImage.layer.masksToBounds = true
    }
    
    
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var onlineUsersLabel: UILabel!
    
    var room: Room! {
        didSet {
            updateUI()
        }
    }
    
    var task: RetrieveImageTask?
    
    func updateUI() {
        nameLabel.text = room.anchor?.nick
        cityLabel.text = room.city
        onlineUsersLabel.text = "\(room.onlineUsers)在看"
        
        let url = NSURL(string:room.anchor!.portrait!)
        guard url != nil else { return }
        if task?.downloadTask?.URL != url {
            smallImage.kf_cancelDownloadTask()
        }
        smallImage.image = nil
        task = bigImage.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
            self.smallImage.image = image
        }
    }
}

class RoomListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "湾视"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView?.backgroundColor = UIColor.clearColor()
        requestMore()
    }
    
    var rooms = [Room]()
    
    func requestMore() {
        requestRoomList { (rms) -> Void in
            self.rooms.appendContentsOf(rms)
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        let flowLayout = collectionView?.collectionViewLayout
        flowLayout?.invalidateLayout()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RoomListCellIdentifier", forIndexPath: indexPath) as! RoomCollectionCell
        cell.room = rooms[indexPath.row]
        return cell
    }
    
    
    struct CellRatio {
        static let x = CGFloat(320)
        static let y = CGFloat(390)
    }
    
    let mininumInteritemSpacing = CGFloat(8)
    
    var collectionViewEdgeInset = UIEdgeInsetsMake(8, 0, 8, 0)
    
    func calculateCellNum(size: CGSize) -> Int {
        let width = size.width - collectionViewEdgeInset.left - collectionViewEdgeInset.right + mininumInteritemSpacing
        let num = width / (CellRatio.x + mininumInteritemSpacing)
        let actXNum = num - CGFloat(Int(num)) >= 0.7 ? Int(num) + 1 : Int(num)
        return actXNum > 0 ? actXNum : 1
    }
    
    var collectionCellWidth: CGFloat {
        let bounds = collectionView!.bounds
        let width = bounds.width - collectionViewEdgeInset.left - collectionViewEdgeInset.right + mininumInteritemSpacing
        let n = calculateCellNum(bounds.size)
        return width/CGFloat(n) - mininumInteritemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionCellWidth
        return CGSizeMake(width, width*CellRatio.y/CellRatio.x)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return mininumInteritemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return collectionViewEdgeInset
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? RoomViewController {
            if let cell = sender as? RoomCollectionCell {
                if let indexPath = collectionView.indexPathForCell(cell) {
                    dvc.room = rooms[indexPath.row]
                }
            }
        }
    }
    
    
}
