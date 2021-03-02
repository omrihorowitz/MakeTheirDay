//
//  MyCircleSegmentedOptionsViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit
import NVActivityIndicatorView

class MyCircleSegmentedOptionsViewController: UIViewController {
    
    @IBOutlet weak var visualView: UIView!
    @IBOutlet weak var listView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            visualView.isHidden = false
            listView.isHidden = true
        } else {
            visualView.isHidden = true
            listView.isHidden = false
        }
    }
}
