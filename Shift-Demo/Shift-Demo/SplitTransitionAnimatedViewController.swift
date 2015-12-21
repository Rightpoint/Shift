//
//  SplitTransitionAnimatedViewController.swift
//  Shift-Demo
//
//  Created by Matthew Buckley on 12/19/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

import UIKit
import Shift

final class SplitTransitionAnimatedViewController: UITableViewController {

    var initialNavigationControllerDelegate: UINavigationControllerDelegate?
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initialNavigationControllerDelegate = navigationController?.delegate
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
        navigationController?.delegate = self
        currentCell = tableView.cellForRowAtIndexPath(indexPath)
        let destinationViewController = DestinationViewController()
        destinationViewController.view.backgroundColor = colors[indexPath.row]
        navigationController?.pushViewController(destinationViewController, animated: true)
    }

}

extension SplitTransitionAnimatedViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

            if (operation == .Push && fromVC == self) {
                let splitTransition = SplitTransition()
                splitTransition.transitionDuration = 2.0
                splitTransition.transitionType = .Push
                splitTransition.splitLocation = currentCell != nil ? CGRectGetMidY(currentCell!.frame) + navigationController.navigationBar.frame.size.height : CGRectGetMidY(view.frame) + navigationController.navigationBar.frame.size.height
                currentTransition = splitTransition
            }
            else if (operation == .Pop && toVC == self) {
                currentTransition?.transitionType = .Pop
            }
            
            return currentTransition
    }
    
}

