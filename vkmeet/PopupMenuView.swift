//
//  PopupMenuView.swift
//  vkmeet
//
//  Created by user on 6/20/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit

class PopupMenuView: UIView {
    

    let affineTransorm = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
    var effect: UIVisualEffect!

    
    func animateIn(parrentView: UIView, popupView: UIView, visualEffect: UIVisualEffectView) {
        
        parrentView.addSubview(popupView)
        popupView.center = parrentView.center
        popupView.transform = self.affineTransorm
        popupView.alpha = 0
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": popupView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": popupView]))
        

        UIView.animate(withDuration: 0.4, animations: {
            visualEffect.effect = self.effect
            popupView.alpha = 1
            popupView.transform = CGAffineTransform.identity
        })
        
    }
    
    func animateOut (parrentView: UIView, popupView: UIView, visualEffect: UIVisualEffectView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            popupView.transform = self.affineTransorm
            popupView.alpha = 0
            visualEffect.effect = nil
        }) { (success: Bool) in
            popupView.removeFromSuperview()
        }
        
    }
    
}
