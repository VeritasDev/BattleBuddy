//
//  FirearmBuildViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class FirearmBuildViewController: BaseViewController {
    var controller: FirearmBuildController

    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    init(_ controller: FirearmBuildController) {
        self.controller = controller
        super.init()
    }
}
