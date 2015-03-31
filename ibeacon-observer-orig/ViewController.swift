//
//  ViewController.swift
//  ibeacon-observer-orig
//
//  Created by James Derry on 3/29/15.
//  Copyright (c) 2015 James Derry. All rights reserved.
//
// Code based on PubNub example found here, with several modifications: http://www.pubnub.com/blog/smart-ibeacon-communication-in-the-swift-programming-language/

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var found:UILabel?
    @IBOutlet var uuid:UILabel?
    @IBOutlet var major:UILabel?
    @IBOutlet var minor:UILabel?
    @IBOutlet var accuracy:UILabel?
    @IBOutlet var distance:UILabel?
    @IBOutlet var rssi:UILabel?
    
    var region = CLBeaconRegion()
    var manager = CLLocationManager()
    
    let uuidToObserve = NSUUID(UUIDString: "4A96EC51-10A7-45CC-BD5C-20AAA0F70DD7")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        region = CLBeaconRegion(proximityUUID: uuidToObserve, identifier: "com.jamesderry.littlethoryn")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startDetection(sender:UIButton) {
        let iosVersion = UIDevice.currentDevice().systemVersion
        let index = advance(iosVersion.startIndex, 1)
        if( iosVersion.substringToIndex(index).toInt() >= 8 ) {
            self.manager.requestAlwaysAuthorization()
        }
        
        self.manager.startMonitoringForRegion(region)
        self.found?.text = "starting monitor"
    }
    
    func reset() {
        
        self.found?.text = "no"
        self.uuid?.text = ""
        self.major?.text = ""
        self.minor?.text = ""
        self.accuracy?.text = "n/a"
        self.rssi?.text = "n/a"
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        self.found?.text = "scanning"
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
        self.found?.text = "possible match"
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        self.found?.text = "error"
        println(error)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        reset()
    }

    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if(beacons.count == 0){return}
        
        var beacon = beacons.last as CLBeacon
        
        if (beacon.proximity == CLProximity.Unknown) {
            self.distance?.text = "Unknown"
            reset()
            return
        } else if (beacon.proximity == CLProximity.Immediate) {
            self.distance?.text = "Immediate"
        } else if (beacon.proximity == CLProximity.Near) {
            self.distance?.text = "Near"
        } else if (beacon.proximity == CLProximity.Far) {
            self.distance?.text = "Far"
        }
        
        self.found?.text = "YES"
        self.uuid?.text = beacon.proximityUUID.UUIDString
        self.major?.text = "\(beacon.major)"
        self.minor?.text = "\(beacon.minor)"
        self.accuracy?.text = "\(beacon.accuracy)"
        self.rssi?.text = "\(beacon.rssi)"
    }
}

