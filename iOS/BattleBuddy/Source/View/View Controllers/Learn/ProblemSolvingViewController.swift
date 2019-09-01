//
//  ProblemSolvingViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class ProblemSolvingViewController: BaseStackViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "problem_solving".local()

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
