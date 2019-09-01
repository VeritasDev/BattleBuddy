//
//  StackLayout.swift
//  BattleBuddy
//
//  Created by Mike on 8/31/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

enum StackLayoutPreset {
    case standard
    case standardHorizontal
    case full
}

struct StackLayoutConfig {
    let spacing: CGFloat
    let insets: UIEdgeInsets
}

struct StackLayout {
    static let defaultSpacing: CGFloat = 10.0

    let preset: StackLayoutPreset
    let compactConfig: StackLayoutConfig
    let regularConfig: StackLayoutConfig
    let axis: NSLayoutConstraint.Axis
    let alignment: UIStackView.Alignment
    let distribution: UIStackView.Distribution

    init(preset: StackLayoutPreset = .standard) {
        self.preset = preset

        switch preset {
        case .standard:
            compactConfig = StackLayoutConfig(spacing: StackLayout.defaultSpacing, insets: UIEdgeInsets.zero)
            regularConfig = StackLayoutConfig(spacing: StackLayout.defaultSpacing, insets: UIEdgeInsets.zero)
            axis = .vertical
            alignment = .fill
            distribution = .fill
        case .standardHorizontal:
            compactConfig = StackLayoutConfig(spacing: StackLayout.defaultSpacing, insets: UIEdgeInsets.zero)
            regularConfig = StackLayoutConfig(spacing: StackLayout.defaultSpacing, insets: UIEdgeInsets.zero)
            axis = .horizontal
            alignment = .fill
            distribution = .fill
        case .full:
            compactConfig = StackLayoutConfig(spacing: StackLayout.defaultSpacing, insets: UIEdgeInsets.zero)
            regularConfig = StackLayoutConfig(spacing: StackLayout.defaultSpacing, insets: UIEdgeInsets.zero)
            axis = .vertical
            alignment = .fill
            distribution = .fill
        }
    }

    func layoutConfig(for view: UIView) -> StackLayoutConfig {
        return view.traitCollection.horizontalSizeClass == .compact ? compactConfig : regularConfig
    }
}
