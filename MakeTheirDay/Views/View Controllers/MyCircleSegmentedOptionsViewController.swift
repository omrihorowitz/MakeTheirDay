//
//  MyCircleSegmentedOptionsViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//
import AVKit
import UIKit
import NVActivityIndicatorView

class MyCircleSegmentedOptionsViewController: UIViewController {
    
    //MARK: - Properties
    
    var player: AVAudioPlayer?
    var isPlaying: Bool = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var visualView: UIView!
    @IBOutlet weak var listView: UIView!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            visualView.isHidden = false
            listView.isHidden = true
        } else {
            visualView.isHidden = true
            listView.isHidden = false
        }
    }
    @IBAction func musicButton(_ sender: Any) {
        playStopMusic()
    }
    
    func playStopMusic() {
        guard let url = Bundle.main.url(forResource: "SoCold", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }
            if !isPlaying {
            isPlaying = true
            player.play()
            player.numberOfLoops = -1
            } else {
            isPlaying = false
            player.pause()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
