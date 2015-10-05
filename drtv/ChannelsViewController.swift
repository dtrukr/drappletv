//
//  ViewController.swift
//  drtv
//
//  Created by Dennis Torbichuk on 03/10/15.
//  Copyright © 2015 DA Apps. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var channels: [Channel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Channel.retreiveChannels({ (channels: [Channel]) -> Void in
            self.channels = channels
            print("Got channels: \(self.channels)")
            }) { (error) -> Void in
                let ctr = UIAlertController(title: "Error", message: "Error occured while downloading channels", preferredStyle: .Alert)
                self.presentViewController(ctr, animated: true, completion: nil)
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let channel = channels[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ChannelCollectionViewCell
        cell.nameLabel.text = channel.title

        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: channel.imageURL)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                cell.logoImageView.image = UIImage(data: data)
            }
            
        })
        
        task.resume()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let channel = channels[indexPath.row]
        print("Select channel \(channel.title)")
        
        let videoVC = VideoViewController()
        videoVC.channel = channel
        
        self.navigationController!.pushViewController(videoVC, animated: true)
    }
    
  
}

