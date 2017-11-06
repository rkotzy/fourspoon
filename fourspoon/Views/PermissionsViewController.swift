//
//  PermissionsViewController.swift
//  fourspoon
//
//  Created by Ryan Kotzebue on 11/3/17.
//  Copyright © 2017 Ryan Kotzebue. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLocation

class PermissionsViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationRequestLabel : UILabel!
    var locationRequestButton : UIButton!
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        manager.delegate = self
        
        locationRequestLabel = UILabel(frame: CGRect(x: 20, y: view.frame.height/2-100, width: view.frame.width-40, height: 90))
        locationRequestLabel.textAlignment = .center
        locationRequestLabel.numberOfLines = 0
        
        locationRequestButton = UIButton(frame: CGRect(x: 40, y: view.frame.height/2, width: view.frame.width-80, height: 50))
        locationRequestButton.backgroundColor = .blue
        locationRequestButton.tintColor = .white
        
        view.addSubview(locationRequestLabel)
        view.addSubview(locationRequestButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                locationRequestLabel.text = "Enable location services to use this app"
                locationRequestButton.setTitle("Allow location access", for: .normal)
                locationRequestButton.addTarget(self, action: #selector(requestLocation), for: .touchUpInside)
            case .restricted, .denied:
                print("No access")
                locationRequestLabel.text = "You must enable location services to use this app"
                locationRequestButton.setTitle("Enable location access", for: .normal)
                locationRequestButton.addTarget(self, action: #selector(deeplinkToLocationSettings), for: .touchUpInside)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
            locationRequestLabel.text = "Enable location services to use this app"
            locationRequestButton.setTitle("Allow location access", for: .normal)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.dismiss(animated: true, completion: nil)
        default:
            print("Location still not enabled")
            break
        }
    }
    
    @objc func requestLocation() {
        Locator.requestAuthorizationIfNeeded(.whenInUse)
    }
    
    @objc func deeplinkToLocationSettings() {
        
    }

}
