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
    func setImageNamed(named: String) {
        self.image = UIImage(named: named)
    }
    
    func setImageNamed(named: String, tintColor: UIColor) {
        self.tintColor = tintColor
        guard let image = UIImage(named: named) else {
            assert(false)
            return
        }
        self.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    func setRemoteImage(defaultImage: UIImage, imageURL: URL?) {
        self.backgroundColor = UIColor.lightGray
        if let url = imageURL {
            self.af_setImage(withURL: url, placeholderImage: defaultImage, filter: nil, progress: nil, progressQueue: DispatchQueue.global(qos: .default), imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: nil)
        } else {
            self.image = defaultImage
        }
    }
}

