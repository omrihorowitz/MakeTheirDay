//
//  MyCircleSegmentedOptionsViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit

class MyCircleSegmentedOptionsViewController: UIViewController {
    
    @IBOutlet weak var visualView: UIView!
    @IBOutlet weak var listView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
