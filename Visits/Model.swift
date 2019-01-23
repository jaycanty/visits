//
//  Model.swift
//  Visits
//
//  Created by jay on 1/21/19.
//  Copyright © 2019 jay. All rights reserved.
//

import Foundation
import CoreLocation

class Model {
    static let shared = Model()
    private init() {
        if let data = UserDefaults.standard.object(forKey: key) as? Data,
            let vs = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Visit.self], from: data) as? [Visit] {
            visits = vs ?? [Visit]()
        }
    }
    let key = "VISIT-KEY"
    var visits = [Visit]()
    var update: (([Visit]) -> ())?
    
    func add(visit: Visit, update shouldUpdate: Bool = true, save shouldSave: Bool = true) {
        visits.append(visit)
        if let update = update, shouldUpdate {
            DispatchQueue.main.async {
                update(self.visits)
            }
        }
        if shouldSave {
            save()
        }
    }
    
    func register(updater: @escaping ([Visit])->()) {
        update = updater
    }
    
    func unregister() {
        update = nil
    }
    
    private func save() {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: visits, requiringSecureCoding: false) {
           UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func printVisits() {
        for visit in visits {
            var log = ""
            if let placemark = visit.placemark {
                log = String(format: "%@ - %@, %@\nARRIVAL - %@\nDEPARTURE - %@",
                             placemark.thoroughfare ?? "unkown",
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
            print(log)
        }
    }
}
