//
//  CustomModalPresentationController.swift
//  HelloEureka
//
//  Created by Jay on 12/23/18.
//  Copyright © 2018 Jay. All rights reserved.
//

import Foundation
import UIKit

class CustomModalPresentationController : UIPresentationController {
    
    public static let modalViewHeight: CGFloat = 400.0
    
    var overlayView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let height = CustomModalPresentationController.modalViewHeight
        let originX = containerView!.bounds.height - height
        return CGRect(x: 0, y: originX, width: containerView!.bounds.width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else { return }
        
        if overlayView == nil {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
            
            // Blur Effect
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            view.addSubview(blurEffectView)
            
            // Vibrancy Effect
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
            vibrancyEffectView.frame = view.bounds
            
            // Add the vibrancy view to the blur view
            blurEffectView.contentView.addSubview(vibrancyEffectView)
            
            view.alpha = 0.5
            containerView.addSubview(view)
            
            overlayView = view
            
            self.tapGestureRecognizer = UITapGestureRecognizer()
            self.tapGestureRecognizer.addTarget(self, action: #selector(tapAction(_:)))
            overlayView.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        overlayView?.removeFromSuperview()
    }
    
    @objc func tapAction(_ : UITapGestureRecognizer) -> Void {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

class CustomModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var viewController: UIViewController
    var presentingViewController: UIViewController
    
    init(viewController: UIViewController, presentingViewController: UIViewController) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
