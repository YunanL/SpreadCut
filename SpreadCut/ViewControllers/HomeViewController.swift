//
//  HomeViewController.swift
//  SpreadCut
//
//  Created by apple on 22.06.21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var CreatButton: UIButton!
    @IBAction func creatButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToRegister", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        CreatButton.layer.cornerRadius = 22
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "WelcomeToLogin", sender: self)
    }
    
}
