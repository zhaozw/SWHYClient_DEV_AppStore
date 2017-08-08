//
//  CardMainController.swift
//  SWHYClient_DEV
//
//  Created by sunny on 8/5/17.
//  Copyright © 2017 DY-INFO. All rights reserved.
//

import UIKit

@objc(CardMainController) class CardMainController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var segmentview: UIView!
    
    @IBOutlet weak var contentview: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 10.0, y: 0.0, width: segmentview.bounds.size.width - 20.0, height: 44.0)
        let segmentControl = JTSegmentControl(frame: frame)
        segmentControl.delegate = self
        segmentControl.items = ["名片夹", "云名片"]
        segmentControl.showBridge(true, index: 4)
        segmentControl.selectedIndex = 1
        segmentControl.autoAdjustWidth = false
        segmentControl.bounces = true
        segmentControl.itemSelectedTextColor = UIColor.grayColor()
        segmentview.addSubview(segmentControl)
        //view.backgroundColor = UIColor.yellowColor()
        
        let cardFileList = CardFileList()  
        cardFileList.viewDidLoad()//同样在切换的时候需要启动页面加载函数  
        //orderservingview.view.width(self.view_Order.width())  
        [self.contentview.addSubview(cardFileList.view)];  

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardMain.didReceiveResponseFromCamCardOpenAPI(_:)), name: CamCardOpenAPIDidReceiveResponseNotification, object: nil)
        
     }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        let backitem = UIBarButtonItem(title: Config.UI.PreNavItem, style: UIBarButtonItemStyle.Plain, target: self, action: "returnNavView")
        self.navigationItem.leftBarButtonItem = backitem
        
        let rightitem = UIBarButtonItem(title: "拍摄 >", style: UIBarButtonItemStyle.Plain, target: self, action: "takeCard")
        self.navigationItem.rightBarButtonItem = rightitem
        
                
    }
    
    
    func returnNavView(){
        print("click return button")
        //self.navigationController?.popViewControllerAnimated(true)
                
        let mainViewController:MainViewController = MainViewController()
        let nvc=UINavigationController(rootViewController:mainViewController)
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
        
    }
    
    func takeCard(){
        print("拍摄名片")
        //let fileViewController:FileViewController = FileViewController()
        print("判断名片王是否安装支持\(CCOpenAPI.isCCAppInstalled() )")
        print("名片王 版本 \(CCOpenAPI.currentAPIVersion())")
        
        if (CCOpenAPI.isCCAppInstalled()){
            print("通过名片王APP")
           
            //打开名片王，不带图片，自动调用名片王的图像捕获程序
            let recogCardReq:CCOpenAPIRecogCardRequest  = CCOpenAPIRecogCardRequest();
            
            recogCardReq.addRecognizeLanguage(BCRLanguage_English)
            recogCardReq.userID = Config.Card.UserID
            recogCardReq.appKey = Config.Card.AppKey
            
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleNetworkResult:", name: Config.RequestTag.PostUploadCardImage,object: nil)
            CCOpenAPI.sendRequest(recogCardReq)


        }else{
        
            print("通过 WEB API")
            let imagePickerWeb:UIImagePickerController = UIImagePickerController()
            imagePickerWeb.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerWeb.delegate = self
            imagePickerWeb.title = "WEB API"
            presentViewController(imagePickerWeb, animated: true, completion: nil)
        
        }
    }

    
    func didReceiveResponseFromCamCardOpenAPI(notify:NSNotification){
        //两个调用API返回的事件
        
        print("----------------------didReceiveResponseFromCamCardOpenAPI---------------------------")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: notify.name, object: nil)
        
        if notify.object!.isKindOfClass(CCOpenAPIRecogCardResponse) == true{
            print("===========didReceiveResponseFromCamCardOpenAPI===================")
            let response:CCOpenAPIRecogCardResponse = notify.object as! CCOpenAPIRecogCardResponse
            //let cardView:CardView = CardView()
            //cardView.cardImage.image = response.cardImage
            //cardView.cardImage = response.cardImage
            //cardView.cardString = "adfadfadf"
            print(response.responseCode)
            print(response.vcfString)
            
            //self.presentViewController(cardView, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //打开系统拍照界面返回的处理事件
        picker.dismissViewControllerAnimated(true, completion: nil)
        print("----------------------use camcard api-----------------------\(picker.title)")
        let cardImage:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        if (picker.title == "API TEST"){
            //self.openCCWithImage(cardImage)
        }
        else if (picker.title == "WEB API"){
            //let url = "http://bcr2.intsig.net/BCRService/BCR_Crop?user=weiwei@swsresearch.com&pass=MAC4CLL5Q6D8S56S&json=1&lang=15"
            //let url = "http://bcr2.intsig.net/BCRService/BCR_VCF2?PIN=290BD181296&user=weiwei@swsresearch.com&pass=MAC4CLL5Q6D8S56S&json=1&lang=15"
            //https://bcr2.intsig.net/BCRService/BCR_VCF2?user=weiwei@swsresearch.com&pass=MAC4CLL5Q6D8S56S
            
            let url = Config.Card.URL+"&json=1&lang=15"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleNetworkResult:", name: Config.RequestTag.PostUploadCardImage,object: nil)
            NetworkEngine.sharedInstance.postUploadCardImage(url, image: cardImage, tag: Config.RequestTag.PostUploadCardImage)
            
            
        }
    }

    func HandleNetworkResult(notify:NSNotification)
    {
        print("-----------------get return web response------------------")
        let result:Result = notify.valueForKey("object") as! Result
        NSNotificationCenter.defaultCenter().removeObserver(self, name: result.tag, object: nil)
        if result.status == "Error" {
            PKNotification.toast(result.message)
        }else if result.status=="OK"{
            if result.tag == Config.RequestTag.PostUploadCardImage {
                let json:String = result.userinfo.valueForKey("JSON") as! String
                let image:UIImage = result.userinfo.valueForKey("UIImage") as! UIImage
                
                
                let jsonObj = JSONClass(string:json)
                let cardItem:CardItem = processCardItem(jsonObj)
                
                let cardDetail:CardDetail = CardDetail()
                //let cardDetail:ExampleFormViewController = ExampleFormViewController()

                cardDetail.image = image
                cardDetail.cardItem = cardItem
                //self.presentViewController(cardDetail, animated: true, completion: nil)
                
                
                //let nextController:AudioDetail = AudioDetail()
                //Message.shared.audioFileName = self.itemlist[indexPath.row].filename
                self.navigationController?.pushViewController(cardDetail,animated:false);
                
         }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        //        self.segmentControl?.itemTextColor = UIColor.red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CardMainController : JTSegmentControlDelegate {
    
    func didSelected(segement: JTSegmentControl, index: Int) {
        print("current index \(index)")
        //self.label.text = "this is index:"+String(index)
        
        segement.showBridge(false, index: index)
        
        
        switch(index){  
        case 0:  
            let array1 = [self.view.subviews] as NSArray  
            if ([array1.count] == 2) {//如果用于切换页面的view中已经有了两个子页面，那么就去掉一个，这样可以实现segment的无限制次数的切换  
                array1.objectAtIndex(1).removeFromSuperview()  
            }  
            let frame1 = CGRect(x: 10.0, y: 64.0, width: UIScreen.mainScreen().applicationFrame.size.width - 20.0, height: 44.0)
            
            
            let cardFileList = CardFileList()  
            cardFileList.viewDidLoad()//同样在切换的时候需要启动页面加载函数  
            //orderservingview.view.width(self.view_Order.width())  
            [self.contentview.addSubview(cardFileList.view)];  
            break;  
        case 1:  
            let array1 = [self.view.subviews] as NSArray  
            if ([array1.count] == 2) {  
                array1.objectAtIndex(1).removeFromSuperview()  
            }  
            let orderhistoryview = CardMain()//第二个用于切换的controller  
            orderhistoryview.viewDidLoad()  
            //orderhistoryview.view.width(self.view_Order.width())  
            [self.contentview.addSubview(orderhistoryview.view)];  
            break;  
        default:  
            break;  
        }  
    }
    
    
    func processCardItem(jsonObj:JSONClass) -> CardItem{
        var card:CardItem = CardItem()
        
        card.rotation_angle = jsonObj["rotation_angle"].asString
        card.name = jsonObj["formatted_name"][0]["item"].asString
        card.address = jsonObj["address"][0]["item"]["street"].asString
        
        card.memo = jsonObj["comment"][0]["item"].asString
        card.email = jsonObj["email"][0]["item"].asString
        card.other = jsonObj["label"][0]["item"].allValues.toString()
        card.im = jsonObj["im"][0]["item"].asString
        card.company = jsonObj["organization"][0]["item"]["name"].asString
        card.role = jsonObj["role"][0]["item"].asString
        
        card.sns = jsonObj["sns"][0]["item"].asString
        //card.telephone = jsonObj["telephone"][0]["item"]["number"].asString
        
        var tmpobj:JSONClass
        
        for (k, v) in jsonObj["telephone"] {
            // k is NSString, v is another JSON object
            print ("K = \(k)  V=\(v.toString())")
            
            if (v["item"]["type"].asString == "cellular"){
                card.mobile = v["item"]["number"].asString
            
            }else if (v["item"]["type"].asString == "work"){
                card.telephone = v["item"]["number"].asString
            }
            
            
           }
        
        
        card.title = jsonObj["title"][0]["item"].asString
        card.website = jsonObj["url"][0]["item"].asString
        card.unid = NSUUID().UUIDString
        
        
        return card
    }
    
    
}