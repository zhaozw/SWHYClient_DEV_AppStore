//
//  WebViewMenuViewController.swift
//  SWHYClient_DEV
//
//  Created by sunny on 7/19/16.
//  Copyright © 2016 DY-INFO. All rights reserved.
//
import UIKit

class WebViewMenuViewController : UIViewController {

    @IBOutlet weak var btnShareToFriends: UIView!
    @IBOutlet weak var btnShareToTimeLine: UIView!
    @IBOutlet weak var btnClose: UIView!
  
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    
    //var settingViewController: UIViewController!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap_sharetofriends:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onClick_ShareToFriends:")
        btnShareToFriends.addGestureRecognizer(tap_sharetofriends)
        
        let tap_sharetotimeline:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onClick_ShareToTimeLine:")
        btnShareToTimeLine.addGestureRecognizer(tap_sharetotimeline)
        
        let tap_close:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onClick_Close:")
        btnClose.addGestureRecognizer(tap_close)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        
        //let appDisplayName: AnyObject? = infoDictionary!["CFBundleDisplayName"]
        
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"]
        
        let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"]
        
        
        self.lblVersion.text = "版本号：\(majorVersion!).\(minorVersion!)"        
        self.lblTitle.text = Config.UI.Title
        
    }
    func onClick_ShareToFriends(sender:UITapGestureRecognizer!){
        
        //self.slideMenuController()?.hidesBottomBarWhenPushed
        self.slideMenuController()?.closeRight()
        print("click")
        
        
        var message =  WXMediaMessage()
        
        message.title = "申万宏源"
        message.description = "点击 微信 右上角 - 在浏览器中打开，会自动在APP里打开分享的链接。"
        message.setThumbImage(UIImage(named:"logo"))
        
        var ext =  WXWebpageObject()
        
        let url:NSURL = NSURL(string: Message.shared.curMenuItem.uri)!
        //let request = NSURLRequest(URL: url)
        print ("host =\(url.host)")
        print ("path =\(url.path)")
        print ("query =\(url.query)")
        
        var urlstr:String = ""
        if (url.host != nil){
            urlstr = url.host!
        }
        if (url.path != nil){
            urlstr = urlstr + url.path!
        }
        if (url.query != nil){
            urlstr = urlstr + "?" + url.query!
        }
         
        ext.webpageUrl = "https://download.swsresearch.net/swinbak/openapp.html?url="+urlstr+"&wechat=1" 
        //最后加上?参数  因为微信分享会自动带上&参数 如果没有前置?参数  safari会无法解析
        print("menu share url = \(ext.webpageUrl)")
        message.mediaObject = ext
        
        var req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        WXApi.sendReq(req)

    }
    func onClick_ShareToTimeLine(sender:UITapGestureRecognizer!){
        
        //self.slideMenuController()?.hidesBottomBarWhenPushed
        self.slideMenuController()?.closeRight()
        print("click")
        
        
        var message =  WXMediaMessage()
        
        message.title = "申万宏源"
        message.description = "点击 微信 右上角 - 在浏览器中打开，会自动在APP里打开分享的链接。"
        message.setThumbImage(UIImage(named:"logo"))
        
        var ext =  WXWebpageObject()
        
        let url:NSURL = NSURL(string: Message.shared.curMenuItem.uri)!
        //let request = NSURLRequest(URL: url)
        print ("host =\(url.host)")
        print ("path =\(url.path)")
        print ("query =\(url.query)")
        
        var urlstr:String = ""
        if (url.host != nil){
            urlstr = url.host!
        }
        if (url.path != nil){
            urlstr = urlstr + url.path!
        }
        if (url.query != nil){
            urlstr = urlstr + "?" + url.query!
        }
        
        ext.webpageUrl = "https://download.swsresearch.net/swinbak/openapp.html?url="+urlstr+"&wechat=1" 
        //最后加上?参数  因为微信分享会自动带上&参数 如果没有前置?参数  safari会无法解析
        print("menu share url = \(ext.webpageUrl)")
        message.mediaObject = ext
        
        var req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneTimeline.rawValue)
        WXApi.sendReq(req)
        
    }

}