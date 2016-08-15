//
//  AudioRecorder.swift
//  SWHYClient_DEV
//
//  Created by sunny on 7/31/16.
//  Copyright © 2016 DY-INFO. All rights reserved.
//

import Foundation
import AVFoundation
//protocol AudioRecorderViewControllerDelegate: class {
 //   func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?)
//}

//AVAudioRecorderDelegate

@objc(AudioRecorder) class AudioRecorder: UIViewController{


    //@IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    //@IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordButtonContainer: UIView!
    @IBOutlet weak var playButton: UIButton!
    //weak var audioRecorderDelegate: AudioRecorderViewControllerDelegate?

    
    var timeTimer: NSTimer?
    var milliseconds: Int = 0
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer?
    var outputURL: NSURL = NSURL()
    var audioTmpPath:String = ""
    var audioPath:String = ""
    var audioTmpFilePath:String  = ""
    var audioFilePath:String  = ""
    var recording:Bool = false
    var audioTmpFileName:String = ""
    var audioFileName:String = ""
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        //let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
       // let outputPath = documentsPath.stringByAppendingPathComponent("\(NSUUID().UUIDString).m4a")
        //outputURL = NSURL(fileURLWithPath: outputPath)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init() {
        self.init(nibName: "AudioRecorder", bundle: nil)
       // self.init
        //self.init(nibName: "LaunchScreen", bundle: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Message.shared.curMenuItem.name
        self.navigationController?.setNavigationBarHidden(false, animated: false)
       
        DaiFileManager.document["/Audio_Tmp/"].delete()
        
        self.audioTmpPath = DaiFileManager.document["/Audio_Tmp/"].path
        self.audioPath = DaiFileManager.document["/Audio/"].path
                
        
        recordButton.layer.cornerRadius = 4
        recordButtonContainer.layer.cornerRadius = 25
        recordButtonContainer.layer.borderColor = UIColor.whiteColor().CGColor
        recordButtonContainer.layer.borderWidth = 3

        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let backitem = UIBarButtonItem(title: Config.UI.PreNavItem, style: UIBarButtonItemStyle.Plain, target: self, action: "returnNavView")
        self.navigationItem.leftBarButtonItem = backitem
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let audioRecorderMenuViewController = storyboard.instantiateViewControllerWithIdentifier("AudioRecorderMenuViewController") as! AudioRecorderMenuViewController
        self.slideMenuController()?.changeRightViewController(audioRecorderMenuViewController, closeRight: true)
        self.setNavigationBarItem()
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            NSLog("Error: \(error)")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopRecording:", name: UIApplicationDidEnterBackgroundNotification, object: nil)

        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    func returnNavView(){
        print("click return button")
        //self.navigationController?.popViewControllerAnimated(true)
        
        let mainViewController:MainViewController = MainViewController()
        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: mainViewController), close: true)
    }
    
    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?) {
        // do something with fileURL
        dismissViewControllerAnimated(true, completion: nil)
    }

    //func dismiss(sender: AnyObject) {
    //    cleanup()
    //    self.audioRecorderViewControllerDismissed(withFileURL: nil)
   // }
    
      
    @IBAction func saveAudio(sender: AnyObject) {
       
        //DaiFileManager.document["/Audio_Tmp/" + self.audioTmpFileName].move(DaiFileManager.document["/Audio/" + self.audioTmpFileName])
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let path = DaiFileManager.document["/Audio_Tmp/" + self.audioTmpFileName].path
            let pathMp3 = DaiFileManager.document["/Audio/" + self.audioFileName].path
           
            print("Save Audio from \(path)")
            print("Save Audio to \(pathMp3)")
            AudioWrapper.audioPCMtoMP3(path, pathMp3)
        }
        //DaiFileManager.document["/Audio_Tmp/" + self.audioTmpFileName].delete()
        //cleanup()
        //self.audioRecorderViewControllerDismissed(withFileURL: outputURL)
    }
    
    @IBAction func toggleRecord(sender: AnyObject) {
        print("toggle Record")
        timeTimer?.invalidate()
        
        
        print("sender =\(sender.enabled)")
        if(self.recording == true){
        //if ((recorder?.recording) != nil) {
            print("recorder is nil")
            self.recording = false
            recorder.stop()
        } else {
            
            //录制开始
            //let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            //let outputPath = documentsPath.stringByAppendingPathComponent("\(NSUUID().UUIDString).m4a")
            
            let dateFormatter:NSDateFormatter = NSDateFormatter();
            
            dateFormatter.dateFormat = "yyyyMMddHHmmss";
            let tmpdate = "\(dateFormatter.stringFromDate(NSDate()))"
            //LinearPCM
            self.audioTmpFileName = tmpdate+".wav"
            self.audioFileName = tmpdate+".mp3"
            
            self.audioTmpFilePath = self.audioTmpPath + self.audioTmpFileName        
            self.audioFilePath = self.audioPath + self.audioFileName
            print(self.audioFilePath)
            outputURL = NSURL(fileURLWithPath: audioTmpFilePath)
            
            //let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]
            
            let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]
            //let settings = [AVNumberOfChannelsKey: NSNumber(integer: 2)]
            
            //let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEGLayer3), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]
            //kAudioFormatMPEG4AAC
            try! recorder = AVAudioRecorder(URL: outputURL, settings: settings)

       
            recorder.prepareToRecord()
            milliseconds = 0
            timeLabel.text = "00:00.00"
            timeTimer = NSTimer.scheduledTimerWithTimeInterval(0.0167, target: self, selector: "updateTimeLabel:", userInfo: nil, repeats: true)
            //recorder.deleteRecording()
            recorder.record()
            self.recording = true
        }
        print("toggle record")
        updateControls()
        
    }
    
    func stopRecording(sender: AnyObject) {
        if recorder.recording {
            toggleRecord(sender)
        }
    }
    
    func cleanup() {
        timeTimer?.invalidate()
        if recorder.recording {
            recorder.stop()
            recorder.deleteRecording()
        }
        if let player = player {
            player.stop()
            self.player = nil
        }
    }
    
    
    
    @IBAction func play(sender: AnyObject) {
        print ("play")
        if let player = player {
            player.stop()
            self.player = nil
            updateControls()
            return
        }
        
        do {
            try player = AVAudioPlayer(contentsOfURL: outputURL)
        }
        catch let error as NSError {
            NSLog("error: \(error)")
        }
        
        //player?.delegate = self
        player?.play()
        
        updateControls()
    }
    
    
    func updateControls() {
        print ("update controls")
        UIView.animateWithDuration(0.2) { () -> Void in
            self.recordButton.transform = self.recorder.recording ? CGAffineTransformMakeScale(0.5, 0.5) : CGAffineTransformMakeScale(1, 1)
        }
        
        if let _ = player {
            //StopButton
            print("stop button")
            playButton?.setImage(UIImage(named: "StopButton"), forState: .Normal)
            recordButton?.enabled = false
            recordButtonContainer?.alpha = 0.25
        } else {
          print("play button")
            playButton?.setImage(UIImage(named: "PlayButton"), forState: .Normal)
           
            recordButton?.enabled = true
            recordButtonContainer?.alpha = 1
        }
        
        playButton?.enabled = !recorder.recording
        playButton?.alpha = recorder.recording ? 0.25 : 1
        //saveButton?.enabled = !recorder.recording
        
    }
    
    
    
    
    // MARK: Time Label
    
    func updateTimeLabel(timer: NSTimer) {
        milliseconds++
        let milli = (milliseconds % 60) + 39
        let sec = (milliseconds / 60) % 60
        let min = milliseconds / 3600
        timeLabel.text = NSString(format: "%02d:%02d.%02d", min, sec, milli) as String
    }
    
    
    // MARK: Playback Delegate
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
        updateControls()
    }
    
}