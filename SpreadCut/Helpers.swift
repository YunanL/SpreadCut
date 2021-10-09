//
//  Helpers.swift
//  SpreadCut
//
//  Created by apple on 22.06.21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Firebase
import grpc

class Tools{
    
    public func editeButtonRadius(button:UIButton){
        button.layer.cornerRadius = button.frame.size.height/2
    }
    public func hightleightButton(button: UIButton){
        button.backgroundColor = #colorLiteral(red: 0.2269556133, green: 0.4482949511, blue: 0.7374328459, alpha: 1)
        button.setTitleColor(.white, for: .normal)
    }
    public func disleightButton(button: UIButton){
        button.backgroundColor = .none
        button .setTitleColor(#colorLiteral(red: 0.2269556133, green: 0.4482949511, blue: 0.7374328459, alpha: 1), for: .normal)
    }
    public func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) -> String{
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        var address = "address"
        let lat: Double = pdblLatitude
        let lon: Double = pdblLongitude
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                    let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country!)
                    print(pm.locality!)
                    print(pm.subLocality!)
                    print(pm.thoroughfare!)
                    print(pm.postalCode!)
                    print(pm.subThoroughfare!)
                    var addressString : String = ""
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + " "
                    }
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }

                    address = addressString
                } else{
                    address = "Unknown Address"
                }
        })
        return address
        }
    public func constraintView(view:UIView, toView:UIView, leadingAnchor: CGFloat, trailingAnchor: CGFloat, topAnchor: CGFloat, bottomAnchor:CGFloat){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: toView.leadingAnchor,constant: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: toView.trailingAnchor,constant: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: toView.topAnchor, constant: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: bottomAnchor).isActive = true
    }
    func getCurrentTime()->String{
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let time = String(hour)+":"+String(minutes)+", "+String(day)+"."+String(month)+".2021"
        return time
    }
    func convertCLL2dToCLL(cll2d:CLLocationCoordinate2D) ->CLLocation{
        let location:CLLocation = CLLocation(latitude: cll2d.latitude, longitude: cll2d.longitude)
        return location
    }
    
    func getDistanceBetweenKoordinate(k1:CLLocationCoordinate2D,k2:CLLocationCoordinate2D) ->Int{
        let l1:CLLocation = CLLocation(latitude: k1.latitude, longitude: k1.longitude)
        let l2:CLLocation = CLLocation(latitude: k2.latitude, longitude: k2.longitude)
        return Int(l1.distance(from: l2))
    }
    func uploadRiskLocation(coordinate:CLLocationCoordinate2D,virusType:String,distance:Int,carrier:String,duration:Int){
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("RiskLocation").document(carrier).setData(
            ["latitude":Float(coordinate.latitude),
             "longitude":Float(coordinate.longitude),
             "timeStamp":Date().timeIntervalSince1970,
             "virusType":virusType,
             "exposeDuration":duration,
             "exposeDistance":distance,
             "carrier":carrier
            ])
    }
    
    func updateRiskLocationDuration(carrier:String,duration:Int){
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("RiskLocation").document(carrier).updateData([
            "exposeDuration":duration
        ])
    }
    
    func uploadHighRiskLocation(coordinate:CLLocationCoordinate2D,virusType:String,distance:Int,carrier:String,duration:Int){
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("HighRiskLocation").document(carrier).setData(
            ["latitude":Float(coordinate.latitude),
             "longitude":Float(coordinate.longitude),
             "timeStamp":Date().timeIntervalSince1970,
             "virusType":virusType,
             "exposeDuration":duration,
             "exposeDistance":distance,
             "carrier":carrier
            ])
    }
    
    func updateHighRiskLocationDuration(carrier:String,duration:Int){
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("HighRiskLocation").document(carrier).updateData([
            "exposeDuration":duration
        ])
    }
    
    func updateContactDuration(uid:String, beginTimeStamp:Double, distance:Int, duration: Double){
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("CloseContacts").document(uid).collection("ContactTimes").document(String(beginTimeStamp)).updateData([
            "contactDuration" : duration,
            "contactDistance" : distance
        ])
    }
    
    func createContactList(uid:String, beginTimeStamp:Double, distance:Int, duration:Double){
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("CloseContacts").document(uid).collection("ContactTimes").document(String(beginTimeStamp)).setData([
            "contactUid" : uid,
            "contactBeginnTime" : beginTimeStamp,
            "contactDuration" : duration,
            "contactDistance" : distance
        ])
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("CloseContactsCopy").document(uid).setData([
            "contactUid" : uid
        ])
    }
    
    func uploadReport(reportTime:Double,syptomDate:Double,uid:String, completion: @escaping () -> Void){
        Firestore.firestore().collection("InfectedUsers").document(uid).setData([
            "uid": uid,
            "reportTime": reportTime,
            "syptomDate": syptomDate
        ])
        completion()
    }
    
    
    func convertTime1970ToDate(time1970:Double) -> String{
        let date = Date(timeIntervalSince1970: time1970)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.medium 
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    func uploadLocationToDatabase(uid:String,coordinate:CLLocationCoordinate2D){
        Firestore.firestore().collection("Location").document(uid).setData([
            "uid":uid,
            "latitude":Float(coordinate.latitude),
            "longituede":Float(coordinate.longitude)
            ])
    }
    
    func getLocationFromDatabase()->[Locations]{
        var locations:[Locations] = []
        Firestore.firestore().collection("Location").addSnapshotListener { (QuerySnapshot,Error) in
            if let err = Error {
                print(err)
            }
            else{
                
                for doc in QuerySnapshot!.documents {
                    let data = doc.data()
                    let uid = data["uid"] as? String ?? "uid"
                    let latitude = data["latitude"] as? Float ?? 0
                    let longitude = data["longitude"] as? Float ?? 0
                    let newlocation = Locations(uid: uid, latitude: latitude, longitude: longitude)
                    locations.append(newlocation)
                }
            }
        }
        return locations
    }
    
    func uploadInfectionStatus(uid:String,infectionStatus:Bool,infectionDuration:Int,infectionVirus:String){
        Firestore.firestore().collection("Users").document(uid).collection("InfectionStatus").document("InfectionStatus").setData([
            "infectionStatus":infectionStatus,
            "infectionDuration":infectionDuration,
            "infectionVirus":infectionVirus
        ])
    }
    
    func getInfectedUsers()->[String]{
        var infectedUsers:[String] = []
        Firestore.firestore().collection("InfectedUsers").getDocuments { QuerySnapshot, Error in
            if let err = Error{
                print(err)
            }
            else{
                for doc in QuerySnapshot!.documents{
                    let data = doc.data()
                    if let uid = data["uid"] as? String
                    {
                        infectedUsers.append(uid)
                    }
                }
            }
        }
        return infectedUsers
    }
  
}
