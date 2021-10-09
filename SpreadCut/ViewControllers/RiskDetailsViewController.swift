//
//  RiskDetailsViewController.swift
//  SpreadCut
//
//  Created by apple on 11.07.21.
//

import UIKit

class RiskDetailsViewController: UIViewController {
    var exposures: [Exposure] = []
    @IBOutlet weak var riskStatus: UILabel!
    @IBOutlet weak var exposureLabel: UILabel!
    @IBOutlet weak var UpdateTime: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var riskView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var closestDistance: UILabel!
    @IBOutlet weak var lastExpose: UILabel!
    let tool = Tools()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.exposures.count != 0{
            showRiskStatus()
        }

    }
    
    func showRiskStatus(){
        var sumContactDuration:Int = 0
        var sumContactDistance:Int = 0
        var contactDistance:Int = 0
        var contactTimes:Int = 0
        var closestDistance: Int = 100
        var lastExpose:String = ""
        for exposure in exposures{
            sumContactDuration += exposure.exposeDuration
            sumContactDistance += exposure.exposeDuration * exposure.exposeAverageDistance
            contactTimes+=1
            closestDistance = min(closestDistance,exposure.exposeClosestDistance)
            lastExpose = exposure.lastExpose
        }
        contactDistance = sumContactDistance/sumContactDuration 
        self.exposureLabel.text = "\(contactTimes) "+"risk exposures"
        self.UpdateTime.text = self.tool.convertTime1970ToDate(time1970: Date().timeIntervalSince1970)
        self.durationLabel.text = "\(sumContactDuration/60+1) min"
        self.distanceLabel.text = "\(contactDistance) m"
        self.closestDistance.text = "\(closestDistance) m"
        self.lastExpose.text = lastExpose
        self.addressLabel.text = "Wagnerstrasse 101, 22089, Hamburg"
        if sumContactDuration > 1800{
            self.riskView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.riskStatus.text = "High Risk: Corona Virus"
            
        } else if sumContactDuration > 30 {
            self.riskView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.riskStatus.text = "Risk: CoronaVirus"
            
        } else{
            self.riskView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
        }
    }

}
