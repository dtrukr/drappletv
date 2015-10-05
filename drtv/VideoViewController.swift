//
//  VideoViewController.swift
//  drtv
//
//  Created by Dennis Torbichuk on 03/10/15.
//  Copyright © 2015 DA Apps. All rights reserved.
//

import UIKit
import AVKit

class VideoViewController: AVPlayerViewController {

    var channel: Channel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showsPlaybackControls = true
        
        let player : AVPlayer = AVPlayer(URL: channel.streamURL)
        
        self.player = player
        self.view.autoresizesSubviews = true
        
        player.play()
    }

}
