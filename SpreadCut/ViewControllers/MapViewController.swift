//
//  MapViewController.swift
//  SpreadCut
//
//  Created by apple on 28.06.21.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var regionRadius: Double = 500
    @IBOutlet weak var loadingView: UIView!
    let tool = Tools()
    @IBOutlet weak var loadingLabel: UILabel!
    var displayLink: CADisplayLink!
    @IBOutlet weak var alarmView: UIView!
    let corona1 = Viruses(title: "Exposedanger: Corona Virus", coordinate: CLLocationCoordinate2D(latitude: 51.509722, longitude: -0.1337), info: "CoronaVirus",image: UIImage(systemName: "aqi.medium")!, carrier: "112")
    let corona2 = Viruses(title: "Exposedanger: Corona Virus", coordinate: CLLocationCoordinate2D(latitude: 51.509722, longitude: -0.134), info: "CoronaVirus",image: UIImage(systemName: "aqi.medium")!, carrier: "113")
    let corona3 = Viruses(title: "Exposedanger: Corona Virus", coordinate: CLLocationCoordinate2D(latitude: 51.509722, longitude: -0.1342), info: "CoronaVirus",image: UIImage(systemName: "aqi.medium")!, carrier: "114")
    let corona4 = Viruses(title: "Exposedanger: Corona Virus", coordinate: CLLocationCoordinate2D(latitude: 51.509722, longitude: -0.1343), info: "CoronaVirus",image: UIImage(systemName: "aqi.medium")!, carrier: "115")
    let corona = Viruses(title: "Exposedanger: Corona Virus", coordinate: CLLocationCoordinate2D(latitude: 51.509222, longitude: -0.1335), info: "CoronaVirus",image: UIImage(systemName: "aqi.medium")!, carrier: "111")
    let saaz = Viruses(title: "Exposedanger: Sarz Virus", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1332), info: "SaazVirus",image: UIImage(systemName: "aqi.medium")!, carrier: "101")
    var pathogens: [Viruses] = []
    var riskCarrier: [String:Int] = [:]
    var highRiskCarrier: [String:Int] = [:]
    var locations: [Locations] = []
    var contactList: [String:Double] = [:]
    var infectedUsers: [String] = []
    private let AnnotationIdentifier = "Corona"
    let menuBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4087000556, green: 0.5646235694, blue: 0.8273525816, alpha: 1)
        return view
    }()
    let virusDetailBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4087000556, green: 0.5646235694, blue: 0.8273525816, alpha: 1)
        return view
    }()
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9768705964, green: 0.9613510966, blue: 0.9277829528, alpha: 1)
        return view
    }()
    let virusDetailView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9768705964, green: 0.9613510966, blue: 0.9277829528, alpha: 1)
        return view
    }()
    let cutLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    let scaleTitle: UILabel = {
        let title = UILabel()
        title.text = "Map Scale"
        title.textColor = .darkGray
        title.font = .boldSystemFont(ofSize: 16)
        return title
    }()
    let scaleButton100: UIButton = {
       let button = UIButton()
        button.setTitle("100m", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(#colorLiteral(red: 0.2269556133, green: 0.4482949511, blue: 0.7374328459, alpha: 1), for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action:#selector(m100ButtonPressed) , for: .touchUpInside)
        return button
    }()
    let scaleButton500: UIButton = {
       let button = UIButton()
        button.setTitle("500m", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2269556133, green: 0.4482949511, blue: 0.7374328459, alpha: 1)
        button.layer.cornerRadius = 15
        button.addTarget(self, action:#selector(m500ButtonPressed) , for: .touchUpInside)
        return button
    }()
    let scaleButton50: UIButton = {
       let button = UIButton()
        button.setTitle("50m", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(#colorLiteral(red: 0.2269556133, green: 0.4482949511, blue: 0.7374328459, alpha: 1), for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action:#selector(m50ButtonPressed) , for: .touchUpInside)
        return button
    }()
    let backMenuButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.2269556133, green: 0.4482949511, blue: 0.7374328459, alpha: 1)
        button.addTarget(self, action: #selector(backMenuButtonPressed), for:.touchUpInside)
        return button
    }()
    
    //VirusDetailViews
    let virusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textAlignment = .left
        button.layer.shadowColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 2.0
        button.layer.cornerRadius = 10.0
        return button
    }()
    let addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let closeButton:UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        button.tintColor = .blue
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(closeVirusButtonPressed), for: .touchUpInside)
        return button
    }()
    let cutLineVirusDetailView: UIView = {
        let view = UIView()
        return view
    }()
    let exposeAddressLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    let distanceView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        view.layer.shadowColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2.0
        return view
    }()
    let riskGradeLabel:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    let distanceDetailButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    //
    var screenWidth: CGFloat?
    var screenHeight: CGFloat?
    var span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    let locationManager = CLLocationManager()
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    var value: CGFloat = 0.0
    var invert: Bool = false
    
    @objc func handleAnimation(){
        invert ? (value -= 1) : (value+=1)
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(value/100)
        if value > 90 || value < 0{
            invert = !invert
        }
    }
    
    func showRiskView(){
        self.alarmView.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.1)
        self.loadingLabel.text = "Risk exists, keep updating"
        self.loadingLabel.textColor = .red
    }
    
    func unshowRiskView(){
        self.loadingLabel.text = "No Risk, keep updating"
        self.loadingLabel.textColor = .green
        self.alarmView.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLink = CADisplayLink(target: self, selector: #selector(handleAnimation))
        displayLink.add(to: RunLoop.main
                        , forMode: .default)
        view.addSubview(menuBackgroundView)
        view.addSubview(virusDetailBackgroundView)
        //check expose
        pathogens = [corona1,corona,saaz,corona2,corona3,corona4]
        loadingView.layer.cornerRadius = 20
        Firestore.firestore().collection("InfectedUsers").getDocuments { QuerySnapshot, Error in
            if let err = Error{
                print(err)
            }
            else{
                for doc in QuerySnapshot!.documents{
                    let data = doc.data()
                    if let uid = data["uid"] as? String
                    {
                        self.infectedUsers.append(uid)
                    }
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (timer) in
            
            for pathogen in self.pathogens {
                let pathogenCL = self.tool.convertCLL2dToCLL(cll2d: pathogen.coordinate)
                let userCoordinateCL = self.tool.convertCLL2dToCLL(cll2d: self.locationManager.location!.coordinate )
                let distanceMeter = Int(pathogenCL.distance(from: userCoordinateCL))
                if distanceMeter < 30{
                    if self.highRiskCarrier.keys.contains(pathogen.carrier){
                        let newNum = (self.highRiskCarrier[pathogen.carrier] ?? 0) + 1
                        self.highRiskCarrier.updateValue(newNum, forKey: pathogen.carrier)
                        self.tool.updateHighRiskLocationDuration(carrier: pathogen.carrier, duration: newNum)
                    }
                    else{
                        self.highRiskCarrier[pathogen.carrier] = 0
                        self.tool.uploadHighRiskLocation(coordinate:self.locationManager.location!.coordinate, virusType: pathogen.info, distance: distanceMeter, carrier: pathogen.carrier, duration: 0)
                    }
                }
                else if distanceMeter < 100{
                    if self.riskCarrier.keys.contains(pathogen.carrier){
                        let newNum = (self.riskCarrier[pathogen.carrier] ?? 0) + 1
                        self.riskCarrier.updateValue(newNum, forKey: pathogen.carrier)
                        self.tool.updateRiskLocationDuration(carrier: pathogen.carrier, duration: newNum)
                    }
                    else{
                        self.riskCarrier[pathogen.carrier] = 0
                        self.tool.uploadRiskLocation(coordinate:self.locationManager.location!.coordinate, virusType: pathogen.info, distance: distanceMeter, carrier: pathogen.carrier, duration: 0)
                    }
                    

                }else{
                    print("No Risk")
                }
                }
            }
        //get Other Users' Locations
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [self] (timer) in
            self.tool.uploadLocationToDatabase(uid: Auth.auth().currentUser?.uid ?? "", coordinate: self.locationManager.location!.coordinate)
            print(infectedUsers)
            Firestore.firestore().collection("Location").addSnapshotListener { (QuerySnapshot,Error) in
                if let err = Error {
                    print(err)
                }
                else{
                    
                    for doc in QuerySnapshot!.documents {
                        let data = doc.data()
                        let uid = data["uid"] as? String ?? "uid"
                        let latitude = data["latitude"] as? Float ?? 0
                        let longitude = data["longituede"] as? Float ?? 0
                        let distance = self.tool.getDistanceBetweenKoordinate(k1:CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude)), k2: self.locationManager.location!.coordinate)
                        if uid != Auth.auth().currentUser!.uid && distance < 20{
                            if contactList.keys.contains(uid){
                                print("update")
                                let currentTimestamp = Date().timeIntervalSince1970
                                let beginTimestamp = contactList[uid]!
                                let duration = currentTimestamp-beginTimestamp
                                self.tool.updateContactDuration(uid: uid, beginTimeStamp:beginTimestamp , distance: distance, duration: duration)
                                if infectedUsers.contains(uid){
                                    showRiskView()
                                }else{
                                    unshowRiskView()
                                }
                            }
                            else{
                                let timestamp = Date().timeIntervalSince1970
                                contactList[uid] = timestamp
                                print("create")
                                
                                self.tool.createContactList(uid:uid, beginTimeStamp: contactList[uid]!, distance: distance, duration: 0)
                                if infectedUsers.contains(uid){
                                    showRiskView()
                                }else{
                                    unshowRiskView()
                                }
                            }
                        }else{
                            unshowRiskView()
                        }
                    }
                }
            }
        }
        
       
        
        mapView.addAnnotation(corona)
        mapView.addAnnotation(saaz)
        mapView.addAnnotation(corona1)
        mapView.addAnnotation(corona2)
        mapView.addAnnotation(corona3)
        mapView.addAnnotation(corona4)
        mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationIdentifier)
        screenWidth = view.frame.width
        screenHeight = view.frame.height
        menuBackgroundView.frame = CGRect(x: -5, y: screenHeight!, width: screenWidth!+10, height: 0)
        virusDetailBackgroundView.frame = CGRect(x: -5, y: screenHeight!, width: screenWidth!+10, height: 0)
        menuBackgroundView.addSubview(menuView)
        menuView.addSubview(backMenuButton)
        backMenuButton.frame = CGRect(x: screenWidth!/2-40, y: 10, width: 80, height: 15)
        tool.constraintView(view: menuView, toView: menuBackgroundView, leadingAnchor: 5, trailingAnchor: -5, topAnchor: 5, bottomAnchor: 0)
        virusDetailBackgroundView.addSubview(virusDetailView)
        tool.constraintView(view: virusDetailView, toView: virusDetailBackgroundView, leadingAnchor: 5, trailingAnchor: -5, topAnchor: 5, bottomAnchor: 0)
        menuView.addSubview(scaleTitle)
        scaleTitle.frame = CGRect(x: 20, y: 25, width: 200, height:20)
        menuView.addSubview(scaleButton100)
        scaleButton100.frame = CGRect(x: screenWidth!/2-40, y: 55, width: 80, height: 30)
        menuView.addSubview(scaleButton500)
        scaleButton500.frame = CGRect(x: 40, y: 55, width: 80, height: 30)
        menuView.addSubview(scaleButton50)
        scaleButton50.frame = CGRect(x: screenWidth!-120, y: 55, width: 80, height: 30)
        menuView.addSubview(cutLine)
        cutLine.frame = CGRect(x: 0, y: 100, width: screenWidth!, height: 1)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        //VirusDetailView
        virusDetailView.addSubview(virusButton)
        virusButton.frame = CGRect(x: 10, y: 20, width: screenWidth!-20, height: 50)
        virusDetailView.addSubview(closeButton)
        closeButton.frame = CGRect(x: screenWidth!/2-20, y: 5, width: 40, height: 10)
        virusDetailView.addSubview(distanceView)
        distanceView.frame = CGRect(x: 10, y: 80, width: screenWidth!-20, height: 180)
        distanceView.addSubview(riskGradeLabel)
        riskGradeLabel.frame = CGRect(x: 15, y: 10, width: 200, height: 30)
        distanceView.addSubview(exposeAddressLabel)
        exposeAddressLabel.frame = CGRect(x: 15, y: 60, width: distanceView.frame.width - 30, height: 20)
        distanceView.addSubview(updateTimeLabel)
        updateTimeLabel.frame = CGRect(x: 15, y: 140, width: 200, height: 20)
        distanceView.addSubview(distanceLabel)
        distanceLabel.frame = CGRect(x: 15, y: 100, width: 200, height: 20)
        distanceView.addSubview(distanceDetailButton)
        distanceDetailButton.frame = CGRect(x: distanceView.frame.width - 40, y: 10, width: 30, height: 30)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3){
            self.menuBackgroundView.frame = CGRect(x: -5, y: self.screenHeight!-400, width: self.screenWidth!+10, height: 400)
            self.menuBackgroundView.layer.cornerRadius = 25
            self.menuView.layer.cornerRadius = 20
        }
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locationManager.location?.coordinate else {return}
                let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        uploadUserLocation(latitude: Float(locValue.latitude), longitude: Float(locValue.longitude))
    }
}

extension MapViewController: CLLocationManagerDelegate{
    @objc func m100ButtonPressed () {
//        self.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        regionRadius = 100
        tool.hightleightButton(button: scaleButton100)
        tool.disleightButton(button: scaleButton500)
        tool.disleightButton(button: scaleButton50)
        guard let coordinate = locationManager.location?.coordinate else {return}
                let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
    }
    @objc func m500ButtonPressed () {
//        self.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        regionRadius = 500
        tool.hightleightButton(button: scaleButton500)
        tool.disleightButton(button: scaleButton100)
        tool.disleightButton(button: scaleButton50)
        guard let coordinate = locationManager.location?.coordinate else {return}
                let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
    }
    @objc func m50ButtonPressed () {
//        self.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        regionRadius = 50
        tool.hightleightButton(button: scaleButton50)
        tool.disleightButton(button: scaleButton100)
        tool.disleightButton(button: scaleButton500)
        guard let coordinate = locationManager.location?.coordinate else {return}
                let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
    }
    @objc func backMenuButtonPressed(){
        UIView.animate(withDuration: 0.3) {
            self.menuBackgroundView.frame = CGRect(x: -5, y: self.screenHeight!, width: self.screenWidth!+10, height: 0)
        }
    }
    @objc func virusDetailButtonPressed(coordinate:CLLocationCoordinate2D){
        regionRadius = 30
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func uploadUserLocation(latitude:Float, longitude:Float){
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("Location").document("Curentlocation").setData(
            ["latitude":latitude,
             "longitude":longitude
            ])
    }

}

// Virus detail View

extension MapViewController: MKMapViewDelegate {
    
    @objc func closeVirusButtonPressed(){
        UIView.animate(withDuration: 0.3) {
            self.virusDetailBackgroundView.frame = CGRect(x: -5, y: self.screenHeight!, width: self.screenWidth!+10, height: 0)
            self.regionRadius = 300
            guard let coordinate = self.locationManager.location?.coordinate else {return}
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: self.regionRadius, longitudinalMeters: self.regionRadius)
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Viruses else{return nil}
        let identifier = "Virus"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        }
        else{
            annotationView?.annotation = annotation
            
        }
        let virus = annotation as! Viruses
        annotationView?.image = virus.image
        annotationView?.backgroundColor = #colorLiteral(red: 0.9654392841, green: 0.1975097522, blue: 0.0978460964, alpha: 0.4504782569)
        annotationView?.layer.cornerRadius = (annotationView?.frame.height)!/2
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView Annoview: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let virus = Annoview.annotation as? Viruses else {return}
        self.updateTimeLabel.text = "Updated: "+tool.getCurrentTime()
        regionRadius = 30
        let coordinateRegion = MKCoordinateRegion(center: virus.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:virus.coordinate.latitude, longitude: virus.coordinate.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                    let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = "Address: "
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + " "
                    }
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare!
                    }
                    self.exposeAddressLabel.text = addressString
                }
            })
        
        guard let currentCoordinate2D = locationManager.location?.coordinate else {return}
        let currentCoordinate = tool.convertCLL2dToCLL(cll2d: currentCoordinate2D)
        let virusCoordinate = tool.convertCLL2dToCLL(cll2d: virus.coordinate)
        let distanceMeters = currentCoordinate.distance(from: virusCoordinate)
        let distanceMetersInt = Int(distanceMeters)
        distanceLabel.text = "Distance: " + String(distanceMetersInt) + " m"
        if (distanceMetersInt>100){
            riskGradeLabel.text = "Low Risk"
            distanceView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else if (distanceMetersInt>30 && distanceMetersInt<100){
            riskGradeLabel.text = "Risk"
            distanceView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else{
            riskGradeLabel.text = "High Risk"
            distanceView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
            
        UIView.animate(withDuration: 0.3){
            self.virusDetailBackgroundView.frame = CGRect(x: -5, y: self.screenHeight!-290, width: self.screenWidth!+10, height: 290)
            self.virusDetailBackgroundView.layer.cornerRadius = 25
            self.virusDetailView.layer.cornerRadius = 20
            self.virusButton.setTitle(virus.title, for: .normal)
        }
    }
}
