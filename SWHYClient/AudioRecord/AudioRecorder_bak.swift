//
//  AudioRecorder.swift
//  SWHYClient_DEV
//
//  Created by sunny on 7/31/16.
//  Copyright © 2016 DY-INFO. All rights reserved.
//

import Foundation
import AVFoundation
import AudioKit
//protocol AudioRecorderViewControllerDelegate: class {
//   func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?)
//}

//AVAudioRecorderDelegate

@objc(AudioRecorder_bak) class AudioRecorder_bak: UIViewController,AVAudioPlayerDelegate{
    
    
    //@IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var btn_Record: MKButton!
    @IBOutlet weak var btn_Play: MKButton!
    @IBOutlet weak var btn_Save: UIButton!
    
    @IBOutlet var audioInputPlot: EZAudioPlot!
    
    var timeTimer: NSTimer?
    //var milliseconds: Int = 0
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var outputURL: NSURL = NSURL()
    var audioTmpPath:String = ""
    var audioPath:String = ""
    var audioTmpFilePath:String  = ""
    var audioFilePath:String  = ""
    //var recording:String = ""
    var audioTmpFileName:String = ""
    var audioFileName:String = ""
    
    var tmptitle:String = ""
    var tmpdesc:String = ""
    
    var recordercolor:UIColor?
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    
    
    let noteFrequencies = [16.35,17.32,18.35,19.45,20.6,21.83,23.12,24.5,25.96,27.5,29.14,30.87]
    
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
        btn_Record.rippleEnabled =  true
        btn_Record.cornerRadius = 3
        
        btn_Record.userInteractionEnabled = true
        self.recordercolor = btn_Record.backgroundColor
        
        mic = AKMicrophone()
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain: 0)
        
        //初始化record-----------------------------------------
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyyMMddHHmmss";
        let tmpdate = "\(dateFormatter.stringFromDate(NSDate()))"
        //LinearPCM
        self.audioTmpFileName = tmpdate+".wav"
        self.audioFileName = tmpdate+".mp3"
        
        self.audioTmpFilePath = self.audioTmpPath + self.audioTmpFileName        
        self.audioFilePath = self.audioPath + self.audioFileName
        
        outputURL = NSURL(fileURLWithPath: audioTmpFilePath)
        
        let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM),//编码格式
            AVSampleRateKey: NSNumber(integer: 44100), //声音采样率
            AVNumberOfChannelsKey: NSNumber(integer: 2),////采集音轨
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.High.rawValue))//音量
        ]
        try! recorder = AVAudioRecorder(URL: outputURL, settings: settings)
        //recorder.delegate = self
        
    }
    func setupPlot() {
        print(audioInputPlot.frame)
        print(audioInputPlot.bounds)
        //
        //let plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
        let plot = AKNodeOutputPlot(mic, frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
        plot.plotType = .Rolling
        plot.shouldFill = true
        
        plot.shouldMirror = true
        plot.color = UIColor.grayColor()
        //plot.frame.width = audioInputPlot.frame.width
        
        print(plot.frame)
        
        //audioInputPlot.autoresizesSubviews = true
        audioInputPlot.addSubview(plot)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let backitem = UIBarButtonItem(title: Config.UI.PreNavItem, style: UIBarButtonItemStyle.Plain, target: self, action: "returnNavView")
        self.navigationItem.leftBarButtonItem = backitem
        
        let rightitem = UIBarButtonItem(title: "录音库 >", style: UIBarButtonItemStyle.Plain, target: self, action: "gotoNavView")
        self.navigationItem.rightBarButtonItem = rightitem
        
        AudioKit.output = silence
        setupPlot()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            NSLog("Error: \(error)")
        }
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopRecording:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //NSNotificationCenter.defaultCenter().removeObserver(self)
        cleanup()
        
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
        
        
        let txtTitle:UITextField = UITextField()
        txtTitle.placeholder = "标题"
        txtTitle.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 1.0, alpha: 1.0)
        txtTitle.textColor = UIColor.darkGrayColor()
        
        
        let txtDesc:UITextField = UITextField()
        txtDesc.placeholder = "摘要"
        txtDesc.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 1.0, alpha: 1.0)
        txtDesc.textColor = UIColor.darkGrayColor()
        
        
        let btnOK:PKButton = PKButton(title: "确认",
                                      action: { (messageLabel, items) -> Bool in
                                        print("确认 is clicked.")
                                        let tmptxtTitle: UITextField = items[0] as! UITextField //items index number
                                        let tmptxtDesc: UITextField = items[1] as! UITextField //items index number
                                        
                                        if (tmptxtTitle.text == "" || tmptxtDesc.text == ""){
                                            messageLabel?.text = "请填写标题与摘要."
                                            tmptxtTitle.backgroundColor = UIColor(red: 0.95, green: 0.8, blue: 0.8, alpha: 1.0)
                                            tmptxtDesc.backgroundColor = UIColor(red: 0.95, green: 0.8, blue: 0.8, alpha: 1.0)
                                            return false
                                        }
                                        NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleResult:", name: Config.NotifyTag.ConvertToMP3AndPublish, object: nil)
                                        self.covertToMP3(tmptxtTitle.text!,desc: tmptxtDesc.text!)
                                        return true
            },
                                      fontColor: UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0),
                                      backgroundColor: nil)
        
        PKNotification.alert(
            title: "保存",
            message: "保存并上传至录音库",
            items: [txtTitle, txtDesc, btnOK],
            cancelButtonTitle: "取消",
            tintColor: nil)
        
    }
    
    func covertToMP3(title:String, desc:String){
        print("coverttomp3")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let path = DaiFileManager.document["/Audio_Tmp/" + self.audioTmpFileName].path
            let pathMp3 = DaiFileManager.document["/Audio/" + self.audioFileName].path
            
            AudioWrapper.audioPCMtoMP3(path, pathMp3)
            
            
            DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_Title", value: title)
            DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_Desc", value: desc)
            DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_Duration", value: self.timeLabel.text!)
            //PKNotification.toast("保存至录音资源库成功")
            dispatch_async(dispatch_get_main_queue(), {
                
                //这里返回主线程，写需要主线程执行的代码
                //println("这里返回主线程，写需要主线程执行的代码  --  Dispatch")
                let result:Result = Result(status: "OK",message:"保存至录音资源库成功",userinfo:NSObject(),tag:Config.NotifyTag.ConvertToMP3AndPublish)
                NSNotificationCenter.defaultCenter().postNotificationName(Config.NotifyTag.ConvertToMP3AndPublish, object: result)
            })
        }
        
    }
    
    
    func HandleResult(notify:NSNotification)
    {
        let result:Result = notify.valueForKey("object") as! Result
        NSNotificationCenter.defaultCenter().removeObserver(self, name: notify.name, object: nil)
        
        if result.status == "Error" {
            print("-------post  error-------------")
            PKNotification.toast(result.message)
        }else if result.status=="OK"{
            if result.tag == Config.NotifyTag.ConvertToMP3AndPublish {
                print("保存至录音资源库成功---")
                PKNotification.toast(result.message)
                
                //接着直接上传录音至服务器
                let filePath = DaiFileManager.document["/Audio/"+self.audioFileName].path
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleResult:", name: Config.RequestTag.PostUploadAudioFile, object: nil)
                NetworkEngine.sharedInstance.postUploadFile(Config.URL.PostUploadAudioFile, filePath: filePath, tag: Config.RequestTag.PostUploadAudioFile)
            }else if result.tag == Config.RequestTag.PostUploadAudioFile{
                DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_URL", value: Config.URL.AudioBaseURL + Message.shared.postUserName + "_" + self.audioFileName)
                PKNotification.toast(result.message)
                
            }
            
            
        }
    }
    
    
    func cleanup() {
        timeTimer?.invalidate()
        print("do clean up")
        if let recorder = recorder{
            print("do record cleanup")
            if recorder.recording {
                print("do recorder stop")
                recorder.stop()
                recorder.deleteRecording()
                print("do AudioKit stop")
                AudioKit.stop()
            }
        }
        
        if let player = player {
            player.stop()
            self.player = nil
        }
    }
    
    
    
    func refreshControls(sender: AnyObject) {
        print ("update controls\(btn_Record.state)")
        
        if (sender as! NSObject == btn_Record){
            if let recorder = recorder{
                //btn_Play.enabled = !recorder.recording
                if recorder.recording {
                    
                    btn_Play.enabled = true
                    btn_Play.setTitle("暂停录音", forState: UIControlState.Normal)
                    btn_Play.backgroundColor = UIColor.orangeColor()
                    
                    btn_Record.enabled = true
                    btn_Record.setTitle("停止录音", forState: UIControlState.Normal)
                    btn_Record.backgroundColor = UIColor.redColor()
                }else{
                    
                    btn_Play.enabled = true
                    btn_Play.setTitle("播  放", forState: UIControlState.Normal)
                    btn_Play.backgroundColor = self.recordercolor
                    
                    btn_Record.enabled = true
                    btn_Record.setTitle("录音开始", forState: UIControlState.Normal)
                    btn_Record.backgroundColor = self.recordercolor
                    
                }
                
            }else{
                print("recorder is nil")
            }
        }else if (sender as! NSObject == btn_Play){
            
            if let player = player{
                
                if btn_Play.currentTitle == "暂停录音" {
                    btn_Play.setTitle("继续录音", forState: UIControlState.Normal)
                    
                }else if btn_Play.currentTitle == "继续录音" {
                    btn_Play.setTitle("暂停录音", forState: UIControlState.Normal)
                    
                }else{
                    
                    
                    if player.playing{
                        
                        btn_Play.setTitle("停  止", forState: UIControlState.Normal)
                        btn_Play.backgroundColor = UIColor.redColor()
                        
                        btn_Record.enabled = false
                        btn_Record.backgroundColor = UIColor.grayColor()
                    }else{
                        
                        btn_Play.setTitle("播  放", forState: UIControlState.Normal)
                        btn_Play.backgroundColor = self.recordercolor
                        
                        btn_Record.enabled = true
                        btn_Record.backgroundColor = self.recordercolor
                    }
                }
            }else{
                
                print("player is nil")
            }
            
        }
    }
    
    
    // MARK: Time Label
    
    func updateTimeLabel(timer: NSTimer) {
        
        let ti = NSInteger(recorder!.currentTime)
        
        //var ms = Int((interval % 1) * 1000)
        
        let sec = ti % 60
        let min = (ti / 60) % 60
        let hour = (ti / 3600)
        
        timeLabel.text = NSString(format: "%02d:%02d:%02d",hour, min, sec) as String
        
    }
    
    
    // MARK: Playback Delegate
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        //self.player = nil
        refreshControls(btn_Play)
    }
    
    @IBAction func act_Record(sender: AnyObject) {
        print("toggle Record start")
        timeTimer?.invalidate()
        //print("sender =\(sender.enabled)")
        if let recorder = recorder{
            if recorder.recording{
                recorder.stop()
                AudioKit.stop()
            }else{
                timeLabel.text = "00:00:00"
                timeTimer = NSTimer.scheduledTimerWithTimeInterval(0.0167, target: self, selector: "updateTimeLabel:", userInfo: nil, repeats: true)
                //recorder.deleteRecording()
                //recorder.prepareToRecord()
                recorder.record()
                AudioKit.start()
            }
        }else{
            print(" no recorder object")
        }
        print("toggle record")
        refreshControls(sender)
    }
    
    @IBAction func act_Play(sender: AnyObject) {
        //print(self.player)
        if self.player == nil{
            do {
                try self.player = AVAudioPlayer(contentsOfURL: outputURL)
            }
            catch let error as NSError {
                print("player init error\(error)")
            }
            player?.delegate = self
        }
        
        if let player = self.player {
            print(sender.currentTitle)
            if sender.currentTitle == "暂停录音" {
                recorder?.pause()
                AudioKit.stop()
                
            }else if sender.currentTitle == "继续录音"{
                recorder?.record()
                AudioKit.stop()
            }else if sender.currentTitle == "播  放"{
                player.play()
                
                
            }else if sender.currentTitle == "停  止"{
                player.stop()
                
            }
            refreshControls(sender)
            
        }else{
            print("player no object")
        }
        
    }
    
    
}