//
//  View.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/9/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateCircular(withDuration duration: TimeInterval, center: CGPoint, revert: Bool = false, animations: () -> Void, completion: ((Bool) -> Void)? = nil) {
        let snapshot = snapshotView(afterScreenUpdates: false)!
        snapshot.frame = bounds
        self.addSubview(snapshot)
        
        let center = convert(center, to: snapshot)
        let radius: CGFloat = {
            let x = max(center.x, frame.width - center.x)
            let y = max(center.y, frame.height - center.y)
            return sqrt(x * x + y * y)
        }()
        var animation : CircularRevealAnimator
        if !revert {
            animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: 0, endRadius: radius, invert: true)
        } else {
            animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: radius, endRadius: 0, invert: false)
        }
        animation.duration = duration
        animation.completion = {
            snapshot.removeFromSuperview()
            completion?(true)
        }
        animation.start()
        animations()
    }
}

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

