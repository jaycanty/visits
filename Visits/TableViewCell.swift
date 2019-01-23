//
//  TableViewCell.swift
//  Visits
//
//  Created by jay on 1/21/19.
//  Copyright © 2019 jay. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    var visit: Visit? {
        didSet {
            display()
        }
    }
    
    func display() {
        if let visit = visit {
            var log = ""
            if let placemark = visit.placemark {
                log = String(format: "%@, %@\nARRIVAL - %@\nDEPARTURE - %@",
                             placemark.subAdministrativeArea ?? "unknown",
                             placemark.administrativeArea ?? "unknow",
                             visit.visit.arrivalDate.description(with: NSLocale.current),
                             visit.visit.departureDate.description(with: NSLocale.current))
            } else {
                log = String(format: "%d, %d\nARRIVAL - %@\nDEPARTURE - %@",
                             visit.visit.coordinate.latitude,
                             visit.visit.coordinate.longitude,
                             visit.visit.arrivalDate.description(with: NSLocale.current),
                             visit.visit.departureDate.description(with: NSLocale.current))
            }
            label.text = log
        }
    }
}
