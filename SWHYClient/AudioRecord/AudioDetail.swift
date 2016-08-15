//
//  AudioDetail.swift
//  SWHYClient_DEV
//
//  Created by sunny on 8/7/16.
//  Copyright © 2016 DY-INFO. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class AudioDetail: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var lblFileName: UILabel!
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var allTimeLabel: UILabel!
    @IBOutlet weak var lblSize: UILabel!
        
    //var audioPlayer:AVPlayerViewController = AVPlayerViewController()
    var player: AVAudioPlayer? = AVAudioPlayer()
    var timer:NSTimer?
    var audioFileName:String = ""
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    
    convenience init() {
        //print(" override init =======begin====")
        self.init(nibName: "AudioDetail", bundle: nil)
        //print("over ride init =======after=======")
        //self.init(nibName: "LaunchScreen", bundle: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.contentView.frame.origin.y = 30
        print("inner address detail view did load")
        // Do any additional setup after loading the view.
        //self.scrollview.scrollEnabled = true
        self.audioFileName =  Message.shared.audioFileName
        self.title = "微录音"

        
        self.lblFileName.text = self.audioFileName
        print(DaiFileManager.document["/Audio/"+self.audioFileName].attrs)
        
        progressSlider.setMinimumTrackImage(UIImage(named: "player_slider_playback_left"), forState: UIControlState.Normal)
        progressSlider.setMaximumTrackImage(UIImage(named: "player_slider_playback_right"), forState: UIControlState.Normal)
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: UIControlState.Normal)

        
        print(DaiFileManager.document["/Audio/"+self.audioFileName])
        self.txtTitle.text = DaiFileManager.document["/Audio/"+self.audioFileName].getAttr("C_Title")
        self.txtDesc.text = DaiFileManager.document["/Audio/"+self.audioFileName].getAttr("C_Desc")
        
       
        let fileSize = DaiFileManager.document["/Audio/"+self.audioFileName].attrs.fileSize() 
        //let fileSize = fileSizeNumber
        var sizeMB = Double(fileSize / 1024)
        sizeMB = Double(sizeMB / 1024)
        print(String(format: "%.2f", sizeMB) + " MB")
        
       
        self.lblSize.text = String(format: "%.2f", sizeMB) + " MB"
        
 
 
        self.txtTitle.borderStyle = UITextBorderStyle.RoundedRect
        self.txtTitle.returnKeyType = UIReturnKeyType.Done      
        self.txtTitle.delegate = self
        
        
        self.txtDesc.returnKeyType = UIReturnKeyType.Default
        self.txtDesc.delegate = self
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidEndEditing", name: UITextViewTextDidEndEditingNotification, object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        print("viewwill appear")
        super.viewWillAppear(animated)
        //self.title = Message.shared.curMenuItem.name
        let backitem = UIBarButtonItem(title: Config.UI.PreNavItem, style: UIBarButtonItemStyle.Plain, target: self, action: "returnNavView")
        self.navigationItem.leftBarButtonItem = backitem
        setMyCurrentSong()
        
        //let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        //let webViewMenuViewController = storyboard.instantiateViewControllerWithIdentifier("WebViewMenuViewController") as! WebViewMenuViewController
        //self.slideMenuController()?.changeRightViewController(webViewMenuViewController, closeRight: true)
        //self.setNavigationBarItem()
        
    }

    func textDidEndEditing()
    {
            print("结束输入...")
    }
    
    func returnNavView(){
        print("click return button")
        self.navigationController?.popViewControllerAnimated(true)
        
        //let audioRecorderViewController:AudioRecorder = AudioRecorder()
        //self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: audioRecorderViewController), close: true)
    }
    
    func setMyCurrentSong() {
        //currentSong = curSong
        //currentIndex = tableData.indexOfObject(curSong)
        //NSLog("%d",currentIndex)
        //photo.image = getImageWithUrl(currentSong.picture)
        //backgroundImageView.image = photo.image
        //titleLabel.text = currentSong.title as String
       // artistLabel.text = currentSong.artist as String
        playButton.selected = false
        playTimeLabel.text = "00:00"
        self.progressSlider.value = 0.0
        //self.rotationAnimation()
        //self.audioPlayer.
        
        do {
            //print(DaiFileManager.document["/Audio/"+self.audioFileName].path)
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: DaiFileManager.document["/Audio/"+self.audioFileName].path))
        }
        catch let error as NSError {
            NSLog("error: \(error)")
        }
        
        let all:Int=Int((self.player!.duration))//共多少秒
        let m:Int=all % 60//秒
        let f:Int=Int(all/60)//分
        var time=NSString(format:"%02d:%02d",f,m)
        //print(time)
        self.allTimeLabel.text = time as String

       
        //player?.delegate = self
        //player?.play()
        
        //self.audioPlayer.contentURL=NSURL(string:currentSong.url as String)
        timer?.invalidate()
        timer=NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        playButton.setImage(UIImage(named: "player_btn_play_normal.png"), forState: UIControlState.Normal)
        
    }

    //播放
    @IBAction func playButtonClick(sender: UIButton) {
        if sender.selected {
            //暂停播放
            self.player!.pause()
            //pauseLayer(photo.layer)
            playButton.setImage(UIImage(named: "player_btn_play_normal"), forState: UIControlState.Normal)
            
        }else{
            //开始/继续播放
            self.player!.play()
            //resumeLayer(photo.layer)
            playButton.setImage(UIImage(named: "player_btn_pause_highlight.png"), forState: UIControlState.Normal)
        }
        sender.selected = !sender.selected
    }

    
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        //收起键盘
        textField.resignFirstResponder()
        //打印出文本框中的值
        print(textField.text)
        return true;
    }
/*
    func textViewShouldReturn(textView: UITextView) -> Bool
    {
        //收起键盘
        textView.resignFirstResponder()
        //打印出文本框中的值
        print(textView.text)
        return true;
    }
 */
    func textFieldDidEndEditing(textField: UITextField){
        
        print("end editing \(textField.text)")
        if (textField == self.txtTitle){
            print("get obj field")
            DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_Title", value: textField.text!)
        }
    }
    
   
    func textViewDidEndEditing(textView: UITextView) {
         print("view结束编辑1\(textView)")
        if (textView == self.txtDesc){
            print("get obj view")
            DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_Desc", value: textView.text)
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    //更新播放时间
    func updateTime(){
        var c=self.player!.currentTime
        //self.player?.duration
        // audioPlayer.endPlaybackTime
        if c>0.0 {
            let t=self.player!.duration
            let p:CFloat=CFloat(c/t)
            progressSlider.value=p;
            let all:Int=Int(c)//共多少秒
            let m:Int=all % 60//秒
            let f:Int=Int(all/60)//分
            var time=NSString(format:"%02d:%02d",f,m)
            playTimeLabel.text=time as String
        }
    }

}
