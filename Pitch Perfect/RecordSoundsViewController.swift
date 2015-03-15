//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Denys Medina Aguilar on 08/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit
import AVFoundation

final class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {

    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    private var audioRecorder: AVAudioRecorder?
    private let recordImage = UIImage(named : "microphone")!
    private let pauseImage = UIImage(named : "pause")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Initialize default values when app is launched and when comming back from PlaySoundsVC
        
        recordButton.setImage(recordImage, forState: UIControlState.Normal)
        recordingLabel.text = "Tap to record"
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction private func recordAudio(sender: UIButton) {
        
        stopButton.hidden = false
        
        //When audioRecorder object has been created means user wants to pause recording otherwise it will resume recording
        
        if let audioRecorder = self.audioRecorder
        {
            if audioRecorder.recording
            {
                recordButton.setImage(recordImage, forState: UIControlState.Normal)
                recordingLabel.text = "Tap to resume"
                audioRecorder.pause()
            }
            else
            {
                audioRecorder.record()
                recordButton.setImage(pauseImage, forState: UIControlState.Normal)
                recordingLabel.text = "Recording in progress"
            }
        }
            
        //When audioRecorder doesn't exist, it will create a new audio file with current time and it will start recording
        else
        {
    
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder?.delegate = self
            audioRecorder?.meteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            recordButton.setImage(pauseImage, forState: UIControlState.Normal)
            recordingLabel.text = "Recording in progress"
        }

    }
    
    @IBAction private func stopAudio(sender: UIButton) {
    
        //Stop audio recorder and inactivate audio session
        
        audioRecorder?.stop()
        audioRecorder = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        
        //When flag is true audio was recorded successfully and creates a RecordedAudio object to pass it to the next screen
        if flag
        {
            if let title = recorder.url.lastPathComponent {
                
                let recordedAudio = RecordedAudio(filePathUrl: recorder.url,title: title)
                performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            }
        }
        else
        {
            println("Recording was not successful")
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Evaluates segue identifier and pass a RecordedAudio to the next view controller PlaySoundsVC to be able to play the audio with different effects
        
        if segue.identifier == "stopRecording"
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            playSoundsVC.receivedAudio = sender as? RecordedAudio
        }
        
    }
    
}

