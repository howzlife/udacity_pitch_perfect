//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Dubus, Nicolas on 10/30/16.
//  Copyright © 2016 Dubus, Nicolas. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recorderButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    var audioRecorder: AVAudioRecorder!

    
    let startRecording = UIImage(named: "Record Button")
    let stopRecording = UIImage(named: "Stop Recording Button")
    var isRecording: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        isRecording = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio() {
        if isRecording {
            stopRecordingAudio()
            print("Stopped Recording")
            recorderButton.setImage(startRecording, for: UIControlState.normal)
            recordLabel.text = "Tap To Record"
            isRecording = !isRecording
        } else {
            startRecordingAudio()
            recorderButton.setImage(stopRecording, for: UIControlState.normal)
            recordLabel.text = "Stop Recording"
            print("Is Recording")
            isRecording = !isRecording
        }
    }
    
    private func startRecordingAudio () {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    private func stopRecordingAudio() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            self.performSegue(withIdentifier: "modifyRecording", sender: audioRecorder.url)
            print("Finished recording successfully")
        } else {
            print("Failed to record")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "modifyRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

