//
//  UIView.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 21/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit

private let backgroundViewTag = 3432

extension UIView {
    func addHideKeyboardOnTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func lock() {
        if let blockedView = self.viewWithTag(backgroundViewTag) {
            blockedView.removeFromSuperview()
        }
        
        let backgroundView = UIView()
        backgroundView.isUserInteractionEnabled = false
        backgroundView.tag = backgroundViewTag
        
        self.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.topAnchor.constraint(lessThanOrEqualTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        }, completion: nil)
    }
    
    func unlock() {
        DispatchQueue.main.async {
            guard let backGroundView = self.viewWithTag(backgroundViewTag) else {
                return
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                backGroundView.alpha = 0
            }) { (_) in
                backGroundView.removeFromSuperview()
            }
        }
    }
}
