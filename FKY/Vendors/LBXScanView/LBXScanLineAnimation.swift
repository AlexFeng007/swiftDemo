//
//  LBXScanLineAnimation.swift
//  swiftScan
//
//  Created by lbxia on 15/12/9.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit

class LBXScanLineAnimation: UIImageView {

    var isAnimationing = false
    var animationRect = CGRect.zero
    
    func startAnimatingWithRect(animationRect: CGRect, parentView: UIView, image: UIImage?) {
        self.image = image
        self.animationRect = animationRect
        parentView.addSubview(self)
        
        isHidden = false
        isAnimationing = true
        if image != nil {
            stepAnimation()
        }
    }
    
    @objc func stepAnimation() {
        guard isAnimationing else {
            return
        }
        var frame = animationRect
        let hImg = image!.size.height * animationRect.size.width / image!.size.width

        frame.origin.y -= hImg
        frame.size.height = hImg
        self.frame = frame
        alpha = 0.0

        UIView.animate(withDuration: 1.4, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.alpha = 1.0
            var frame = strongSelf.animationRect
            let hImg = strongSelf.image!.size.height * strongSelf.animationRect.size.width / strongSelf.image!.size.width
            frame.origin.y += (frame.size.height - hImg)
            frame.size.height = hImg
            strongSelf.frame = frame
        }, completion: {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.perform(#selector(LBXScanLineAnimation.stepAnimation), with: nil, afterDelay: 0.3)
        })
    }
    
    func stopStepAnimating() {
        isHidden = true
        isAnimationing = false
    }
    
    public static func instance() -> LBXScanLineAnimation {
        return LBXScanLineAnimation()
    }
    
    deinit {
        stopStepAnimating()
    }

}





