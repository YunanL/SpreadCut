//
//  UserInfoViewController.swift
//  SpreadCut
//
//  Created by apple on 23.06.21.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController {
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let formatter = DateFormatter()
    let ref = Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("UserInfo").document("GeneralInfo")
    let tool = Tools()
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.backgroundColor = #colorLiteral(red: 0.6532503588, green: 0.7772497389, blue: 1, alpha: 1)
        tool.editeButtonRadius(button: signUpButton)
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.year = -24
        let maxDate = calendar.date(byAdding: comps, to: Date())
        comps.year = -100
        let minDate = calendar.date(byAdding: comps, to: Date())
        birthdayPicker.maximumDate = maxDate
        birthdayPicker.minimumDate = minDate
        fName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        gender.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNum.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if fName.text != ""
            && lName.text != ""
            && phoneNum.text != ""
            && birthdayPicker != nil
            && gender.text != ""{
            signUpButton.backgroundColor = #colorLiteral(red: 0, green: 0.5741876364, blue: 1, alpha: 1)
        }
        else{
            signUpButton.backgroundColor = #colorLiteral(red: 0.6532503588, green: 0.7772497389, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        formatter.dateStyle = .short
        let birthday = formatter.string(from:birthdayPicker.date)
        if let fName = fName.text, let lName = lName.text, let gender = gender.text, let phoneNum = phoneNum.text{
            ref.setData(["FirstName":fName,
                         "LastName":lName,
                         "Gender":gender,
                         "Birthday":birthday,
                         "PhoneNumber":phoneNum
            ]) { Error in
                if let err = Error {
                    print(err)
                } else{
                    self.performSegue(withIdentifier: "InfoToHome", sender: self)
                }
            }
            
        }
    }
    

}
