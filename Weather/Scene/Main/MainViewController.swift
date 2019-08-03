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

        self.view.backgroundColor = .blue

        self.pageControl.numberOfPages = 1
        self.pageControl.currentPage = 0

        LocationManager.shared.requestCurrentPlacemark {
            $0.handleSuccess({ (placemark) in
                ForecastCenter.shared.requestForecast(at: placemark, completion: {
                    $0.handleSuccess({ (forecast) in print(forecast) })
                      .handleFailure({ (error) in print(error) })
                })
            })
                .handleFailure({ print($0) })
        }
    }

    // MARK: - action

    @IBAction func onClickGithubButton(_ sender: Any) {

    }

    @IBAction func onClickCityListButton(_ sender: Any) {
        let vc = CityTableViewController()
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - private

    private var pageViewController: UIPageViewController?

}
