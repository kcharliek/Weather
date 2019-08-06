//
//  MainViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pageControl: WeatherPageControl!

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupController()
    }

    // MARK: - action

    @IBAction func onClickGithubButton(_ sender: Any) {
        let urlString = "https://github.com/ChanHeeKim1/Weather"
        guard let url = URL(string: urlString) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
 
    @IBAction func onClickCityListButton(_ sender: Any) {
        let vc = CityTableViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - private

    private let pageViewController = MainPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    private func setupController() {
        self.view.backgroundColor = .blue
        self.setupPageControl()
        self.setupPageViewController()
        self.setupWeatherPages()
    }

    func setupFollowingPlacemarkPage() {
        let cities: [Placemark] = Defaults.value(forKey: .cities) ?? []
        cities.forEach(self.addPage)
    }

    private func setupPageViewController() {
        self.pageViewController.mainDelegate = self

        self.addChild(self.pageViewController)
        self.containerView.addSubview(self.pageViewController.view)
        self.pageViewController.view.autoPinEdgesToSuperview()
        self.pageViewController.didMove(toParent: self)
    }

    private func setupWeatherPages() {
        LocationManager.shared.requestCurrentPlacemark { [weak self] (result) in
            guard let self = self else { return }
            result.handleSuccess(self.addPage)

            self.setupFollowingPlacemarkPage()
        }
    }

    private func setupPageControl() {
        self.pageControl.numberOfPages = 0
        self.pageControl.currentPage = 0
    }

    private func addPage(with placemark: Placemark) {
        self.pageViewController.addPage(for: placemark)
        self.pageControl.numberOfPages += 1
    }

    private func removePage(with placemark: Placemark) {
        self.pageViewController.removePage(for: placemark)
        self.pageControl.numberOfPages -= 1
    }

    private func selectPage(with placemark: Placemark) {
        self.pageViewController.selectPage(for: placemark)
    }

}


extension MainViewController: CityTableViewControllerDelegate {

    func cityTableViewController(_ controller: CityTableViewController, didAddCity city: Placemark) {
        self.addPage(with: city)
    }

    func cityTableViewController(_ controller: CityTableViewController, didRemoveCity city: Placemark) {
        self.removePage(with: city)
    }

    func cityTableViewController(_ controller: CityTableViewController, didSelectCity city: Placemark) {
        self.selectPage(with: city)
    }

}

extension MainViewController: MainPageViewControllerDelegate {

    func mainPageViewController(_ mainPageViewController: MainPageViewController, didChangeIndex index: Int) {
        self.pageControl.currentPage = index
    }

}
