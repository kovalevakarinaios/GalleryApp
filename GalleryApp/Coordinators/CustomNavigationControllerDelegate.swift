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
    
    private var cellOriginFrame: CGRect = .zero
    private var snapshot: UIView = UIView()
    private var detailImageViewFrame: CGRect = .zero

    // Delegate method (determine whether push or pop animation)
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomTransitionAnimator(isPush: true,
                                            cellOriginFrame: self.cellOriginFrame,
                                            selectedCellImageViewSnapshot: self.snapshot,
                                            detailImageViewFrame: self.detailImageViewFrame)
        case .pop:
            return CustomTransitionAnimator(isPush: false,
                                            cellOriginFrame: self.cellOriginFrame,
                                            selectedCellImageViewSnapshot: self.snapshot, 
                                            detailImageViewFrame: self.detailImageViewFrame)
        default:
            return nil
        }
    }
    
    func updateInfoForTransitionAnimation(cellOriginFrame: CGRect, snapshot: UIView, frame: CGRect) {
        self.cellOriginFrame = cellOriginFrame
        self.snapshot = snapshot
        self.detailImageViewFrame = frame
    }
}
