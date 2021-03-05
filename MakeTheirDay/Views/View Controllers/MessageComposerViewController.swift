//
//  MessageComposerViewController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import AVKit
import UIKit
import NVActivityIndicatorView
import MobileCoreServices

class MessageComposerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, AVAudioRecorderDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var recordAudio: UIButton!
    
    @IBOutlet weak var pickerMessagePrompts: UIPickerView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    //MARK: - Properties
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioURL: URL?
    var videoURL: URL?
    var dic:UIDocumentInteractionController?
    
    let prompts = ["Why do they make you smile?", "What can only they do?", "What's your fondest memory?", "How have they changed you?", "What makes them unique?", "Why do you look up to them?", "How do they inspire you?", "What's an adventure y'all need?", "What are their best talents?", "Why do you brag about them?"]
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchSetup()
    }
    
    //MARK: - Actions
    
    @IBAction func recordVideo(_ sender: Any) {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
    @IBAction func shareVideo(_ sender: Any) {
        if let shareVideo = videoURL{
            let dic = UIDocumentInteractionController(url: shareVideo)
            self.dic = dic
            dic.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
        }
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordTapped()
    }
    
    @IBAction func shareText(_ sender: Any) {
        if let shareText = messageTextView.text, !shareText.isEmpty {
            let ac = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            present(ac, animated: true)
        }
    }
    
    @IBAction func shareAudio(_ sender: Any) {
        if let shareAudio = audioURL{
            let dic = UIDocumentInteractionController(url: shareAudio)
            self.dic = dic
            dic.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
        }
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
        recordAudio.setTitle("Tap to Record Audio", for: .normal)
        recordAudio.titleLabel?.font = UIFont(name: "Noto Sans Myanmar Bold", size: 12)
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("maketheirdayrecording.m4a")
        audioURL = audioFilename
        
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
            
            recordAudio.setTitle("Tap to Stop", for: .normal)
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
            recordAudio.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordAudio.setTitle("Tap to Record", for: .normal)
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
    
    @objc func video(
        _ videoPath: String,
        didFinishSavingWithError error: Error?,
        contextInfo info: AnyObject
    ) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
                            title: "OK",
                            style: UIAlertAction.Style.cancel,
                            handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func launchSetup() {
        addCancelKeyboardGestureRecognizer()
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
}

//MARK: - Extensions

extension MessageComposerViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            // 1
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            // 2
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
        else { return }
        videoURL = url
        
        // 3
        UISaveVideoAtPathToSavedPhotosAlbum(
            url.path,
            self,
            #selector(video(_:didFinishSavingWithError:contextInfo:)),
            nil)
    }
}
extension MessageComposerViewController: UINavigationControllerDelegate {
}
