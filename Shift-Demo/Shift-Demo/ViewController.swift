//
//  ViewController.swift
//  Shift-Demo
//
//  Created by Matthew Buckley on 12/10/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

import UIKit
import Shift

final class ViewController: UITableViewController {

    var currentTransition: SplitTransition?
    var currentSplitLocation: CGFloat = 0.0

    let titles = [
        "Split Transition Push/Pop (Animated)",
        "Split Transition Present/Dismiss (Animated)",
        "Split Transition (Interactive)"
    ]

    let exampleViewControllers = [
        SplitTransitionAnimatedPushPopViewController(),
        SplitTransitionAnimatedPresentDismissViewControllerViewController(),
        SplitTransitionInteractiveViewController()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "com.testApp.reuseIdentifier")
        tableView.separatorStyle = .None
        tableView.rowHeight = 50.0
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.testApp.reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSplitLocation = CGRectGetMidY(tableView.rectForRowAtIndexPath(indexPath)) - tableView.contentOffset.y
        let destinationViewController = exampleViewControllers[indexPath.row]
        navigationController?.pushViewController(destinationViewController, animated: true)
    }

}
