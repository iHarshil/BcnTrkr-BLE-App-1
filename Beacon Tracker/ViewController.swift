//
//  ViewController.swift
//  Beacon Tracker
//
//  Created by macbook on 10/13/18.
//  Copyright © 2018 Teksun. All rights reserved.
//

import UIKit

import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "cellID"
    
    var arrayPeripheralsList = Array<CBPeripheral>()
    var centralManager = CBCentralManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPeripheralsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?
        
        let peripheral = arrayPeripheralsList[indexPath.row]
        
        if let name = peripheral.name {
            cell?.textLabel?.text = name
        }
        else
        {
            cell?.textLabel?.text = "Unknown Device"
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    @IBAction func btnScanTap(_ sender: UIBarButtonItem) {
    }
}

extension ViewController : CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        
        case .unknown:
            print("central.state is .unknown...")
        case .resetting:
            print("central.state is .resetting...")
        case .unsupported:
            print("central.state is .unsupported...")
        case .unauthorized:
            print("central.state is .unauthorized...")
        case .poweredOff:
            print("central.state is .poweredOff...")
        case .poweredOn:
            print("central.state is .poweredOn...")
            
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let uniqueID = (advertisementData["kCBAdvDataManufacturerData"])
        {
            print("Unique ID\(uniqueID)")
        }
        print(peripheral)
        print(advertisementData)
        print("RSSI Number\(RSSI)")

        
//        centralManager.connect(peripheral, options: nil)
        
        arrayPeripheralsList.append(peripheral)
        tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        
        peripheral.discoverServices(nil)
    }
}

extension ViewController : CBPeripheralDelegate
{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
    }
}

