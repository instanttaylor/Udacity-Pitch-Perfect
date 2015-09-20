//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Taylor Smith on 9/17/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var recordingSession: AVAudioSession!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingLabel.text = "Tap to Record"
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (success: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        self.loadRecordingSetup()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadRecordingSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadRecordingSetup() {
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        recordingLabel.text = "Tap to Record"
    }
    
    func loadRecordingUI() {
        recordingLabel.text = "Recording..."
        recordButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
        print("Recording started")

    }
    
    func loadFailUI() {
        recordButton.hidden = true
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        setupAudioRecorder()
        loadRecordingUI()
    }
    
    @IBAction func pauseOrResumeRecording(sender: AnyObject) {
        if audioRecorder.recording {
            audioRecorder.pause()
            if let resumeImage = UIImage(named: "resume_80_blue") {
                pauseButton.setImage(resumeImage, forState: .Normal)
            }
        } else {
            if let pauseImage = UIImage(named: "pause_80_blue") {
                pauseButton.setImage(pauseImage, forState: .Normal)
            }
            audioRecorder.record()
        }
    }
    func setupAudioRecorder() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        audioRecorder = try! AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: AnyObject) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StopRecording" {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(file: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        } else {
            print("ooops, finished with an error.")
            self.loadRecordingSetup()
        }
    }
}

