//
//  CardMain.swift
//  SWHYClient_DEV
//
//  Created by sunny on 4/23/17.
//  Copyright © 2017 DY-INFO. All rights reserved.
//

import Foundation
//import <CamCardOpenAPIFramework/OpenAPI.h>;

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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveResponseFromCamCardOpenAPI:", name: CamCardOpenAPIDidReceiveResponseNotification, object: nil)
    }
    
    
    
    @IBAction func TestCard(sender: AnyObject) {
        //打开名片王，不带图片，自动调用名片王的图像捕获程序
        let recogCardReq:CCOpenAPIRecogCardRequest  = CCOpenAPIRecogCardRequest();
        
        recogCardReq.addRecognizeLanguage(BCRLanguage_English)
        //recogCardReq.userID = "weiwei@swsresearch.com"
        recogCardReq.appKey = "VdBybLhN9gWW99V7CeChY8ab"
        CCOpenAPI.sendRequest(recogCardReq)
    }
    
    
    @IBAction func TestCardWithImage(sender: AnyObject) {
        
        let imagePickerController:UIImagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.delegate = self
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
        picker.dismissViewControllerAnimated(true, completion: nil)
        let cardImage:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.openCCWithImage(cardImage)
        
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
        print("-----------------------openCCWithImage-------------------------")
        let recogCardReq:CCOpenAPIRecogCardRequest = CCOpenAPIRecogCardRequest()
        recogCardReq.cardImage = cardImage
        recogCardReq.appKey = "VdBybLhN9gWW99V7CeChY8ab"
        CCOpenAPI.sendRequest(recogCardReq)
    }
    
    
    func didReceiveResponseFromCamCardOpenAPI(notify:NSNotification){
        print("----------------------didReceiveResponseFromCamCardOpenAPI---------------------------")
        
        if notify.object!.isKindOfClass(CCOpenAPIRecogCardResponse) == true{
            print("===========didReceiveResponseFromCamCardOpenAPI===================")
            let response:CCOpenAPIRecogCardResponse = notify.object as! CCOpenAPIRecogCardResponse
            let cardView:CardView = CardView()
            cardView.cardImage = response.cardImage
            cardView.cardString = response.vcfString
            self.presentViewController(cardView, animated: true, completion: nil)
        }
    }
    
}
