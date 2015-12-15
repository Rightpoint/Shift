//
//  SplitTransition.swift
//  Shift
//
//  Created by Matthew Buckley on 12/10/15.
//  Copyright 2015 Raizlabs and other contributors
//  http://raizlabs.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit


public enum TransitionType {
    case Push
    case Pop
    case Interactive
}

public class SplitTransition: UIPercentDrivenInteractiveTransition {
    /**
     * The duration (in seconds) of the transition.
     */
    public var transitionDuration: NSTimeInterval = 1.0

    /**
     * The delay before/after the transition (in seconds).
     */
    public var transitionDelay: NSTimeInterval = 0.0

    /**
     * Stores animation type (e.g. push/pop). Defaults to "push".
     */
    public var transitionType: TransitionType = .Push

    /**
     * Y coordinate where top and bottom screen captures
     * should split
     */
    public var splitLocation: CGFloat = 0.0

    /**
     * Screen capture extending from split location
     * to top of screen
     */
    lazy var topSplitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.screenCapture
        imageView.contentMode = .Top
        imageView.clipsToBounds = true
        return imageView
    }()

    public var sourceViewController: UIViewController?
    public var interactive: Bool = true
    private var canScrollToZero: Bool = false
    private var transitionProgress: CGFloat = 0.0
    private var gestureRecognizer: UIPanGestureRecognizer?
    private var transitionContext: UIViewControllerContextTransitioning?
    private var previousTouchLocation: CGPoint = CGPointZero
    private var container: UIView?
    private var toVC: UIViewController?
    private var fromVC: UIViewController?
    private var completion: (() -> ())?

    /**
     * Screen capture extending from split location
     * to bottom of screen
     */
    lazy var bottomSplitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.screenCapture
        imageView.contentMode = .Bottom
        imageView.clipsToBounds = true
        return imageView
    }()

    /**
     *  Optional capture of entire screen
     */
    var screenCapture: UIImage?

    convenience init(transitionDuration: NSTimeInterval, transitionType: TransitionType) {
        self.init()
        self.transitionDuration = transitionDuration
        self.transitionType = transitionType
    }

    func didPan(gesture: UIPanGestureRecognizer) {

        switch (gesture.state) {
        case .Began:
            let presentationLayer = container?.layer.presentationLayer()
            container?.layer.position = presentationLayer?.position ?? CGPointZero
            container?.layer.removeAllAnimations()
            previousTouchLocation = gesture.locationInView(container)
            break
        case .Changed:
            let currentTouchLocation = gesture.locationInView(container)
            let distanceMoved = currentTouchLocation.y - previousTouchLocation.y

            transitionProgress += distanceMoved
            let totalDistance = max(topSplitImageView.bounds.size.height, bottomSplitImageView.bounds.size.height)

            let floor = canScrollToZero ? 0.0 : 50.0 / totalDistance

            // Update interactive transition
            let percentComplete = max((transitionProgress / totalDistance), floor)

            print("\(previousTouchLocation.y > currentTouchLocation.y)")
            if (previousTouchLocation.y > currentTouchLocation.y) && percentComplete == floor {
                canScrollToZero = true
            }

            print("\(percentComplete)")
            previousTouchLocation = currentTouchLocation

            transitionProgress += ((currentTouchLocation.y - splitLocation) / splitLocation)
            topSplitImageView.transform = CGAffineTransformMakeTranslation(0.0, -(percentComplete * (topSplitImageView.bounds.size.height - 50.0)))
            bottomSplitImageView.transform = CGAffineTransformMakeTranslation(0.0, (percentComplete * (bottomSplitImageView.bounds.size.height - 50.0)))

            transitionContext?.updateInteractiveTransition(percentComplete)

            if (percentComplete >= 1.0) {
                // When the transition is finished, top and bottom
                // split views are removed from the view hierarchy
                topSplitImageView.removeFromSuperview()
                bottomSplitImageView.removeFromSuperview()
                if let completion = completion {
                    completion()
                }

                // Make destination view controller's view visible again
                toVC?.view.alpha = 1.0
                fromVC?.view.alpha = 0.0
            }
            else if (percentComplete == 0.0) {
                topSplitImageView.removeFromSuperview()
                bottomSplitImageView.removeFromSuperview()
                if let completion = completion {
                    cancelInteractiveTransition()
                    completion()
                }

                // Make destination view controller's view visible again
                toVC?.view.alpha = 0.0
                if let destinationView = fromVC?.view,
                    originView = toVC?.view {
                        container?.insertSubview(destinationView, aboveSubview: originView)
                        destinationView.alpha = 1.0
                }
                canScrollToZero = false
            }
            break
        default:
            break
        }
    }

    public override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        setupTransition(transitionContext)
    }

}

extension SplitTransition: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        setupTransition(transitionContext)

        guard let fromVC = fromVC,
            toVC = toVC,
            container = container,
            completion = completion else {
                print("animation setup failed")
                return
        }

        gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
        if let gestureRecognizer = gestureRecognizer {
            gestureRecognizer.delegate = self
            sourceViewController?.view.window?.addGestureRecognizer(gestureRecognizer)
        }

        switch(transitionType) {
        case .Push:
            push(toViewController: toVC, fromViewController: fromVC, containerView: container, completion: completion)
            break
        case .Pop:
            pop(toVC, fromViewController: fromVC, containerView: container, completion: completion)
            break
        case .Interactive:
            push(50.0, toViewController: toVC, fromViewController: fromVC, containerView: container, completion: nil)
            break
        }
    }

}

private extension SplitTransition {

    // MARK: private interface

    // Returns the view controller being navigated away from
    func fromViewController(transitionContext: UIViewControllerContextTransitioning?) -> UIViewController? {
        return transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
    }

    // Returns the view controller being navigated to
    func toViewController(transitionContext: UIViewControllerContextTransitioning?) -> UIViewController? {
        return transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)
    }

    // Returns the container view for the transition context
    func containerView(transitionContext: UIViewControllerContextTransitioning?) -> UIView? {
        return transitionContext?.containerView()
    }

    func setupTransition(transitionContext: UIViewControllerContextTransitioning?) -> Void {
        // Take screenshot and store resulting UIImage
        screenCapture = UIWindow.screenShot()

        // Grab the view in which the transition should take place.
        // Coalesce to UIView()
        container = containerView(transitionContext) ?? UIView()

        // Set source and destination view controllers
        fromVC = fromViewController(transitionContext) ?? UIViewController()
        toVC = toViewController(transitionContext) ?? UIViewController()

        // Set completion handler for transition
        completion = {
            let complete: Bool = transitionContext?.transitionWasCancelled() ?? false
            // Remove gesture recognizer from view
            if let gestureRecognizer = self.gestureRecognizer {
                gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
            }

            // Complete the transition
            transitionContext?.completeTransition(!complete)
            transitionContext?.finishInteractiveTransition()
        }
    }

    // Push Transition
    func push(toOffset: CGFloat = 0.0, toViewController: UIViewController,
        fromViewController: UIViewController,
        containerView: UIView,
        completion: (() -> ())?) {

            // Add subviews
            containerView.addSubview(toViewController.view)
            containerView.addSubview(topSplitImageView)
            containerView.addSubview(bottomSplitImageView)

            // Set initial frames for screen captures
            setInitialScreenCaptureFrames(containerView)

            // source view controller is initially hidden
            fromViewController.view.alpha = 0.0
            toViewController.view.alpha = 1.0
            toViewController.view.transform = CGAffineTransformMakeTranslation(0.0, topSplitImageView.frame.size.height)

            // Set animation options
            let options: UIViewAnimationOptions = interactive ? .AllowUserInteraction : .LayoutSubviews

            // Animate all the way or only partially if a toOffset parameter is passed in
            let targetOffsetTop = toOffset != 0.0 ? -toOffset : -topSplitImageView.bounds.size.height
            let targetOffsetBottom = toOffset != 0.0 ? toOffset : bottomSplitImageView.bounds.size.height

            UIView.animateWithDuration(transitionDuration, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: options, animations: { [weak self] () -> Void in
                if let controller = self {
                    controller.topSplitImageView.transform = CGAffineTransformMakeTranslation(0.0, targetOffsetTop)
                    controller.bottomSplitImageView.transform = CGAffineTransformMakeTranslation(0.0, targetOffsetBottom)
                    toViewController.view.transform = CGAffineTransformIdentity
                }
                }) { [weak self] (Bool) -> Void in
                    // When the transition is finished, top and bottom
                    // split views are removed from the view hierarchy
                    if let controller = self {
                        if (!controller.interactive) {
                            controller.topSplitImageView.removeFromSuperview()
                            controller.bottomSplitImageView.removeFromSuperview()
                        }
                        // If a completion was passed as a parameter,
                        // execute it
                        if let completion = completion {
                            completion()
                        }
                    }

            }
    }

    // Pop Transition
    func pop(toViewController: UIViewController,
        fromViewController: UIViewController,
        containerView: UIView,
        completion: (() -> ())?) {

            // Add subviews
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            containerView.addSubview(toViewController.view)
            containerView.addSubview(topSplitImageView)
            containerView.addSubview(bottomSplitImageView)

            // Destination view controller is initially hidden
            toViewController.view.alpha = 0.0

            // Set initial transforms for top and bottom split views
            topSplitImageView.transform = CGAffineTransformMakeTranslation(0.0, -topSplitImageView.bounds.size.height)
            bottomSplitImageView.transform = CGAffineTransformMakeTranslation(0.0, bottomSplitImageView.bounds.size.height)

            UIView.animateWithDuration(transitionDuration, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .LayoutSubviews, animations: { [weak self] () -> Void in
                if let controller = self {

                    // Restore the top and bottom screen
                    // captures to their original positions
                    controller.topSplitImageView.transform = CGAffineTransformIdentity
                    controller.bottomSplitImageView.transform = CGAffineTransformIdentity

                    // Restore fromVC's view to its original position
                    fromViewController.view.transform = CGAffineTransformMakeTranslation(0.0, controller.topSplitImageView.bounds.size.height)
                }
                }) { [weak self] (Bool) -> Void in
                    // When the transition is finished, top and bottom
                    // split views are removed from the view hierarchy
                    if let controller = self {
                        controller.topSplitImageView.removeFromSuperview()
                        controller.bottomSplitImageView.removeFromSuperview()
                    }

                    // Make destination view controller's view visible again
                    toViewController.view.alpha = 1.0

                    // If a completion was passed as a parameter,
                    // execute it
                    if let completion = completion {
                        completion()
                    }
            }
    }

    func setInitialScreenCaptureFrames(containerView: UIView) {

        // Set bounds for top and bottom screen captures
        let width = containerView.frame.size.width ?? 0.0
        let height = containerView.frame.size.height ?? 0.0

        // Top screen capture extends from split location to top of view
        topSplitImageView.frame = CGRectMake(0.0, 0.0, width, splitLocation)

        // Bottom screen capture extends from split location to bottom of view
        bottomSplitImageView.frame = CGRectMake(0.0, splitLocation, width, height - splitLocation)
    }

}

extension SplitTransition: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.locationInView(container)
        let presentationLayer = container?.layer.presentationLayer()

        if ((presentationLayer?.hitTest(location)) != nil) {
            return true
        }
        return false
    }
    
}

extension SplitTransition: UIViewControllerTransitioningDelegate {
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self : nil
    }
    
}
