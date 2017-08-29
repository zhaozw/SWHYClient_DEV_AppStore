//
//  WebViewController.swift
//  SWHY_Moblie
//
//  Created by sunny on 3/13/15.
//  Copyright (c) 2015 DY-INFO. All rights reserved.
//

import UIKit

@objc(CardWebView) class CardWebView: UIViewController,UIWebViewDelegate,NSURLConnectionDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    //let webView:UIWebView = UIWebView()
    var request:NSURLRequest = NSURLRequest()
    var authenticated:Bool = false
    var failure_auth = 0
    var urlstr = ""
    
    /*
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience init() {
        print("===init webview controller===")
        self.init(nibName: "CardWebView", bundle: nil)
        //self.init(nibName: "LaunchScreen", bundle: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let webView:UIWebView = self.view.viewWithTag(10) as UIWebView
        //webView = UIWebView()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //if webView == nil {
        ////    webView = self.view.viewWithTag(10) as! UIWebView
            
        //}
        //view.bringSubviewToFront(webView)
        print("webview = \(self.webView)")
        
        webView.frame = self.view.frame
        //webView.delegate = self
        //self.view.addSubview(webView)
        //webView.backgroundColor = UIColor.redColor()
        
        
        var tmpurl:String = Message.shared.webViewURL
        
        //if tmpurl == "" {
        //    tmpurl =  Message.shared.curMenuItem.uri
        //}
        
        let range=tmpurl.rangeOfString("&wechat=1", options: NSStringCompareOptions()) //Swift 2.0
        print("range =\(range)")
        
        if range != nil{
            let endIndex=range?.startIndex 
            urlstr = tmpurl.substringToIndex((endIndex)!) //Swift 2.0
        }else{
            urlstr = tmpurl
        }
        //urlstr = "https://www.baidu.com?"
        
        print("url = \(urlstr)")
        let url:NSURL = NSURL(string: urlstr)!
        request = NSURLRequest(URL: url)
        print ("scheme =\(url.scheme)")
        print ("host =\(url.host)")
        print ("path =\(url.path)")
        print ("query =\(url.query)")
        print ("pathExtension =\(url.pathExtension)")
        print("on load request =\(request.mainDocumentURL)")
        webView.loadRequest(request)
        
        print("loading : \(webView.loading)")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("viewwill appear")
        super.viewWillAppear(animated)
                
    }
    
    func returnNavView(){
        print("click return button")
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        print("didFailLoadWithError")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleNetworkResult:", name: Config.RequestTag.WebViewPreGet, object: nil)
        print(self.urlstr)
        NetworkEngine.sharedInstance.addRequestWithUrlString(self.urlstr, tag: Config.RequestTag.WebViewPreGet,useCache:false)
    }
    func webViewDidStartLoad(webView: UIWebView){
        print("did start load \(webView.request)")
        
    }
    
    /*
     func webView(webView: UIWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
     print("webView:\(webView) didReceiveAuthenticationChallenge:\(challenge) completionHandler:\(completionHandler)")
     
     
     let credential = NSURLCredential(user: "swsresearch\\shenyd", password: "east", persistence: NSURLCredentialPersistence.ForSession)
     completionHandler(.UseCredential, credential)
     
     }
     
     func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge){
     
     if challenge.previousFailureCount == 0 {
     print("--------willSendRequestForAuthenticationChallenge----do-----")
     authenticated = true
     let credential = NSURLCredential(user: "swsresearch\\shenyd", password: "east", persistence: NSURLCredentialPersistence.ForSession)
     challenge.sender!.useCredential(credential, forAuthenticationChallenge: challenge)
     } else {
     print("--------willSendRequestForAuthenticationChallenge-----cancel----")
     challenge.sender!.cancelAuthenticationChallenge(challenge)
     }
     }
     
     func connectionShouldUseCredentialStorage(connection: NSURLConnection) -> Bool{
     print("--------connectionShouldUseCredentialStorage---------")
     return true
     }
     
     func connection(connection: NSURLConnection, didFailWithError error: NSError){
     print("--------connection---------")
     }
     */
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if self.authenticated == false { 
            print("----webview asking for permission to start loading  false url = \(self.urlstr)")
            authenticated = false
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleNetworkResult:", name: Config.RequestTag.WebViewPreGet, object: nil)
            NetworkEngine.sharedInstance.addRequestWithUrlString(self.urlstr, tag: Config.RequestTag.WebViewPreGet,useCache:false)
            return false
        }
        print("----webview asking for permission to start loading   true")
        
        return true
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("webview did finish load!")
    }
    
    func HandleNetworkResult(notify:NSNotification)
    {
        print("handlenetworkresult")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Config.RequestTag.WebViewPreGet, object: nil)
        
        let result:Result = notify.valueForKey("object") as! Result
        print(result.status)
        if result.status == "Error" {
            PKNotification.toast(result.message)
        }else if result.status=="OK"{
            let url:NSURL = NSURL(string: urlstr)!
            request = NSURLRequest(URL: url)
            print(request.URL)
            self.authenticated = true
            webView.loadRequest(request)
            print("---load again------")
        }    
    }
    
    
}


