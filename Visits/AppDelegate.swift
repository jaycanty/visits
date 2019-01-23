//
//  AppDelegate.swift
//  Visits
//
//  Created by jay on 1/21/19.
//  Copyright © 2019 jay. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager.init()
    var bgTask: UIBackgroundTaskIdentifier?
    let geocoder = CLGeocoder()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startMonitoringVisits()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager.startMonitoringVisits()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        record(visit: visit)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
    }
    
    func record(visit: CLVisit) {
        if !isInForeground() {
            startBGTask(visit: visit)
        }
        geo(visit: visit) { visitWrap in
            Model.shared.add(visit: visitWrap)
            if !self.isInForeground() {
                self.endBGTask()
            }
        }
    }
    
    func geo(visit: CLVisit, complete: @escaping (Visit) -> ()) {
        DispatchQueue.global().async {
            let location = CLLocation(coordinate: visit.coordinate,
                                      altitude: 0,
                                      horizontalAccuracy: visit.horizontalAccuracy,
                                      verticalAccuracy: 0,
                                      course: 0,
                                      speed: 0,
                                      timestamp: Date())
            self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                var visitWrap = Visit(visit: visit, timestamp: Date())
                if error == nil {
                    if let placemark = placemarks?.first {
                        visitWrap = Visit(
                            visit: visit,
                            timestamp: Date(),
                            placeMark: placemark)
                    }
                }
                complete(visitWrap)
            }
        }
    }
    
    func startBGTask(visit: CLVisit) {
        bgTask = UIApplication.shared.beginBackgroundTask(withName: "BG", expirationHandler: {
            if self.geocoder.isGeocoding {
                self.geocoder.cancelGeocode()
                let v = Visit(visit: visit, timestamp: Date())
                Model.shared.add(visit: v, update: false, save: false)
            }
            self.endBGTask()
        })
    }
    
    func endBGTask() {
        if let task = bgTask {
            UIApplication.shared.endBackgroundTask(task)
        }
        bgTask = UIBackgroundTaskIdentifier.invalid
    }
    
    func isInForeground() -> Bool {
        return UIApplication.shared.applicationState == .active
    }
}
