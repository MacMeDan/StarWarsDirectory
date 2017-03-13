//
//  UIImageView.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//
import UIKit
import AlamofireImage

extension UIImageView {
   
    func setRemoteImage(defaultImage: UIImage, imageURL: URL?) {
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        if let url = imageURL {
            self.af_setImage(withURL: url, placeholderImage: defaultImage, filter: nil, progress: nil, progressQueue: DispatchQueue.global(qos: .default), imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: nil)
        } else {
            self.image = defaultImage
        }
    }
}

