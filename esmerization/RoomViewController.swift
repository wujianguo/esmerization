//
//  RoomViewController.swift
//  esmerization
//
//  Created by 吴建国 on 16/2/18.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    var room: Room!
    @IBOutlet weak var playerView: UIView!
    
    @IBAction func closeButtonClick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

/*
class RoomViewController: UIViewController, VLCMediaPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = room.streamAddr {
            startPlay(url)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
*/