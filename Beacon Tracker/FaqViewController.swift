//
//  FaqViewController.swift
//  Beacon Tracker
//
//  Created by macbook on 10/16/18.
//  Copyright © 2018 Teksun. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cellID"
    var arrayFAQ = ["1. Buy iBeacon (a small Bluetooth device for tracking.)", "2. Install the TEKT Track app on your iOS device.", "3. Now go to your iOS Settings, Tap privacy and choose Bluetooth Sharing.", "4. Make sure that Bluetooth is enabled. If it is enabled then tap Scan Devices.", "5. Choose the beacon device from the Bluetooth list of devices that are available. The device should appear a beacon UUID under Bluetooth devices. To get pairing tap on \"Connect\" button. Now your TEKT Track app is connected.", "6. Wait for a second and your misplaced items data will be displayed on screen which include following things:", "    • Distance: Near, Far or Immediate.", "   • Time when it was seen last time by your device.", "   • Status: In range or Out of range.", "   • If possible latest geo location and the address.", "   • Change location of history.", "   • To get more information about location of your lost valuables tap \"Show on map\"."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "How to use this Application?"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFAQ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellReuseIdentifier)
        }
        cell?.textLabel?.text = arrayFAQ[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
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
