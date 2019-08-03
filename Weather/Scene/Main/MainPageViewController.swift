//
//  MainPageViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class MainPageViewController: UIPageViewController {

    // MARK: - internal

    internal func addPage(_ page: UIViewController) {
        self.pages.append(page)
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - private

    private var pages: [UIViewController] = []

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

}
