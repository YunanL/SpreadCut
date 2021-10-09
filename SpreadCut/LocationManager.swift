//
//  LocationManager.swift
//  SpreadCut
//
//  Created by apple on 28.06.21.
//

import Foundation
import CoreLocation
//
//class LocationsManager:NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager()
//
//    let manager = CLLocationManager()
//
//    var completion:((CLLocation) -> Void)?
//
//    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)){
//        self.completion = completion
//        manager.requestWhenInUseAuthorization()
//        manager.delegate = self
//        manager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else{
//            return
//        }
//        completion?(location)
//        manager.startUpdatingLocation()
//    }
//}
