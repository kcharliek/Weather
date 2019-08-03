//
//  WeatherPageControl.swift
//  Weather
//
//  Created by ChanHee Kim on 03/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


private enum Constant {

    static let currentLocationPageWidth: CGFloat = 14
    static let normalPageWidth: CGFloat = 7
    static let spacing: CGFloat = 5
    static let currentPageColor: UIColor = .white
    static let tintColor: UIColor = UIColor(r: 255, g: 255, b: 255, a: 0.5)

}


internal class WeatherPageControl: UIView {

    // MARK: - internal

    internal var numberOfPages: Int = 0 {
        didSet {
            self.setupView()
        }
    }

    internal var currentPage: Int = 0 {
        didSet {
            self.selectPage(currentPage)
        }
    }

    // MARK: - init

    internal init() {
        super.init(frame: .zero)
        self.initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }

    private func initView() {
        self.addSubview(self.stackView)
        self.isUserInteractionEnabled = false

        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    // MARK: - private

    private let stackView: UIStackView = UIStackView(frame: .zero)

    private func selectPage(_ page: Int) {
        guard page < self.stackView.arrangedSubviews.count else {
            return
        }

        self.stackView.arrangedSubviews
                        .compactMap { $0 as? UIView & Highlightable }
                        .forEach { $0.setHighlight($0.tag == page) }
    }

    private func setupView() {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard self.numberOfPages > 0 else {
            return
        }

        (0..<self.numberOfPages)
            .map(createPage)
            .forEach(self.stackView.addArrangedSubview)

        self.stackView.axis = .horizontal
        self.stackView.distribution = .equalSpacing
        self.stackView.alignment = .center
        self.stackView.spacing = Constant.spacing
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func createPage(_ index: Int) -> UIView {
        let result = index == 0 ?
            self.createCurrentLocationPage() : self.createNormalPage()
        result.tag = index
        return result
    }

    private func createCurrentLocationPage() -> UIView & Highlightable {
        let result = HighlightImageView(frame: .zero)

        result.normalColor = Constant.tintColor
        result.highlightedColor = Constant.currentPageColor
        result.setHighlight(false)

        let width = Constant.currentLocationPageWidth

        NSLayoutConstraint.activate([
            result.widthAnchor.constraint(equalToConstant: width),
            result.heightAnchor.constraint(equalTo: result.widthAnchor)
        ])

        result.image = Image.navigation

        return result
    }

    private func createNormalPage() ->  UIView & Highlightable {
        let result = HighlightView(frame: .zero)

        result.contentMode = .scaleAspectFill
        result.normalColor = Constant.tintColor
        result.highlightedColor = Constant.currentPageColor
        result.setHighlight(false)

        let width = Constant.normalPageWidth

        NSLayoutConstraint.activate([
            result.widthAnchor.constraint(equalToConstant: width),
            result.heightAnchor.constraint(equalTo: result.widthAnchor)
        ])

        result.layer.cornerRadius = width / 2
        result.layer.masksToBounds = true

        return result
    }

}

private protocol Highlightable {

    func setHighlight(_ isHighlighted: Bool)

}

private class HighlightView: UIView, Highlightable {

    func setHighlight(_ isHighlighted: Bool) {
        self.backgroundColor = isHighlighted ?
            (self.highlightedColor ?? self.normalColor) : self.normalColor
    }

    var normalColor: UIColor = .black
    var highlightedColor: UIColor?

}

private class HighlightImageView: UIImageView, Highlightable {

    func setHighlight(_ isHighlighted: Bool) {
        self.tintColor = isHighlighted ?
            (self.highlightedColor ?? self.normalColor) : self.normalColor
    }

    var normalColor: UIColor = .black
    var highlightedColor: UIColor?

}
