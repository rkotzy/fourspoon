//
//  InitialViewController.swift
//  fourspoon
//
//  Created by Ryan Kotzebue on 11/3/17.
//  Copyright © 2017 Ryan Kotzebue. All rights reserved.
//

import UIKit
import CoreLocation

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // make sure permissions are granted
        
        var vc : UIViewController!
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                vc = PermissionsViewController()
            case .authorizedAlways, .authorizedWhenInUse:
                vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UINavigationController
            }
        } else {
            vc = PermissionsViewController()
        }
        
        present(vc, animated: true, completion: nil)
        
    }
}
