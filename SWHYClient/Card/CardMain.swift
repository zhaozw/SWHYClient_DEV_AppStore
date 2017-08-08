//
//  CardMain.swift
//  SWHYClient_DEV
//
//  Created by sunny on 4/23/17.
//  Copyright © 2017 DY-INFO. All rights reserved.
//

import Foundation


@objc(CardMain) class CardMain: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init() {
        self.init(nibName: "CardMain", bundle: nil)
        //self.init(nibName: "LaunchScreen", bundle: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CamCardOpenAPIDidReceiveResponseNotificaton
        //CamCardOpenAPIDidReceiveRequestNotification
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveResponseFromCamCardOpenAPI:", name: CamCardOpenAPIDidReceiveRequestNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardMain.didReceiveResponseFromCamCardOpenAPI(_:)), name: CamCardOpenAPIDidReceiveResponseNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveResponseFromCamCardOpenAPI:", name: CamCardOpenAPIDidReceiveRequestNotification, object: nil)
     }
    
    
    
    @IBAction func TestCard(sender: AnyObject) {
        
        
        
            
        print("判断名片王是否安装支持\(CCOpenAPI.isCCAppInstalled() )")
        print("名片王 版本 \(CCOpenAPI.currentAPIVersion())")
        
        
        //打开名片王，不带图片，自动调用名片王的图像捕获程序
        let recogCardReq:CCOpenAPIRecogCardRequest  = CCOpenAPIRecogCardRequest();
        
        recogCardReq.addRecognizeLanguage(BCRLanguage_English)
        recogCardReq.userID = "weiwei@swsresearch.com"
        //recogCardReq.appKey = "VdBybLhN9gWW99V7CeChY8ab"
        recogCardReq.appKey = "MAC4CLL5Q6D8S56S"
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleNetworkResult:", name: Config.RequestTag.PostUploadCardImage,object: nil)
        CCOpenAPI.sendRequest(recogCardReq)
    }
    
    
    @IBAction func TestCardWithImage(sender: AnyObject) {
        //使用系统拍照组件，调用本地CARD API
        let imagePickerController:UIImagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.delegate = self
        imagePickerController.title = "API TEST"
        presentViewController(imagePickerController, animated: true, completion: nil)
        
        /*
        //UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
        [imagePickerController release];
        */
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //打开系统拍照界面返回的处理事件
        picker.dismissViewControllerAnimated(true, completion: nil)
        print("----------------------use camcard api-----------------------\(picker.title)")
        let cardImage:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        if (picker.title == "API TEST"){
            self.openCCWithImage(cardImage)
        }
        else if (picker.title == "WEB TEST"){
            let url = "http://bcr2.intsig.net/BCRService/BCR_Crop?user=weiwei@swsresearch.com&pass=MAC4CLL5Q6D8S56S&json=1&lang=15"
            //let url = "http://bcr2.intsig.net/BCRService/BCR_VCF2?PIN=290BD181296&user=weiwei@swsresearch.com&pass=MAC4CLL5Q6D8S56S&json=1&lang=15"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleNetworkResult:", name: Config.RequestTag.PostUploadCardImage,object: nil)
            NetworkEngine.sharedInstance.postUploadCardImage(url, image: cardImage, tag: Config.RequestTag.PostUploadCardImage)
            
           /*
            let data: NSData = cardImage.compressImage(cardImage, maxLength: 10240000)!
            let count = data.length / sizeof(UInt8)
            // create an array of Uint8
            var array = [UInt8](count: count, repeatedValue: 0)
            // copy bytes into array
            data.getBytes(&array, length:count * sizeof(UInt8))
            
            print("JPG Image Data=\(array)")
            
            let datos: NSData = NSData(bytes: array, length: array.count)
            let resultimage = UIImage(data: datos) // Note it's optional. Don't force unwrap!!!
            
            let cardView:CardView = CardView()
            cardView.cardImage = resultimage!
            cardView.cardString = "====="
            self.presentViewController(cardView, animated: true, completion: nil)
        */
        }
    }
    
    @IBAction func webTest(sender: AnyObject) {
        print("============web test========")
        let imagePickerWeb:UIImagePickerController = UIImagePickerController()
        imagePickerWeb.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerWeb.delegate = self
        imagePickerWeb.title = "WEB TEST"
        presentViewController(imagePickerWeb, animated: true, completion: nil)
        
        
    }
   
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let cardImage:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.openCCWithImage(cardImage)
        //imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    */
    
    func openCCWithImage(cardImage:UIImage){
        //传送Image给CARD API识别
        print("-----------------------openCCWithImage-------------------------")
        let recogCardReq:CCOpenAPIRecogCardRequest = CCOpenAPIRecogCardRequest()
        recogCardReq.cardImage = cardImage
        //recogCardReq.appKey = "VdBybLhN9gWW99V7CeChY8ab"
        
        recogCardReq.userID = "weiwei@swsresearch.com"
        //recogCardReq.appKey = "VdBybLhN9gWW99V7CeChY8ab"
        recogCardReq.appKey = "MAC4CLL5Q6D8S56S"
        CCOpenAPI.sendRequest(recogCardReq)
    }
    
    
    func didReceiveResponseFromCamCardOpenAPI(notify:NSNotification){
        //两个调用API返回的事件
        
        print("----------------------didReceiveResponseFromCamCardOpenAPI---------------------------")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: notify.name, object: nil)

        if notify.object!.isKindOfClass(CCOpenAPIRecogCardResponse) == true{
            print("===========didReceiveResponseFromCamCardOpenAPI===================")
            let response:CCOpenAPIRecogCardResponse = notify.object as! CCOpenAPIRecogCardResponse
            let cardView:CardView = CardView()
            cardView.cardImage = response.cardImage
            cardView.cardString =  "response.vcfString"
            self.presentViewController(cardView, animated: true, completion: nil)
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
                let cardView:CardView = CardView()
                cardView.cardImage = image
                cardView.cardString = json
                self.presentViewController(cardView, animated: true, completion: nil)
            }
            
        }
        
    }

    
}
