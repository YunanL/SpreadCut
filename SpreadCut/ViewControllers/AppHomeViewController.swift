//
//  AppHomeViewController.swift
//  SpreadCut
//
//  Created by apple on 24.06.21.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class AppHomeViewController: UIViewController,logoutDelegate{
    
    let uid = Auth.auth().currentUser!.uid
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var vaccinationView: UIView!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var vacButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let exposureActiveIcons:[String] = ["circle.grid.cross.left.fill","circle.grid.cross.up.fill","circle.grid.cross.right.fill","circle.grid.cross.down.fill"]
    let locationManager = CLLocationManager()
    @IBOutlet weak var exposureButton: UIButton!
    @IBOutlet weak var riskView: UIView!
    @IBOutlet weak var riskLevelLabel: UILabel!
    @IBOutlet weak var exposureView: UIView!
    @IBOutlet weak var exposureDetailLabel: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    var riskCarrier: [String] = []
    var highRiskCarrier: [String] = []
    let tool = Tools()
    var reports:[String] = []
    var riskContacts:[String:[Double]] = [:]
    var exposures:[Exposure] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        exposureView.layer.cornerRadius = 15
        riskView.layer.cornerRadius = 15
        testView.layer.cornerRadius = 15
        vaccinationView.layer.cornerRadius = 15
        testButton.layer.cornerRadius = 10
        vacButton.layer.cornerRadius = 10
        mapView.layer.cornerRadius = 15
        
        getReport {
            print(self.reports)
            self.fetchReports(reports: self.reports){ [self] in
                print(self.exposures)
                self.showRiskExposes()
            }
        }
        var i = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if i<4 {
                self.exposureButton.setImage(UIImage(systemName: self.exposureActiveIcons[i]), for: .normal)
            }
            i+=1
            if i == 4{
                i = 0
            }
        }
    }
    
   
    
    @IBAction func riskDetailButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToRisk", sender: self)
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToMap", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToRisk" {
            let destinationVC = segue.destination as! RiskDetailsViewController
            
            destinationVC.exposures = self.exposures
        }
        
        if segue.identifier == "HomeToSystem" {
            let destinationVC = segue.destination as! SystemViewController
            destinationVC.delegate = self
        }
    }
    @IBAction func editeStatusButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToStatus", sender: self)
    }
    
    @IBAction func reportButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToReport", sender: self)
    }
    
    @IBAction func systemButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToSystem", sender: self)
    }
    
   
    
}

extension AppHomeViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}

extension AppHomeViewController {
    func getReport (completion: @escaping () -> Void){
        Firestore.firestore().collection("InfectedUsers").getDocuments { QuerySnapshot, Error in
            if let err = Error{
                print(err)
            }
            else{
                self.reports = []
                
                for doc in QuerySnapshot!.documents{
                    let data = doc.data()
                    if let uid = data["uid"] as? String
                    {
                        self.reports.append(uid)
                    }
                }
            }
            completion()
        }
    }
    
    func fetchReports(reports:[String],completion: @escaping ()-> Void){
        Firestore.firestore().collection("Users").document(self.uid).collection("CloseContactsCopy").getDocuments { QuerySnapshot, Error in
            if let err = Error{
                print(err)
            }
            else{
                
                for contacts in QuerySnapshot!.documents{
                    let contactPerson = contacts.documentID
                    print(contactPerson)
                    if self.reports.contains(contactPerson){
                        
                        Firestore.firestore().collection("Users").document(self.uid).collection("CloseContacts").document(contactPerson).collection("ContactTimes").getDocuments { QuerySnapshot, Error in
                            if let err = Error {
                                print(err)
                            }
                            else{
                                var sumDuration:Double = 0.0
                                var averageDistance:Double = 0.0
                                var sumDistance:Double = 0.0
                                var minDistance: Int = 100
                                var lastContactTimeStamp:Double = 0.0
                                self.riskContacts[contactPerson] = []
                                
                                for doc in QuerySnapshot!.documents{
                                    let data = doc.data()
                                    if let duration = data["contactDuration"] as? Double,
                                       let distance = data["contactDistance"] as? Double,
                                       let contactTimeStamp = data["contactBeginnTime"] as? Double
                                    {
                                        sumDistance += distance * duration
                                        sumDuration += duration
                                        minDistance = min(minDistance,Int(distance))
                                        lastContactTimeStamp = max(lastContactTimeStamp,contactTimeStamp)
//                                        self.riskContacts[uid]! += duration
//                                        print(self.riskContacts[uid]!)
//
                                    }
                                }
                                averageDistance = sumDistance/sumDuration
                                
                                self.riskContacts[contactPerson]!.append(sumDuration)
                                self.riskContacts[contactPerson]!.append(averageDistance)
                                let lastExpose: String = self.tool.convertTime1970ToDate(time1970: lastContactTimeStamp)
                                let exposure = Exposure(exposeAverageDistance:Int(averageDistance) , exposeClosestDistance: minDistance, exposeDuration: Int(sumDuration), lastExpose: lastExpose)
                                self.exposures.append(exposure)
                            }
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func showRiskExposes(){
        
        var sumRiskcontactDuration:Int = 0
        var riskExposes:Int = 0
        
        for exposure in self.exposures{
            sumRiskcontactDuration += exposure.exposeDuration
            riskExposes+=1
        }
        print(sumRiskcontactDuration)
        if sumRiskcontactDuration >= 1800{
            self.riskView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.riskLevelLabel.text = "High Risk"
            self.exposureDetailLabel.text = "\(riskExposes) "+"risk exposures"
            self.updateTime.text = self.tool.convertTime1970ToDate(time1970: Date().timeIntervalSince1970)
        } else if sumRiskcontactDuration >= 30 {
            self.riskView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.riskLevelLabel.text = "Risk"
            self.exposureDetailLabel.text = "\(riskExposes) "+"risk exposures"
            self.updateTime.text = self.tool.convertTime1970ToDate(time1970: Date().timeIntervalSince1970)
        } else{
            self.riskView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            self.riskLevelLabel.text = "Low Risk"
            self.exposureDetailLabel.text = "No exposures"
            self.updateTime.text = "Just Now"
        }
    }
}

