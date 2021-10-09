//
//  SystemViewController.swift
//  SpreadCut
//
//  Created by apple on 28.09.21.
//

import UIKit
import Firebase

class SystemViewController: UIViewController {
    
    
    let tool = Tools()
    let firebaseAuth = Auth.auth()
    let logoutAlert = UIAlertController(title: "Confirm to logout", message: nil, preferredStyle: .alert)
    var delegate: logoutDelegate!
    @IBOutlet weak var switchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tool.editeButtonRadius(button: switchButton)
        
    }
    @IBAction func switchButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action:UIAlertAction!) in
            do{
                try self.firebaseAuth.signOut()
                self.dismiss(animated: true) {
                    self.delegate.popToRootViewController()
                }
            } catch let signOutError as NSError{
                print("Error signing out %@", signOutError)
            }
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: { (action: UIAlertAction!) in

        }))
        
        present(logoutAlert,animated: true)
    }
}
