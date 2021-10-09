//
//  AboutViewController.swift
//  SpreadCut
//
//  Created by apple on 24.06.21.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var layerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layerView.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
