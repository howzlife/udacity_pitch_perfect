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
    let startedRecordingText: String = "Started Recording"
    let stoppedRecordingText: String = "Stopped Recording"
    let recordLabelText: String = "Tap to Record"
    let stopLabelText: String = "Stop Recording"
    var isRecording: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        isRecording = false
    }

    @IBAction func recordAudio() {
        isRecording
            ? recordAudio(record: true, output: stoppedRecordingText,
                                  image: startRecording!, labelText: recordLabelText)
            : recordAudio(record: false, output: startedRecordingText,
                        image: stopRecording!, labelText: stopLabelText)
    }
    
    private func recordAudio(record: Bool, output: String, image: UIImage, labelText: String) {
        isRecording ? stopRecordingAudio() : startRecordingAudio()
        print(output)
        recorderButton.setImage(image, for: UIControlState.normal)
        recordLabel.text = labelText
        isRecording = !isRecording
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
            let alertController = UIAlertController(title: "Error", message: "Failed to record, please try again", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alertController, animated: true)
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

