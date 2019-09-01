//
//  BaseCollectionView.swift
//  BattleBuddy
//
//  Created by Mike on 6/29/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView {

    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        backgroundColor = UIColor.Theme.background
    }
}
