//
//  ViewController.swift
//  SpreadCut
//
//  Created by apple on 21.06.21.
//

import UIKit
import Firebase
import FirebaseAuth
import ViewAnimator

class ViewController: UIViewController {
    @IBOutlet weak var AppNameLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        AppNameLabel.text = "SpreadCut"
        AppNameLabel.textColor = #colorLiteral(red: 0.4262526035, green: 0.5815395117, blue: 1, alpha: 1)
        AppNameLabel.textAlignment = .center
        AppNameLabel.font = AppNameLabel.font.withSize(40)
        AppNameLabel.animate(animations: [AnimationType.zoom(scale: 4)], duration: 1)
        navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            if Auth.auth().currentUser?.uid == nil{
                self.performSegue(withIdentifier: "WelcomeToHome", sender: self)
            }
            else{
                self.performSegue(withIdentifier: "WelcomeToApp", sender: self)
            }
        })
    }

}

