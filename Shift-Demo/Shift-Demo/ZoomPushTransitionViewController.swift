//
//  ZoomPushTransitionViewController.swift
//  Shift-Demo
//
//  Created by John Watson on 12/30/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

import Shift
import UIKit


final class ZoomPushTransitionViewController: UIViewController {

    var initialNavigationControllerDelegate: UINavigationControllerDelegate?
    private let button = UIButton()

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.greenColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        button.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        button.setTitle("Press Here", forState: .Normal)
        button.addTarget(self, action: "buttonAction", forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }

}

// MARK: - Actions

extension ZoomPushTransitionViewController {

    func buttonAction() {
        let destinationController = DestinationViewController(withDismissalHandler: { [weak self] in
            self?.navigationController?.popViewControllerAnimated(true)
        })
        destinationController.view.backgroundColor = UIColor.redColor()
        navigationController?.delegate = self
        navigationController?.pushViewController(destinationController, animated: true)
        navigationController?.delegate = initialNavigationControllerDelegate
    }

}

// MARK: - Navigation Controller Delegate

extension ZoomPushTransitionViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomPushTransition()
    }

}
