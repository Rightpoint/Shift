//
//  SplitTransitionAnimatedPresentDismissViewControllerViewController.swift
//  Shift-Demo
//
//  Created by Matthew Buckley on 1/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import Shift

final class SplitTransitionAnimatedPresentDismissViewControllerViewController: UITableViewController {

    var currentTransition: SplitTransition?
    var currentCell: UITableViewCell?

    let colors = [
        UIColor.redColor(),
        UIColor.purpleColor(),
        UIColor.blueColor(),
        UIColor.greenColor(),
        UIColor.yellowColor(),
        UIColor.orangeColor(),
        UIColor.redColor(),
        UIColor.purpleColor(),
        UIColor.blueColor(),
        UIColor.greenColor(),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "com.testApp.reuseIdentifier")
        tableView.separatorStyle = .None
        tableView.rowHeight = 100.0
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.testApp.reuseIdentifier", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentCell = tableView.cellForRowAtIndexPath(indexPath)

        // Configure destination view controller
        let destinationViewController = DestinationViewController(withDismissalHandler: { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        })
        destinationViewController.view.backgroundColor = colors[indexPath.row]
        destinationViewController.modalPresentationStyle = .Custom

        // Configure transition
        currentTransition = SplitTransition()
        currentTransition?.transitionDuration = 2.0
        currentTransition?.screenshotScope = .Window
        currentTransition?.splitLocation = CGRectGetMidY((currentCell!.frame)) + navigationController!.navigationBar.frame.size.height
        currentTransition?.transitionType = .Presentation(self, destinationViewController)

        // Set transitioning delegate on destination view controller
        destinationViewController.transitioningDelegate = currentTransition

        presentViewController(destinationViewController, animated: true) { [weak self] () -> Void in
            guard let vc = self,
            presentedVC = self?.presentedViewController else {
                debugPrint("SplitTransitionAnimatedPresentDismissViewControllerViewController has been deallocated")
                return
            }
            
            // After presentation has finished, update transitionType on currentTransition
            vc.currentTransition?.transitionType = .Dismissal(presentedVC, vc)
        }
    }

}
