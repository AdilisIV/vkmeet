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
        //let point = CGPoint(x: 0, y: 0)
        //popupView.frame = CGRect(origin: point, size: parrentView.bounds.size)
        popupView.transform = self.affineTransorm
        popupView.alpha = 0
        

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
