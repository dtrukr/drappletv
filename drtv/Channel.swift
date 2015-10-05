//
//  Channel.swift
//  drtv
//
//  Created by Dennis Torbichuk on 03/10/15.
//  Copyright © 2015 DA Apps. All rights reserved.
//

import UIKit

class Channel: CustomStringConvertible {

    let title: String
    let imageURL: NSURL
    let streamURL: NSURL
    
    required init(json: JSON) {
        title = json["Title"].stringValue
        imageURL = NSURL(string: json["PrimaryImageUri"].stringValue)!
        
        let server = json["StreamingServers"].arrayValue.filter({$0["LinkType"].stringValue == "HLS"}).first!
        let quality = server["Qualities"].arrayValue.first!["Streams"].arrayValue.first!
        
        streamURL = NSURL(string: server["Server"].stringValue + "/" + quality["Stream"].stringValue)!
        
    }
    
    var description: String {
        return "\(self.title), image: \(self.imageURL), stream: \(self.streamURL)"
    }
    
    class func retreiveChannels(success: (([Channel])->Void)?, failure: (NSError->Void)?) -> Void {
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "http://www.dr.dk/mu-online/api/1.3/channel/all-active-dr-tv-channels")
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        
        /* Start a new Task */
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in

            guard let data = data else {
                
                if let error = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        failure?(error)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        failure?(NSError(domain: "Unknown", code: 0, userInfo: nil))
                    }
                }
                
                return
            }
            
            let json = JSON(data: data)
            let channels = json.arrayValue.map({ Channel(json: $0)}).filter({!$0.title.containsString("WEB")})
            
            dispatch_async(dispatch_get_main_queue()) {
                success?(channels)
            }
            
        })
        
        task.resume()

        
    }
    
}
