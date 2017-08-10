//
//  UIImageView.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 7/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//
import UIKit
import AlamofireImage

extension UIImageView {
   
    func setRemoteImage(defaultImage: UIImage, imageURL: URL?, completion: @escaping (Data?) -> Void) {
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        if let url = imageURL {
            self.af_setImage(withURL: url, placeholderImage: defaultImage, filter: nil, progress: nil, progressQueue: DispatchQueue.global(qos: .default), imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { imageResponce in
                completion(imageResponce.data)
            })

        } else {
            self.image = defaultImage
        }
    }
}

