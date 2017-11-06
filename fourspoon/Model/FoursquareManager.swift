//
//  FoursquareManager.swift
//  Fourchat
//
//  Created by Ryan Kotzebue on 10/4/16.
//  Copyright © 2016 Ryan Kotzebue. All rights reserved.
//

import UIKit
import MapKit
import FoursquareAPIClient
import SwiftyJSON

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

class FoursquareManager: NSObject {

    var venues = [Venue]()
    let client = FoursquareAPIClient(clientId: "CLIENT_ID", clientSecret: "CLIENT_SECRET")


    class func sharedManager() -> FoursquareManager {
        
        struct Static {
            static let instance = FoursquareManager()
        }
        return Static.instance
    }

    func findVenuesWith(coordinate: CLLocationCoordinate2D, query: String, radius: Int, price: [String], completion: ((Error?) -> ())?) {
    
        
        let parameter: [String: String] = [
            "query": query,
            "ll": "\(coordinate.latitude),\(coordinate.longitude)",
            "radius": String(radius),
            "price": price.joined(separator: ","),
            "openNow": "1",
            "venuePhotos": "1",
            "limit" : "5"
        ];
        
        client.request(path: "venues/explore", parameter: parameter) { result in
            
            switch result {
            case let .success(data):
                
                do {
                    let json = try JSON(data: data)
                    self.venues = (self.parseVenues(json["response"]["groups"][0]["items"]))
                    completion?(nil)
                } catch {
                    completion?("Invalid JSON".errorDescription)
                }
                
            case let .failure(error):
                // Error handling
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                    completion?(connectionError)
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                    completion?(apiError)
                }
            }
        }
    }


    fileprivate func parseVenues(_ venuesJSON: JSON) -> [Venue] {

        var venues = [Venue]()

        for (key: _, venueJSON: JSON) in venuesJSON {
            venues.append(Venue(json: JSON["venue"]))
        }

        return venues
    }
    
}
