//
//  RKLocationCheckViewController.swift
//  fourspoon
//
//  Created by Ryan Kotzebue on 11/3/17.
//  Copyright © 2017 Ryan Kotzebue. All rights reserved.
//

import UIKit
import CoreLocation

class RKLocationCheckViewController: UIViewController, CLLocationManagerDelegate {
    
    fileprivate let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location enabled")
        default:
            print("Location not enabled")
            self.dismiss(animated: true, completion: nil)
            break
        }
    }

}
