//
//  HeaderView.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/10/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var heightLayoutConstraint = NSLayoutConstraint()
    var bottomLayoutConstraint = NSLayoutConstraint()
    
    var containerView = UIView()
    var containerLayoutConstraint = NSLayoutConstraint()
    var imageURL: URL?
    
    convenience init(frame: CGRect, imageURL: URL?) {
        self.init(frame: frame)
        self.imageURL = imageURL
        prepairView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepairView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerLayoutConstraint.constant = scrollView.contentInset.top;
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        containerView.clipsToBounds = offsetY <= 0
        bottomLayoutConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        heightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
    func prepairView() {
        self.backgroundColor = UIColor.black
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
        
        containerLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        self.addConstraint(containerLayoutConstraint)
        
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setRemoteImage(defaultImage: #imageLiteral(resourceName: "star_wars_logo"), imageURL: imageURL)
        containerView.addSubview(imageView)
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView" : imageView]))
        
        bottomLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        heightLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        containerView.addConstraints([heightLayoutConstraint, bottomLayoutConstraint])
    }
    
}

//class HeaderView: UIView {
//
//    var heightLayoutConstraint = NSLayoutConstraint()
//    var bottomLayoutConstraint = NSLayoutConstraint()
//
//    var containerView = UIView()
//    var containerLayoutConstraint = NSLayoutConstraint()
//    var imageURL: URL?
//    
//    convenience init(frame: CGRect, imageURL: URL) {
//        self.init(frame: frame)
//        self.imageURL = imageURL
//        prepairView()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    func prepairView() {
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(containerView)
//        
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
//        
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView]))
//        
//        containerLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
//        
//        self.addConstraint(containerLayoutConstraint)
//        
//        let imageView: UIImageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = UIColor.black
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        imageView.setRemoteImage(defaultImage: #imageLiteral(resourceName: "star_wars_logo"), imageURL: imageURL)
//        containerView.addSubview(imageView)
//        
//        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView" : imageView]))
//        
//        bottomLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
//        
//        heightLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1.0, constant: 0.0)
//        
//        containerView.addConstraints([heightLayoutConstraint, bottomLayoutConstraint])
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        containerLayoutConstraint.constant = scrollView.contentInset.top;
//        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
//        containerView.clipsToBounds = offsetY <= 0
//        bottomLayoutConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
//        heightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
//    }
//}

