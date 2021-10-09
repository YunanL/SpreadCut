//
//  ReportViewController.swift
//  SpreadCut
//
//  Created by apple on 09.09.21.
//

import UIKit
import Firebase

class ReportViewController: UIViewController {
    @IBOutlet weak var backgroudView: UIView!
    
    @IBOutlet weak var SyptomDate: UIDatePicker!
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var tool = Tools()
    @IBOutlet weak var confirmButton: UIButton!
    var symptomDateInTimestamp:Double = 0.0
    var currentTimestamp: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroudView.layer.cornerRadius = 30
        tool.editeButtonRadius(button: confirmButton)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func confirmButtonPressed(_ sender: Any) {
        symptomDateInTimestamp = SyptomDate.date.timeIntervalSince1970
        currentTimestamp = Date().timeIntervalSince1970
        tool.uploadReport(reportTime: currentTimestamp, syptomDate: symptomDateInTimestamp, uid: Auth.auth().currentUser!.uid) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
