//
//  ViewController.swift
//  Timed Label
//
//  Created by Alex on 5/30/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var countLbl: UILabel!
    @IBOutlet var myBtn: UIButton!
    
    // MARK: - Actions
    
    @IBAction func myBtnPressed(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else {return}
            //uncomment to test on UILabel
            self.countLbl.animateCountdownIteration(duration: 0.09, startValue: 0, endValue: 100)
            
            //uncomment to test on UIButton
//            self.animateCountdownIteration(duration: 0.09, onLabel: self.myBtn, value: 100)
        }
    }
    
    // MARK: - Func
    
    func animateCountdownIteration(duration: TimeInterval, onLabel label: UIButton, value: Int) {
        guard value >= 0 else {
            label.setTitle("", for: .normal)
//            label.title = ""
            return
        }

        // if we change the text in an animation closure, it doesn't wait for a delay or anything, it just changes it immediately,
        // so we are compensating here (I don't know if this is a good workaround or not)
        // we want this to change on its way "up", while it's near the pinacle of its scaling animation. (why it's at 0.18 delay instead of 0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.18) {
            label.setTitle("\(value)", for: .normal)
//            label.text = "\(value)"
        }

        // scale the label up to 1.5 scale over 0.2 duration, then return to its identity over the remaining 0.8 of the duration with a spring animation
        // upon completion of the animation (over 1 second total), call this function again to animate the next second going by.
        UIView.animate(withDuration: duration * 0.2, animations: {
            label.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
        }) { _ in
            UIView.animate(withDuration: duration * 0.8, delay: 0, usingSpringWithDamping: 0.15, initialSpringVelocity: 0, options: [], animations: {
                label.transform = .identity
            }, completion: { [weak self] _ in
                self?.animateCountdownIteration(duration: duration, onLabel: label, value: value - 1)
            })
        }
    }
}

extension UILabel {
    
    func animateCountdownIteration(duration: TimeInterval, startValue: Int, endValue: Int) {
        guard startValue <= endValue else {
            self.text = ""
            return
        }
        
        // if we change the text in an animation closure, it doesn't wait for a delay or anything, it just changes it immediately,
        // so we are compensating here (I don't know if this is a good workaround or not)
        // we want this to change on its way "up", while it's near the pinacle of its scaling animation. (why it's at 0.18 delay instead of 0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.18) {
            self.text = "\(startValue)"
        }
        
        // scale the label up to 1.5 scale over 0.2 duration, then return to its identity over the remaining 0.8 of the duration with a spring animation
        // upon completion of the animation (over 1 second total), call this function again to animate the next second going by.
        UIView.animate(withDuration: duration * 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
        }) { _ in
            UIView.animate(withDuration: duration * 0.8, delay: 0, usingSpringWithDamping: 0.15, initialSpringVelocity: 0, options: [], animations: {
                self.transform = .identity
            }, completion: { [weak self] _ in
                self?.animateCountdownIteration(duration: duration, startValue: startValue + 1, endValue: endValue)
            })
        }
    }
    
}
