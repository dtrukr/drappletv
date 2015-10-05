//
//  ChannelCollectionViewCell.swift
//  drtv
//
//  Created by Dennis Torbichuk on 03/10/15.
//  Copyright © 2015 DA Apps. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.logoImageView.transform =  self.focused ? CGAffineTransformMakeScale(1.3, 1.3) :CGAffineTransformIdentity
            self.nameLabel.transform =  self.focused ? CGAffineTransformMakeScale(1.3, 1.3) :CGAffineTransformIdentity
        }
    }
    
    override func prepareForReuse() {
        self.logoImageView.image = nil
    }
}
