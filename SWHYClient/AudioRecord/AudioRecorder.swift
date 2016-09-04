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

@objc(AudioRecorder) class AudioRecorder: UIViewController,AVAudioPlayerDelegate{
    
    
    //@IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var btn_Record: MKButton!
    @IBOutlet weak var btn_Play: MKButton!
    
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
    
    var recordercolor:UIColor?
    
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
        
        btn_Record.maskEnabled = true
        btn_Record.rippleLocation = MKRippleLocation.Center
        btn_Record.rippleLayerColor = UIColor.MKColor.LightGreen
        btn_Record.cornerRadius = 3
        
        btn_Record.userInteractionEnabled = true
        self.recordercolor = btn_Record.backgroundColor
                       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let backitem = UIBarButtonItem(title: Config.UI.PreNavItem, style: UIBarButtonItemStyle.Plain, target: self, action: "returnNavView")
        self.navigationItem.leftBarButtonItem = backitem
        
        let rightitem = UIBarButtonItem(title: "录音库 >", style: UIBarButtonItemStyle.Plain, target: self, action: "gotoNavView")
        self.navigationItem.rightBarButtonItem = rightitem
        
        /*
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let audioRecorderMenuViewController = storyboard.instantiateViewControllerWithIdentifier("AudioRecorderMenuViewController") as! AudioRecorderMenuViewController
        self.slideMenuController()?.changeRightViewController(audioRecorderMenuViewController, closeRight: true)
        self.setNavigationBarItem()
        */
        
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
        let nvc=UINavigationController(rootViewController:mainViewController);
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
        
    }
    
    func gotoNavView(){
        print("click goto button")
        //self.navigationController?.popViewControllerAnimated(true)
        
        //let fileViewController:FileViewController = FileViewController()
        let fileViewController:AudioFileList = AudioFileList()
        let nvc=UINavigationController(rootViewController:fileViewController);
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
        
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
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let path = DaiFileManager.document["/Audio_Tmp/" + self.audioTmpFileName].path
            let pathMp3 = DaiFileManager.document["/Audio/" + self.audioFileName].path
            
            //print("Save Audio from \(path)")
            //print("Save Audio to \(pathMp3)")
            AudioWrapper.audioPCMtoMP3(path, pathMp3)
            DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_Duration", value: self.timeLabel.text!)
            
            print(DaiFileManager.document["/Audio/"+self.audioFileName].getAttr("C_Duration"))
            
            PKNotification.toast("保存至录音资源库成功")

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
    
    
            
    func refreshControls(sender: AnyObject) {
        print ("update controls\(btn_Record.state)")
                
        
        if let _ = player {
            //StopButton
            print("stop button11111")
            btn_Play.setTitle("停  止", forState: UIControlState.Normal)
            btn_Record.enabled = false
            btn_Record.backgroundColor = UIColor.grayColor()
            btn_Play.backgroundColor = UIColor.redColor()
            
        } else {
            print("play button")
           
            btn_Play.setTitle("播  放", forState: UIControlState.Normal)
            btn_Record.enabled = true
            btn_Record.backgroundColor = self.recordercolor
            btn_Play.backgroundColor = self.recordercolor
        }
        
        
        if (sender as! NSObject == btn_Record){
            print("send from record")
            if(btn_Record.currentTitle=="开始录音"){
                btn_Record.setTitle("停止录音", forState: UIControlState.Normal)
                //self.recordercolor = btn_Record.backgroundColor
                btn_Record.backgroundColor = UIColor.redColor()
            }else{
                btn_Record.setTitle("开始录音", forState: UIControlState.Normal)
                btn_Record.backgroundColor = self.recordercolor
            }
        }
        
        btn_Play.enabled = !recorder.recording
        if (btn_Play.enabled == false){
            print("disable")
            btn_Play.backgroundColor = UIColor.grayColor()
        }else{
            print("enable")
            //btn_Play.backgroundColor = self.recordercolor
        }
        
        //saveButton?.enabled = !recorder.recording
        
    }
    
    
    // MARK: Time Label
    
    func updateTimeLabel(timer: NSTimer) {
        milliseconds++
        //let milli = (milliseconds % 60) + 39
        let sec = (milliseconds / 60) % 60
        let min = milliseconds / 3600
        let hour = min / 60
        timeLabel.text = NSString(format: "%02d:%02d:%02d",hour, min, sec) as String
    }
    
    
    // MARK: Playback Delegate
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
        refreshControls(btn_Play)
    }
    
    @IBAction func act_Record(sender: AnyObject) {
        //PKNotification.toast("do click")
        print("toggle Record start")
        timeTimer?.invalidate()
        
        
        //print("sender =\(sender.enabled)")
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
            //print(self.audioFilePath)
            outputURL = NSURL(fileURLWithPath: audioTmpFilePath)
            
            //let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]
            
            let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]
            //let settings = [AVNumberOfChannelsKey: NSNumber(integer: 2)]
            
            //let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEGLayer3), AVSampleRateKey: NSNumber(integer: 44100), AVNumberOfChannelsKey: NSNumber(integer: 2)]
            //kAudioFormatMPEG4AAC
            try! recorder = AVAudioRecorder(URL: outputURL, settings: settings)
            //recorder.delegate = self
            
            recorder.prepareToRecord()
            milliseconds = 0
            timeLabel.text = "00:00:00"
            timeTimer = NSTimer.scheduledTimerWithTimeInterval(0.0167, target: self, selector: "updateTimeLabel:", userInfo: nil, repeats: true)
            //recorder.deleteRecording()
            recorder.record()
            self.recording = true
        }
        print("toggle record")
        refreshControls(sender)
        
    }
    
    @IBAction func act_Play(sender: AnyObject) {
        
        print("click play")
        if let player = player {
            player.stop()
            self.player = nil
            refreshControls(sender)
            return
        }
        
        do {
            try player = AVAudioPlayer(contentsOfURL: outputURL)
        }
        catch let error as NSError {
            NSLog("error: \(error)")
        }
        
        player?.delegate = self
        player?.play()
        
        refreshControls(sender)
    }
    
}