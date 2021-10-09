//
//  LoginViewController.swift
//  SpreadCut
//
//  Created by apple on 24.06.21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    let tool = Tools()
    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tool.editeButtonRadius(button: loginButton)
        email.addTarget(self, action:  #selector(textFieldDidChange(_:)), for: .editingChanged)
        password.addTarget(self, action:  #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        loginButton.backgroundColor = #colorLiteral(red: 0.6532503588, green: 0.7772497389, blue: 1, alpha: 1)
        
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = email.text, let password = password.text{
            Auth.auth().signIn(withEmail: email, password: password) { AuthDataResult, err in
                if let e = err{
                    self.errorLabel.text = e.localizedDescription
                    
                }else{
                    self.performSegue(withIdentifier: "LoginToHome", sender: self)
                }
            }
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        errorLabel.text = ""
        if email.text != "" && password.text != "" && password.text!.count > 5{
            loginButton.backgroundColor = #colorLiteral(red: 0, green: 0.5741876364, blue: 1, alpha: 1)
        }
        else{
            loginButton.backgroundColor = #colorLiteral(red: 0.6532503588, green: 0.7772497389, blue: 1, alpha: 1)
        }
    }
    @IBAction func aboutButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LoginToAbout", sender: self)
    }
    
}
