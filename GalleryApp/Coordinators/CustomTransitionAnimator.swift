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
    
    private let isPush: Bool
    private let cellOriginFrame: CGRect
    private let selectedCellImageViewSnapshot: UIView
    private let detailImageViewFrame: CGRect
    
    init(isPush: Bool, 
         cellOriginFrame: CGRect,
         selectedCellImageViewSnapshot: UIView,
         detailImageViewFrame: CGRect) {
        self.isPush = isPush
        self.cellOriginFrame = cellOriginFrame
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        self.detailImageViewFrame = detailImageViewFrame
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

        // Get containerview that manages hierarchy of views for animation
        let containerView = transitionContext.containerView
        
        // Add fadeview for blur effect during transitioning
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = .systemBackground
        
        // Building view hierarchies in container view
        containerView.addSubview(toView)
        containerView.insertSubview(fadeView, aboveSubview: toView)
        containerView.insertSubview(self.selectedCellImageViewSnapshot, aboveSubview: fadeView)

        // SelectedCellImageViewSnapshot.frame is initial state for animating (beginning)
        // If we push DetailVC, it's cell frame relative to superview
        // If we pop it, it's imageview frame in DetailVC
        
        // Setup transparency of views for further animation

        if self.isPush {
            toView.alpha = 0
            fadeView.alpha = 0
            self.selectedCellImageViewSnapshot.frame = self.cellOriginFrame
        } else {
            fromView.alpha = 0
            fadeView.alpha = 1
            containerView.insertSubview(toView, belowSubview: fadeView)
        }
     
        // FinalFrame is end state for animating
        // If we push DetailVC, it's detailImageViewFrame
        // If we pop it, it's cell frame relative to superview
        let finalFrameForImage = self.isPush ? self.detailImageViewFrame : self.cellOriginFrame
        // Animation setup (will be animated from animatingView.frame to finalFrame)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
            self.selectedCellImageViewSnapshot.frame = finalFrameForImage
            fadeView.alpha = self.isPush ? 1 : 0
            // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) { finished in
            // Animation is complete, user interface can be refreshed
            toView.alpha = 1
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            fadeView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}
