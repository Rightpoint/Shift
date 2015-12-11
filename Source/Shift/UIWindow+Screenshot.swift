//
//  UIWindow+Screenshot.swift
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

import Foundation

extension UIWindow {

    public class func screenShot() -> UIImage {

        // Store current device orientation
        let orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation

        // Generate image size depending on device orientation
        let imageSize: CGSize = UIInterfaceOrientationIsPortrait(orientation) ? UIScreen.mainScreen().bounds.size : CGSizeMake(UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
        let context: CGContextRef? = UIGraphicsGetCurrentContext()

        if let context = context {
            for window in UIApplication.sharedApplication().windows {

                // Save the current graphics state
                CGContextSaveGState(context)

                // Move the graphics context to the center of the window
                CGContextTranslateCTM(context, window.center.x, window.center.y)
                CGContextConcatCTM(context, window.transform)

                // Move the graphics context left and up
                CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y)

                let pi_2: CGFloat = CGFloat(M_PI_2)
                let pi: CGFloat = CGFloat(M_PI)

                switch (orientation) {
                case UIInterfaceOrientation.LandscapeLeft:
                    // Rotate graphics context 90 degrees clockwise
                    CGContextRotateCTM(context, pi_2)

                    // Move graphics context up
                    CGContextTranslateCTM(context, 0, -imageSize.width)
                    break
                case UIInterfaceOrientation.LandscapeRight:
                    // Rotate graphics context 90 degrees counter-clockwise
                    CGContextRotateCTM(context, -pi_2)

                    // Move graphics context left
                    CGContextTranslateCTM(context, -imageSize.height, 0)
                    break
                case UIInterfaceOrientation.PortraitUpsideDown:
                    // Rotate graphics context 180 degrees
                    CGContextRotateCTM(context, pi)

                    // Move graphics context left and up
                    CGContextTranslateCTM(context, -imageSize.width, -imageSize.height)
                    break
                default:
                    break
                }

                // draw view hierarchy or render
                if (window.respondsToSelector(Selector("drawViewHierarchyInRect:"))) {
                    window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: true)
                }
                else {
                    window.layer.renderInContext(context)
                }
                CGContextRestoreGState(context)
            }
        }
        else {
            // Log an error message in case of failure
            print("unable to get current graphics context")
        }

        // Grab rendered image
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
