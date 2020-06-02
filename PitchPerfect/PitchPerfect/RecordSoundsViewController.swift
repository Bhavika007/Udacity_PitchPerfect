//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Bhavika Arigala on 31/05/20.
//  Copyright © 2020 Bhavika Arigala. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear called")
    }
     // MARK: Fucntion responsible for recording and playing back audio
    @IBAction func recordAudio(_ sender: Any) {
      setPlayButtons(false)
        
            let session = AVAudioSession.sharedInstance()
            if session.category != .playAndRecord {
                try! session.setCategory(.playAndRecord)
                try! session.setActive(true)
                let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
                let recordingName = "recordedVoice.wav"
                let filePath = NSURL.fileURL(withPathComponents: [dirPath, recordingName])
                try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            audioRecorder.record()
        }
    @IBAction func stopRecording(_ sender: Any) {
       
        setPlayButtons(true)
       
        //to stop the audioRecorder. also sets audiosession to inactive
        audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        }
        else {
            print("recording not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func setPlayButtons(_ enabled: Bool) {
           stopRecordingButton.isEnabled = !enabled
           recordButton.isEnabled = enabled
           if enabled {
               recordingLabel.text = "Tap to Record"
           } else {
               recordingLabel.text = "Recording in progress"
           }
           
       }
}

