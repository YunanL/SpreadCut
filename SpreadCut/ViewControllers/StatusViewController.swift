//
//  StatusViewController.swift
//  SpreadCut
//
//  Created by apple on 09.09.21.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    var tool = Tools()
    override func viewDidLoad() {
        super.viewDidLoad()
        tool.editeButtonRadius(button: confirmButton)
        
    }
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
