//
//  CustomTransitionAnimator.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 1.11.24.
//

import Foundation
import UIKit

// MARK: Custom TransitionAnimator
class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var isPush: Bool
    private var originFrame: CGRect
    
    init(isPush: Bool, originFrame: CGRect) {
        self.isPush = isPush
        self.originFrame = originFrame
    }
    
    // Transition animation duration
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.4
    }
    
    // Setup custom transition animation
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get view for transition animation (we animate DetailViewController)
        // If we push it, it's toView
        // If we pop it, it's fromView
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let animatingView = self.isPush ? toView : fromView
        
        // Get containerview that manages hierarchy of views for animation
        let containerView = transitionContext.containerView

        // AnimatingView.frame is initial state for animating (beginning)
        // If we push DetailVC, it's cell frame relative to superview
        // If we pop it, it's fromView's frame (whole view)
        if self.isPush {
            animatingView.frame = self.originFrame
            containerView.addSubview(toView)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        // FinalFrame is end state for animating
        // If we push DetailVC, it's toView's frame (whole view)
        // If we pop it, it's cell frame relative to superview
        let finalFrame = self.isPush ? containerView.frame : self.originFrame
        
        // Animation setup (will be animated from animatingView.frame to finalFrame)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: { animatingView.frame = finalFrame }) { finished in
            if !self.isPush {
                fromView.removeFromSuperview()
            }
            // Animation is complete, user interface can be refreshed
            transitionContext.completeTransition(finished)
        }
    }
}
