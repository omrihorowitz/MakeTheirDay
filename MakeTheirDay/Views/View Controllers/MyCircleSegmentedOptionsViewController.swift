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
            visualView.alpha = 1
            listView.alpha = 0
        } else {
            visualView.alpha = 0
            listView.alpha = 1
        }
    }
}
