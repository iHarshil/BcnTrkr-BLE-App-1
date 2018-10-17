//
//  DeviceLocationViewController.swift
//  Beacon Tracker
//
//  Created by macbook on 10/16/18.
//  Copyright © 2018 Teksun. All rights reserved.
//

import UIKit
import GoogleMaps

class DeviceLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var location = CLLocation()
    
    
    var arrayLocationHistory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        self.tableView.isHidden = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        segmentControl.addTarget(self, action: #selector(mapTypeChanged(segcontrol:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK:- Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        location = locations.last!
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
        mapView.camera = camera
        showMarker(position: camera.target)
    }
    
    func showMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = "You are here"
        marker.map = mapView
    }
    
    @objc func mapTypeChanged(segcontrol: UISegmentedControl) {
        switch segcontrol.selectedSegmentIndex {
        case 0:
            mapView.mapType = .normal
            mapView.isHidden = false
            tableView.isHidden = true
        case 1:
            mapView.mapType = .satellite
            mapView.isHidden = false
            tableView.isHidden = true
        case 2:
            mapView.mapType = .hybrid
            mapView.isHidden = false
            tableView.isHidden = true
        default:
//            mapView.isHidden = true
//            tableView.isHidden = false
            break
        }
    }
    
    // MARK: - UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLocationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "")
        }
        
        return cell!
    }
    
    @IBAction func btnBackTap(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DeviceLocationViewController: GMSMapViewDelegate
{
    
}
