//
//  RoomViewController.swift
//  esmerization
//
//  Created by 吴建国 on 16/2/18.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


class RoomViewController: UIViewController, VLCMediaPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .Light)
        blurView = UIVisualEffectView(effect: blurEffect)
        playerView.addSubview(blurView!)
        blurView?.snp_makeConstraints { make in
            make.edges.equalTo(playerView)
        }
        indicatorView = UIActivityIndicatorView()
        blurView?.contentView.addSubview(indicatorView!)
        indicatorView?.snp_makeConstraints {make in
            make.center.equalTo(blurView!.contentView)
        }
        indicatorView?.startAnimating()
        
        if let url = room.streamAddr {
            startPlay(url)
        }
    }
    
    var blurView: UIVisualEffectView?
    var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cache = KingfisherManager.sharedManager.cache
        if let image = cache.retrieveImageInMemoryCacheForKey(room.anchor!.portrait!) {
            let size = playerView.bounds.size
            let horizontalRatio = size.width / image.size.width
            let verticalRatio = size.height / image.size.height
            var bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            var edge = UIEdgeInsetsZero
            if horizontalRatio < verticalRatio {
                let width = size.width / size.height * image.size.height
                edge.left = (image.size.width - width) / 2
                edge.right = edge.left
                bounds.size.width = width
                bounds.origin.x = edge.left
            } else if horizontalRatio > verticalRatio {
                let height = size.height / size.width * image.size.width
                edge.top = (image.size.height - height) / 2
                edge.bottom = edge.top
                bounds.size.height = height
                bounds.origin.y = edge.top
            }
            let im1 = image.crop(bounds)!
            let im = im1.resize(size, contentMode: .ScaleToFill)
            playerView.backgroundColor = UIColor(patternImage: im!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var room: Room!

    @IBOutlet weak var playerView: UIView!
    
    @IBAction func closeButtonClick(sender: UIButton) {
        player.delegate = nil
        player.stop()
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    let player = VLCMediaPlayer()
    func startPlay(url: String) {
        if let u = NSURL(string: url) {
            player.delegate = self
            player.drawable = playerView
            player.media = VLCMedia(URL: u)
            player.play()
        }
    }
    
    func mediaPlayerStateChanged(aNotification: NSNotification!) {
        if player.state == .Error {
            let alert = UIAlertController(title: "播放失败", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "好的", style: .Default, handler: { (action) -> Void in
                
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func mediaPlayerTimeChanged(aNotification: NSNotification!) {
        if let blur = blurView {
            blur.removeFromSuperview()
            blurView = nil
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


