//
//  CitySearchViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


internal protocol CitySearchViewControllerDelegate: class {

    func citySearchViewController(_ citySearchViewController: CitySearchViewController, didSelectPlacemark placemark: Placemark)

}

class CitySearchViewController: UISearchController {

    // MARK: - factory method
    
    internal static func make() -> CitySearchViewController {
        let searchTableViewController = CitySearchTableViewController()
        let vc = CitySearchViewController(searchResultsController: searchTableViewController)
        vc.searchResultsUpdater = searchTableViewController
        vc.searchTableViewController = searchTableViewController
        searchTableViewController.didSelectPlacemarkAction = vc.didSelectPlacemark

        return vc
    }

    // MARK: - internal

    internal weak var citySearchDelegate: CitySearchViewControllerDelegate?

    // MARK: - private

    private var searchTableViewController: CitySearchTableViewController?

    private func didSelectPlacemark(_ placemark: Placemark) {
        self.citySearchDelegate?.citySearchViewController(self, didSelectPlacemark: placemark)
    }

}
