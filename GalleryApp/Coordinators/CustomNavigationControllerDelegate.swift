//
//  CustomNavigationControllerDelegate.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 1.11.24.
//

import Foundation
import UIKit

// MARK: Custom NavigationControllerDelegate
class CustomNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    private var originFrame: CGRect = .zero

    // Delegate method (determine whether push or pop animation)
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomTransitionAnimator(isPush: true, originFrame: originFrame)
        case .pop:
            return CustomTransitionAnimator(isPush: false, originFrame: originFrame)
        default:
            return nil
        }
    }
    
    func setOriginFrame(originFrame: CGRect) {
        self.originFrame = originFrame
    }
}
