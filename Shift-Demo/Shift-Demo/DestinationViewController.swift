//
//  DestinationViewController.swift
//  Shift-Demo
//
//  Created by Matthew Buckley on 12/10/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

import UIKit

final class DestinationViewController: UIViewController {

    var dismissalHandler: (() -> ())?
    
    convenience init(withDismissalHandler dismissalHandler: () -> ()) {
        self.init()
        self.dismissalHandler = dismissalHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func didTap(sender: UITapGestureRecognizer) {
        dismissalHandler?()
    }
    
}
