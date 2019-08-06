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

    internal func addPage(for model: Placemark) {
        let weatherViewController = WeatherViewController.loadFromNib()
        weatherViewController.model = model
        self.pages.append(weatherViewController)
        self.reloadData()
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
        self.mainDelegate?.mainPageViewController(self, didChangeIndex: _index)
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
    }

    // MARK: - private

    private var pages: [UIViewController] = []
    private var nextIndex: Int = 0

    private func reloadData() {
        if pages.count == 1 {
            self.setViewControllers([self.pages.first!], direction: .forward, animated: false, completion: nil)
        }
    }

}

extension MainPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index: Int = self.pages.index(of: viewController) else {
            return nil
        }

        return self.pages[safe: index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index: Int = self.pages.index(of: viewController) else {
            return nil
        }

        return self.pages[safe: index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard
            let first = pendingViewControllers.first,
            let index: Int = self.pages.index(of: first)
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
