//
//  Viruses.swift
//  SpreadCut
//
//  Created by apple on 02.07.21.
//

import Foundation
import MapKit
import UIKit

class Viruses: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String
    var image: UIImage
    var carrier: String
    init(title:String, coordinate:CLLocationCoordinate2D, info: String, image: UIImage, carrier:String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.image = image
        self.carrier = carrier
    }
}
