//
//  PostConfiguration.swift
//  BattleBuddy
//
//  Created by Mike on 7/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import FirebaseStorage
import youtube_ios_player_helper

enum PostElementType {
    case image
    case youtube
    case header
    case subHeader
    case bodyTitle
    case body
}

protocol PostConfiguration {
    var title: String? { get }
    var elements: [PostElement] { get }
}

protocol PostElement {
    var type: PostElementType { get }
    func generateContent() -> UIView
}

struct PostElementHeader: PostElement {
    var type: PostElementType
    let localizedTitle: String
    let authorName: String
    let publishDate: Date

    init(localizedTitle: String, authorName: String, publishDate: Date) {
        self.type = .header
        self.localizedTitle = localizedTitle
        self.authorName = authorName
        self.publishDate = publishDate
    }

    func generateContent() -> UIView {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 45, weight: .thin)
        titleLabel.text = localizedTitle
        titleLabel.numberOfLines = 0

        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        let dateString = formatter.string(from: publishDate)
        let subtitleLabel = UILabel()
        subtitleLabel.text = authorName + " - " + dateString
        subtitleLabel.textColor = UIColor.Theme.primary
        subtitleLabel.font = .systemFont(ofSize: 20.0, weight: .regular)

        let containerStackView = BaseStackView(spacing: 3.0, xPaddingCompact: 20.0, xPaddingRegular: 100.0)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(subtitleLabel)

        return containerStackView
    }
}

struct PostElementImage: PostElement {
    var type: PostElementType = .image
    let image: UIImage
    let height: CGFloat
    let imageView = BaseImageView(imageSize: .large, aspectRatio: .standard)

    init(image: UIImage, height: CGFloat) {
        self.image = image
        self.height = height
    }

    func generateContent() -> UIView {
        imageView.image = image
        return imageView
    }
}

struct PostElementYouTube: PostElement {
    var type: PostElementType = .youtube
    let videoId: String
    let height: CGFloat
    let playerView = YTPlayerView()

    init(videoId: String, height: CGFloat) {
        self.videoId = videoId
        self.height = height
    }

    func generateContent() -> UIView {
        playerView.load(withVideoId: videoId)
        playerView.constrainHeight(height)
        return playerView
    }
}

struct PostElementSubHeader: PostElement {
    var type: PostElementType = .subHeader
    let localizedTitle: String

    init(localizedTitle: String) {
        self.localizedTitle = localizedTitle
    }

    func generateContent() -> UIView {
        let titleLabel = UILabel()
        titleLabel.textColor = .init(white: 0.08, alpha: 1.0)
        titleLabel.font = .systemFont(ofSize: 32.0, weight: .light)
        titleLabel.text = localizedTitle
        titleLabel.numberOfLines = 0

        let containerStackView = BaseStackView(spacing: 3.0, xPaddingCompact: 20.0, xPaddingRegular: 100.0)
        containerStackView.addArrangedSubview(titleLabel)
        return containerStackView
    }
}

struct PostElementBodyTitle: PostElement {
    var type: PostElementType = .bodyTitle
    let titleText: String

    init(title: String) {
        titleText = title
    }

    func generateContent() -> UIView {
        let titleLabel = UILabel()
        titleLabel.textColor = .init(white: 0.9, alpha: 1.0)
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = titleText
        titleLabel.numberOfLines = 0

        let containerStackView = BaseStackView(spacing: 3.0, xPaddingCompact: 20.0, xPaddingRegular: 100.0)
        containerStackView.addArrangedSubview(titleLabel)
        return containerStackView
    }
}

struct PostElementBody: PostElement {
    var type: PostElementType = .body
    let bodyText: String

    init(body: String) {
        bodyText = body
    }

    func generateContent() -> UIView {
        let titleLabel = UILabel()
        titleLabel.textColor = .init(white: 0.9, alpha: 1.0)
        titleLabel.font = .systemFont(ofSize: 18, weight: .thin)
        titleLabel.text = bodyText
        titleLabel.numberOfLines = 0

        let containerStackView = BaseStackView(spacing: 3.0, xPaddingCompact: 20.0, xPaddingRegular: 100.0)
        containerStackView.addArrangedSubview(titleLabel)
        return containerStackView
    }
}
