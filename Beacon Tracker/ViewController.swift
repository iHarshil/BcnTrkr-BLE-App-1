//
//  ViewController.swift
//  Beacon Tracker
//
//  Created by macbook on 10/13/18.
//  Copyright © 2018 Teksun. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnScan: UIBarButtonItem!
    
    let cellReuseIdentifier = "cellID"
    
    var arrayPeripheralsList = Array<CBPeripheral>()
    var centralManager = CBCentralManager()
    var blePeripheral : CBPeripheral?
    
    var timer = Timer()
    var characteristics = [String:CBCharacteristic]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
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
        cell?.detailTextLabel?.text = peripheral.identifier.uuidString
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let deviceDetailVC = storyboard?.instantiateViewController(withIdentifier: "deviceDetailVC") as! DeviceDetailViewController
        deviceDetailVC.peripheralDetails = arrayPeripheralsList[indexPath.row]
        navigationController?.show(deviceDetailVC, sender: self)
    }
    
    @IBAction func btnScanTap(_ sender: UIBarButtonItem) {
        if sender.title == "SCAN" {
            arrayPeripheralsList.removeAll()
            self.tableView.reloadData()
            startScan()
            sender.title = "STOP"
        }
        else
        {
            cancelScan()
        }
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
            //If Bluetooth is off, display a UI alert message saying "Bluetooth is not enable" and "Make sure that your bluetooth is turned on"
            print("Bluetooth Disabled- Make sure your Bluetooth is turned on")
            
            let alertVC = UIAlertController(title: "Bluetooth is not enabled", message: "Make sure that your bluetooth is turned on", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        case .poweredOn:
            print("central.state is .poweredOn...")
            
            startScan()
        }
    }
    
    func startScan() {
        print("Now Scanning...")
        SVProgressHUD.show(withStatus: "Please wait...")
        self.timer.invalidate()
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        Timer.scheduledTimer(timeInterval: 17, target: self, selector:#selector(cancelScan), userInfo: nil, repeats: false)
//        centralManager.scanForPeripherals(withServices: [BLEService_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        
    }
    
    /*We also need to stop scanning at some point so we'll also create a function that calls "stopScan"*/
    @objc func cancelScan() {
        self.centralManager.stopScan()
        SVProgressHUD.dismiss()
        print("Scan Stopped")
        print("Number of Peripherals Found: \(arrayPeripheralsList.count)")
        btnScan.title = "SCAN"
    }

    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        blePeripheral = peripheral
        arrayPeripheralsList.append(peripheral)
        tableView.reloadData()
        
        if blePeripheral == nil {
            print("Found new pheripheral devices with services")
            print("Peripheral name: \(peripheral.name as String?)")
            print("Peripheral id: \(peripheral.identifier)")
            print("RSSI Number: \(RSSI)")
            print("**********************************")
            print ("Advertisement Data : \(advertisementData)")
        }
        
//        centralManager.connect(peripheral, options: nil)
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

