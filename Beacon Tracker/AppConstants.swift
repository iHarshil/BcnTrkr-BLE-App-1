//
//  AppConstants.swift
//  Beacon Tracker
//
//  Created by macbook on 10/15/18.
//  Copyright © 2018 Teksun. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreBluetooth

class AppConstants: NSObject {

    static let sharedInstance = AppConstants()
    
    var centralManager = CBCentralManager()
    var blePeripheral : CBPeripheral?
    
}
