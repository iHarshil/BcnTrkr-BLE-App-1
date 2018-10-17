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
    var rssiNumbers = [NSNumber]()
    var centralManager = CBCentralManager()
    var blePeripheral : CBPeripheral!
    
    
    var timer = Timer()
    var characteristics = [String:CBCharacteristic]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        arrayPeripheralsList.removeAll()
        rssiNumbers.removeAll()
        print("Stop Scanning...")
        cancelScan()
    }
    
    // MARK - UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPeripheralsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellReuseIdentifier)
        }
        
        let peripheral = arrayPeripheralsList[indexPath.row]
        
        if let name = peripheral.name {
            cell?.textLabel?.text = name
        }
        else
        {
            cell?.textLabel?.text = "Unknown Device"
        }
        cell?.detailTextLabel?.text = peripheral.identifier.uuidString
        cell?.detailTextLabel?.numberOfLines = 2
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
//        connectToDevice()
        blePeripheral = arrayPeripheralsList[indexPath.row]
        let deviceDetailVC = storyboard?.instantiateViewController(withIdentifier: "deviceDetailVC") as! DeviceDetailViewController
        deviceDetailVC.peripheralDetails = arrayPeripheralsList[indexPath.row]
        deviceDetailVC.rSSINo = Int(truncating: rssiNumbers[indexPath.row])
        navigationController?.show(deviceDetailVC, sender: self)
    }
    
    @IBAction func btnScanTap(_ sender: UIBarButtonItem) {
        if sender.title == "SCAN" {
            arrayPeripheralsList.removeAll()
            rssiNumbers.removeAll()
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
            btnScan.isEnabled = false
        case .resetting:
            print("central.state is .resetting...")
            btnScan.isEnabled = false
        case .unsupported:
            print("central.state is .unsupported...")
            btnScan.isEnabled = false
        case .unauthorized:
            print("central.state is .unauthorized...")
            btnScan.isEnabled = false
        case .poweredOff:
            print("central.state is .poweredOff...")
            //If Bluetooth is off, display a UI alert message saying "Bluetooth is not enable" and "Make sure that your bluetooth is turned on"
            print("Bluetooth Disabled- Make sure your Bluetooth is turned on")
            btnScan.isEnabled = false
            let alertVC = UIAlertController(title: "Bluetooth is not enabled", message: "Make sure that your bluetooth is turned on", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        case .poweredOn:
            btnScan.isEnabled = true
            print("central.state is .poweredOn...")
            btnScan.title = "STOP"
            startScan()
        }
    }
    
    func startScan() {
        print("Now Scanning...")
        self.timer.invalidate()
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        Timer.scheduledTimer(timeInterval: 12, target: self, selector:#selector(cancelScan), userInfo: nil, repeats: false)
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
        SVProgressHUD.show(withStatus: "Scanning...")
        blePeripheral = peripheral
        arrayPeripheralsList.append(peripheral)
        rssiNumbers.append(RSSI)
        tableView.reloadData()
        
        if blePeripheral == nil {
            print("Found new peripheral devices with services")
            print("Peripheral name: \(peripheral.name as String?)")
            print("Peripheral id: \(peripheral.identifier)")
            print("RSSI Number: \(RSSI)")
            print("**********************************")
            print ("Advertisement Data : \(advertisementData)")
        }
        
//        centralManager.connect(peripheral, options: nil)
    }
    
//    Connection
    func connectToDevice() {
        SVProgressHUD.show(withStatus: "Connecting...")
        centralManager.connect(blePeripheral!, options: nil)
    }
    /*
     Invoked when a connection is successfully created with a peripheral.
     This method is invoked when a call to connect(_:options:) is successful. You typically implement this method to set the peripheral’s delegate and to discover its services.
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        SVProgressHUD.showSuccess(withStatus: "Connected Successfully!")
        print("Connected")
        print("*****************************")
        print("Connection complete")
        print("Peripheral info: \(blePeripheral!))")
        
        //Stop Scan- We don't need to scan once we've connected to a peripheral. We got what we came for.
        cancelScan()
        
        peripheral.discoverServices([CBUUID(nsuuid: blePeripheral!.identifier)])
        
        //Once connected, move to new view controller to manager incoming and outgoing data
        let deviceDetailVC = storyboard?.instantiateViewController(withIdentifier: "deviceDetailVC") as! DeviceDetailViewController
        deviceDetailVC.peripheralDetails = blePeripheral
        navigationController?.show(deviceDetailVC, sender: self)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
}

extension ViewController : CBPeripheralDelegate
{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("*******************************************************")
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return}
        
        for service in services {
            
            peripheral.discoverCharacteristics(nil, for: service)
            print("Service",service)
        }
        print("Discovered Services")
    }
}
