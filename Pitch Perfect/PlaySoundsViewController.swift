//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Taylor Smith on 9/17/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupAudioPlayer() {
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }
    
    func stopAndResetAudio() {
        audioPlayer.currentTime = 0
        audioPlayer.rate = 1.0
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariablePitch(pitch:Float) {
        stopAndResetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableSpeed(speed: Float) {
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        stopAndResetAudio()
    }

    @IBAction func playSlowAudio(sender: AnyObject) {
        stopAndResetAudio()
        playAudioWithVariableSpeed(0.5)
    }
    
    @IBAction func playFastAudio(sender: AnyObject) {
        stopAndResetAudio()
        playAudioWithVariableSpeed(1.5)
    }

    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-500)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        stopAndResetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let echo = AVAudioUnitDelay()
        echo.delayTime = 1.5
        echo.feedback = 75
        echo.wetDryMix = 50
        audioEngine.attachNode(echo)
        
        audioEngine.connect(audioPlayerNode, to: echo, format: nil)
        audioEngine.connect(echo, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    @IBAction func playReverbAudio(sender: AnyObject) {
        stopAndResetAudio()
        let audioPlayerNode = AVAudioPlayerNode()

        audioEngine.attachNode(audioPlayerNode)
        
        let reverb = AVAudioUnitReverb()
        reverb.wetDryMix = 70.0
        audioEngine.attachNode(reverb)
        
        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
}
