//
//  ViewController.swift
//  Shift-Demo
//
//  Created by Matthew Buckley on 12/10/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

import UIKit
import Shift

class ViewController: UITableViewController {

    var currentTransition: SplitTransitionController?
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
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.testApp.reuseIdentifier", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.delegate = self
        currentCell = tableView.cellForRowAtIndexPath(indexPath)
        let destinationViewController = DestinationViewController()
        destinationViewController.view.backgroundColor = colors[indexPath.row]
        navigationController?.pushViewController(destinationViewController, animated: true)
    }

}

extension ViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if (operation == .Push && fromVC == self) {
            let splitTransition = SplitTransitionController()
            splitTransition.transitionDuration = 2.0
            splitTransition.transitionType = .Push
            splitTransition.splitLocation = currentCell != nil ? CGRectGetMidY(currentCell!.frame) : CGRectGetMidY(view.frame)
            currentTransition = splitTransition
        }
        else if (operation == .Pop && toVC == self) {
            currentTransition?.transitionType = .Pop
        }

        return currentTransition
    }

}

