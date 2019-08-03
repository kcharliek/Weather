//
//  CitySearchTableViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit
import MapKit


class CitySearchTableViewController: UITableViewController {

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
    }

    // MARK: - private

    private var matchingItems:[MKMapItem] = []
    private var mapView: MKMapView? = nil

    private func setupController() {
        self.registerTableViewCell()
    }

    private func registerTableViewCell() {
        self.tableView.register(CitySearchTableViewCell.self)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CitySearchTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CitySearchTableViewCell.self, for: indexPath)
        cell.setModel(self.matchingItems[safe: indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}


extension CitySearchTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard //let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
//        request.region = MKCoordinateRegion.init(center: <#T##CLLocationCoordinate2D#>, latitudinalMeters: <#T##CLLocationDistance#>, longitudinalMeters: <#T##CLLocationDistance#>)
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        })

    }

}
