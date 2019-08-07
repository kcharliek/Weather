//
//  MainPageViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


protocol MainPageViewControllerDelegate: class {

    func mainPageViewController(_ mainPageViewController: MainPageViewController, didChangeIndex index: Int)

}

class MainPageViewController: UIPageViewController {

    // MARK: - internal

    internal weak var mainDelegate: MainPageViewControllerDelegate?

    internal func setupCurrentWeatherPage() {
        guard self.currentWeatherPage == nil else {
            return
        }
        let currentWeatherPage = WeatherViewController.loadFromNib()
        self.pages.append(currentWeatherPage)
        self.setViewControllers([currentWeatherPage], direction: .forward, animated: false, completion: nil)
    }

    internal func addPage(for model: Placemark) {
        let weatherViewController = WeatherViewController.loadFromNib()
        weatherViewController.set(model: model)
        self.pages.append(weatherViewController)
    }

    internal func removePage(for model: Placemark) {
        let index = self.pages
                        .compactMap { $0 as? WeatherViewController }
                        .firstIndex { $0.model == model }
        guard let _index = index else {
            return
        }

        self.pages.remove(at: _index)
    }

    internal func selectPage(for model: Placemark) {
        let index = self.pages
                        .compactMap { $0 as? WeatherViewController }
                        .firstIndex { $0.model == model }
        guard let _index = index, let target = self.pages[safe: _index] else {
            return
        }

        self.setViewControllers([target], direction: .forward, animated: false, completion: nil)
        self.scrollToTopAllPage()

        self.mainDelegate?.mainPageViewController(self, didChangeIndex: _index)
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupPageViewController()
        self.registerNotification()
    }

    // MARK: - private

    private var pages: [UIViewController] = []
    private var nextIndex: Int = 0
    private var currentWeatherPage: WeatherViewController? {
        return self.pages.first as? WeatherViewController
    }

    private func setupPageViewController() {
        self.dataSource = self
        self.delegate = self
    }

    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleDidChangeCurrentLocationNotification(_:)), name: .didChangeCurrentLocation, object: nil)
    }

    @objc
    private func handleDidChangeCurrentLocationNotification(_ notification: Notification) {
         guard let updatedPlacemark = notification.object as? Placemark else {
            return
        }

        self.currentWeatherPage?.set(model: updatedPlacemark)
    }

    private func reloadData() {
        if pages.count == 1 {
            self.setViewControllers([self.pages.first!], direction: .forward, animated: false, completion: nil)
        }
    }

    private func scrollToTopAllPage() {
        self.pages
            .compactMap { $0 as? WeatherViewController }
            .forEach { $0.scrollToTop() }
    }

}

extension MainPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index: Int = self.pages.firstIndex(of: viewController) else {
            return nil
        }

        return self.pages[safe: index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index: Int = self.pages.firstIndex(of: viewController) else {
            return nil
        }

        return self.pages[safe: index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard
            let first = pendingViewControllers.first,
            let index: Int = self.pages.firstIndex(of: first)
        else {
            return
        }

        self.nextIndex = index
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed {
            self.mainDelegate?.mainPageViewController(self, didChangeIndex: self.nextIndex)
        }
    }

}

