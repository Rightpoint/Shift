//
//  ZoomPushTransition.swift
//  Shift
//
//  Created by John Watson on 12/21/15.
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


public final class ZoomPushTransition: NSObject {

    private let transitionTime = NSTimeInterval(0.35)
    private let scaleChangePct = CGFloat(0.33)

}

// MARK: - View Controller Animated Transitioning

extension ZoomPushTransition: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionTime
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
              let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
              let container = transitionContext.containerView() else {
            debugPrint("Animation setup failed")
            return
        }

        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        toVC.view.transform = CGAffineTransformMakeScale(1.0 - scaleChangePct, 1.0 - scaleChangePct)

        toVC.viewWillAppear(true)
        UIView.animateWithDuration(
            transitionTime,
            delay: 0.0,
            options: [UIViewAnimationOptions.CurveEaseOut],
            animations: {
                toVC.view.transform = CGAffineTransformIdentity
                fromVC.view.transform = CGAffineTransformMakeScale(1.0 + self.scaleChangePct, 1.0 + self.scaleChangePct)
                fromVC.view.alpha = 0.0
            },
            completion: { _ in
                toVC.view.transform = CGAffineTransformIdentity
                fromVC.view.transform = CGAffineTransformIdentity
                fromVC.view.alpha = 1.0

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        )
    }

}
