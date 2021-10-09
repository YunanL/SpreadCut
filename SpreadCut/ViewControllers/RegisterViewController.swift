//
//  RegisterViewController.swift
//  SpreadCut
//
//  Created by apple on 22.06.21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    let tool = Tools()
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.backgroundColor = #colorLiteral(red: 0.6532503588, green: 0.7772497389, blue: 1, alpha: 1)
        tool.editeButtonRadius(button: nextButton)
        emailTextField.becomeFirstResponder()
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    @objc func textFieldDidChange(_ textField:UITextField){
        errorLabel.text = ""
        if emailTextField.text != "" && passwordTextField.text != "" && repeatTextField.text != "" && passwordTextField.text == repeatTextField.text && passwordTextField.text!.count > 5{
            nextButton.backgroundColor = #colorLiteral(red: 0.4262526035, green: 0.5815395117, blue: 1, alpha: 1)
        }
        else{
            nextButton.backgroundColor = #colorLiteral(red: 0.6532503588, green: 0.7772497389, blue: 1, alpha: 1)
        }
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let rePassword = repeatTextField.text{
            if password == rePassword{
                Auth.auth().createUser(withEmail: email, password: password) { AuthDataResult, Error in
                    if let e = Error{
                        self.errorLabel.text = e.localizedDescription
                    }
                    else{
                        self.performSegue(withIdentifier: "RegisterToInfo", sender: self)
                    }
                }
            }
            else{
                errorLabel.text = "Password Error, please enter your password again"
                passwordTextField.text = ""
                repeatTextField.text = ""
            }
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "RegisterToInfo", sender: self)
    }
    
    
}
