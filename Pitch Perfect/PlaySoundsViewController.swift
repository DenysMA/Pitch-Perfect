//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Denys Medina Aguilar on 09/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit
import AVFoundation

final class PlaySoundsViewController: UIViewController {

    private let audioEngine: AVAudioEngine = AVAudioEngine()
    internal var receivedAudio: RecordedAudio?
    private var audioFile: AVAudioFile?
    private var playerNode: AVAudioPlayerNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Evaluate if there is a recorded audio and creates an audio file which is required by Audio Engine
        if let filePathUrl = receivedAudio?.filePathUrl {
            audioFile = AVAudioFile(forReading: filePathUrl, error: nil)
        }
        else {
            println("file is empty")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction private func playSlowAudio(sender: UIButton) {
        self.playAudio(rate:0.5)
    }
    
    @IBAction private func playFastAudio(sender: UIButton){
        self.playAudio(rate:1.5)
    }
    
    @IBAction private func playChipMunkAudio(sender: UIButton) {
        self.playAudio(pitch: 1000)
    }
    
    @IBAction private func playDarthvaderAudio(sender: UIButton) {
        self.playAudio(pitch: -1000)
    }
    
    @IBAction private func playReverbAudio(sender: UIButton) {
        self.playAudio(reverb: 50)
    }
    
    @IBAction private func stopAudio(sender: UIButton) {
        
        //If there is audio currently playing it stops
        if let playing = playerNode?.playing
        {
            playerNode?.stop()
        }
        
    }
    
    private func playAudio(rate:Float=1.0,pitch:Float=1.0,reverb:NSNumber?=nil){
        
        var effectNode: AVAudioUnit!
        
        //Reset and stop audioEngine to play a different effect
        audioEngine.stop()
        audioEngine.reset()
        
        //Create a player node which is our audio source and attach it to audio engine
        playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        //Check if there is a reverb value to create the specific effect Node
        if let reverb = reverb {
            var reverbNode = AVAudioUnitReverb()
            reverbNode.wetDryMix = reverb.floatValue
            effectNode = reverbNode
        }
            
        //If there isn't a reverb value, it will use another effect to play audio slowly or fast modifying rate property and setting for pitch a default value (1.0) or a pitch effect modifying pitch property and setting a default rate (1.0)
        else
        {
            var pitchNode = AVAudioUnitTimePitch()
            pitchNode.pitch = pitch
            pitchNode.rate = rate
            effectNode = pitchNode
        }
        
        //Attach effect node and connecting nodes to audio engine to finally play the audio
        audioEngine.attachNode(effectNode)
        audioEngine.connect(playerNode, to: effectNode, format: nil)
        audioEngine.connect(effectNode, to: audioEngine.outputNode, format: nil)
        playerNode?.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    
        audioEngine.startAndReturnError(nil)
        playerNode?.play()
    }

}
