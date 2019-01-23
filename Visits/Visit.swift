//
//  Visit.swift
//  Visits
//
//  Created by jay on 1/22/19.
//  Copyright © 2019 jay. All rights reserved.
//

import Foundation
import CoreLocation

class Visit: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    let visitKey = "Visit"
    let timestampKey = "Timestamp"
    let placemarkKey = "Placemark"
    var visit: CLVisit
    var timestamp: Date
    var placemark: CLPlacemark?
    
    init(visit: CLVisit, timestamp: Date, placeMark: CLPlacemark? = nil) {
        self.visit = visit
        self.timestamp = timestamp
        self.placemark = placeMark
    }
    
    required init?(coder aDecoder: NSCoder) {
        visit = aDecoder.decodeObject(of: CLVisit.self, forKey: visitKey)!
        timestamp = aDecoder.decodeObject(of: NSDate.self, forKey: timestampKey)! as Date
        placemark = aDecoder.decodeObject(of: CLPlacemark.self, forKey: placemarkKey)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(visit, forKey: visitKey)
        aCoder.encode(timestamp, forKey: timestampKey)
        if let pm = placemark {
            aCoder.encode(pm, forKey: placemarkKey)
        }
    }
}
