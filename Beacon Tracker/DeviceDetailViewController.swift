//
//  DeviceDetailViewController.swift
//  Beacon Tracker
//
//  Created by macbook on 10/15/18.
//  Copyright © 2018 Teksun. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = "DetailCollectionCell"
    var titleText = ["Signal:", "Connection:", "Distance:", "Battery:", "Time:"]
    var peripheralDetails : CBPeripheral!
    var rSSINo = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIDevice.current.isBatteryMonitoringEnabled = true
        print(peripheralDetails)
    }
    
    func getConnectionStatus() -> String {
        var state = ""
        if peripheralDetails.state == .disconnected {
            state = "Disconnected"
        }
        else if peripheralDetails.state == .connected {
            state = "Connected"
        }
        else if peripheralDetails.state == .connecting {
            state = "Connecting"
        }
        else
        {
            state = "Disconnecting"
        }
        return state
    }
    func getDistance(rssi: Int) -> String {
        
        var strDistance = ""
        
        if rssi == Int(-1.0) {
            // -1.0 is passed back by the SDK to indicate an unknown distance
            strDistance = "Unknown"
        }
        else if rssi >= -40 {
            strDistance = "Immediate"
        }
        else if rssi < -40 && rssi >= -60 {
            strDistance = "Near"
        }
        else if rssi < -60 {
            strDistance = "Far"
        }
        return strDistance
    }
    func getCurrentDateTime() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        
        return formatter.string(from: currentDateTime)
    }
    
    func getCurrentBatteryLevel() -> Float {
        return UIDevice.current.batteryLevel
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionCell", for: indexPath) as! DetailCollectionCell
        
        cell.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
//        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        if indexPath.section == 0 {
            cell.lblTitle.text = titleText[indexPath.item]
            cell.lblDetail.text = String(format: "%d", rSSINo)
        }
        else
        {
            cell.lblTitle.text = titleText[indexPath.item + 1]
            switch indexPath.row {
                
            case 0:
                cell.lblDetail.text = getConnectionStatus()
            case 1:
                cell.lblDetail.text = getDistance(rssi: rSSINo)
            case 2:
                cell.lblDetail.text = String(format: "%.0f%%", getCurrentBatteryLevel() * 100)
            case 3:
                cell.lblDetail.text = getCurrentDateTime()
            default:
                break
            }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  32
        let collectionCellSize = collectionView.frame.size.width - padding
//        let cellWidth = collectionView.bounds.width
//        let cellHeight = collectionView.bounds.height
        if indexPath.section == 0 {
            
            return CGSize(width: collectionCellSize+16.0, height: collectionView.frame.size.height/2 * 0.50)
            
        }
        else
        {
            return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
        }
    }
    
    @IBAction func btnLocationTap(_ sender: UIBarButtonItem) {
        let deviceLocationVC = storyboard?.instantiateViewController(withIdentifier: "deviceLocationVC") as! DeviceLocationViewController
        
        navigationController?.show(deviceLocationVC, sender: self)
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
