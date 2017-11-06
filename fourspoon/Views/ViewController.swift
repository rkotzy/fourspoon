//
//  ViewController.swift
//  fourspoon
//
//  Created by Ryan Kotzebue on 11/3/17.
//  Copyright © 2017 Ryan Kotzebue. All rights reserved.
//

import UIKit
import SwiftLocation


class ViewController: RKLocationCheckViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var venueView: UIView!
    @IBOutlet weak var venueViewLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButtonClicked(_ sender: Any) {
        playButton.isEnabled = false
        shake()
    }
    
    var spinTimer = Timer()
    fileprivate var queryRows = queryArray.count
    fileprivate var radiusRows = radiusArray.count
    fileprivate var priceRows = priceArray.count
    fileprivate var venueId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fourspoon 🍽"
        
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // update the button
        playButton.backgroundColor = UIColor(red: 1.000, green: 0.800, blue: 0.290, alpha: 1.00)
        playButton.tintColor = .black
        playButton.layer.cornerRadius = 6
        
        // set up the venue label
        let tappedLabel = UITapGestureRecognizer(target: self, action: #selector(viewVenue))
        venueViewLabel.addGestureRecognizer(tappedLabel)
        venueViewLabel.layer.cornerRadius = 8
        venueViewLabel.backgroundColor = UIColor.groupTableViewBackground
        venueViewLabel.font = UIFont.boldSystemFont(ofSize: 18)
        venueViewLabel.clipsToBounds = true
        venueViewLabel.isUserInteractionEnabled = true
        
        shake()
    }
    
    @objc func viewVenue() {
        guard let url = URL(string: "https://www.foursquare.com/v/\(venueId)") else {
            return //be safe
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func shake() {
        
        venueViewLabel.text = nil
        venueViewLabel.isHidden = true
        
        spinTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(spinPicker), userInfo: nil, repeats: true)
        searchVenues()
    }

    
    @objc func spinPicker() {
        
        queryRows = 10000
        radiusRows = 10000
        priceRows = 10000
        pickerView.reloadAllComponents()
        
        pickerView.selectRow(pickerView.selectedRow(inComponent: 0)+5, inComponent: 0, animated: true)
        pickerView.selectRow(pickerView.selectedRow(inComponent: 1)+7, inComponent: 1, animated: true)
        pickerView.selectRow(pickerView.selectedRow(inComponent: 2)+9, inComponent: 2, animated: true)
    }
    
    func resetPicker() {
        queryRows = queryArray.count
        radiusRows = radiusArray.count
        priceRows = priceArray.count
        pickerView.reloadAllComponents()
        
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.selectRow(0, inComponent: 1, animated: false)
        pickerView.selectRow(0, inComponent: 2, animated: false)
    }
    
    func searchVenues() {
        
        Locator.currentPosition(accuracy: .block, onSuccess: { (location) -> (Void) in
            print("Location found: \(location)")
            
            let query = queryArray[max(Int(arc4random_uniform(UInt32(queryArray.count)))-1,0)]
            
            FoursquareManager.sharedManager().findVenuesWith(coordinate: location.coordinate, query: query.id, radius: 8000, price: ["1","2","3","4"], completion: { (error) in
                if error == nil {
                    
                    self.spinTimer.invalidate()
                    self.resetPicker()
                    self.playButton.isEnabled = true
                                        
                    let venueArrayCount = FoursquareManager.sharedManager().venues.count-1
                    var venue : Venue!
                    if venueArrayCount > 0 {
                        venue = FoursquareManager.sharedManager().venues[Int(arc4random_uniform(UInt32(venueArrayCount)))]
                    } else {
                        return
                    }
                    
                    
                    
                    self.venueId = venue.venueId ?? ""
                    self.venueViewLabel.text = venue.name ?? ""
                    self.venueViewLabel.isHidden = false
                    
                    let distance = Int(venue.distance ?? "0") ?? 0
                    let price = venue.price ?? priceArray[0].id
                    
                    var r = 0
                    for radius in radiusArray {
                        if distance <= (Int(radius.id) ?? 0) {
                            break
                        }
                        r += 1
                    }
                    
                    self.pickerView.selectRow(queryArray.index(where: { $0.id == query.id } ) ?? 0, inComponent: 0, animated: false)
                    self.pickerView.selectRow(r, inComponent: 1, animated: false)
                    self.pickerView.selectRow(priceArray.index(where: { $0.id == price } ) ?? 0, inComponent: 2, animated: false)
                    
                    
                } else {
                    print(error)
                    self.spinTimer.invalidate()
                    self.resetPicker()
                    self.playButton.isEnabled = true
                }
            })
        }) { (err, last) -> (Void) in
            print("Failed to get location: \(err)")
            self.spinTimer.invalidate()
            self.resetPicker()
            self.playButton.isEnabled = true
        }
    }
    
    // MARK: - PickerView delegates
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return view.frame.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 64
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        if component == 0 {
            pickerLabel.text = queryArray[row % queryArray.count].display
            pickerLabel.font = UIFont.systemFont(ofSize: 60)
        } else if component == 1 {
            pickerLabel.text = radiusArray[row % radiusArray.count].display
            pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        } else {
            pickerLabel.text = priceArray[row % priceArray.count].display
            pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 40)
        }
        
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return queryRows
        } else if component == 1 {
            return radiusRows
        } else {
            return priceRows
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

}

