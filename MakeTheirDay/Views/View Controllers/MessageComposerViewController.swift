//
//  MessageComposerViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import AVKit
import UIKit
import NVActivityIndicatorView

class MessageComposerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, AVAudioRecorderDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var pickerMessagePrompts: UIPickerView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    //MARK: - SOT
    
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    let prompts = ["Why does the person make you smile?", "What can only this person do?", "What's your fondest memory of them?", "How has this person changed you?", "What makes this person unique?", "Why do you look up to them?", "How do they inspire you?", "What's an adventure you both need?", "What are this person's best talents?", "Why do you brag about them?"]
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerMessagePrompts.dataSource = self
        pickerMessagePrompts.delegate = self
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        print("There was an error recording audio!")
                    }
                }
            }
        } catch {
            print("There was an error recording audio!")
        }
    }
    
    //MARK: - Actions
    
    @IBAction func shareMessage(_ sender: Any) {
        let shareText = [messageTextView.text]
//        let shareAudio:URL = URL(string: "maketheirdayrecording.m4a")!
//        figure out if right file path and if can send. does it need to be m4a or can be mp3?
        let ac = UIActivityViewController(activityItems: [shareText, shareAudio], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    //MARK: - Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prompts.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prompts[row]
    }
    
    func loadRecordingUI() {
        recordButton = UIButton(frame: CGRect(x: 20, y: 620, width: 200, height: 50))
        //reconstrain the button in a better way.. or just make my own?
        recordButton.setTitle("Tap to Record Audio", for: .normal)
        recordButton.titleLabel?.font = UIFont(name: "Noto Sans Myanmar Bold", size: 20)
        recordButton.titleLabel?.backgroundColor = UIColor.purple
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(recordButton)
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("maketheirdayrecording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
