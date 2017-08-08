//
//  CardDetail.swift
//  SWHYClient_DEV
//
//  Created by sunny on 8/6/17.
//  Copyright © 2017 DY-INFO. All rights reserved.
//

import Foundation

@objc(CardDetail) class CardDetail: UIViewController {
  
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtFax: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtOther: UITextField!
    @IBOutlet weak var txtMemo: UITextField!
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    //var cardImage:UIImage
    //var cardString:String
    //var cardItem:CardItem
    var image:UIImage = UIImage()
    var netRotation : CGFloat = 1;//旋转  
    var cardItem:CardItem = CardItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        //self.cardImage = UIImage()
        //self.cardString = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    
    convenience init() {
        //print(" override init =======begin====")
        self.init(nibName: "CardDetail", bundle: nil)
        //print("over ride init =======after=======")
        //self.init(nibName: "LaunchScreen", bundle: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        print("viewwill appear Card Detail")
        super.viewWillAppear(animated)
        
        
            
        let rightitem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CardDetail.saveCardToFile))
        self.navigationItem.rightBarButtonItem = rightitem
    }
    
   
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    } 
    
    func returnNavView(){
        print("click return button")
        //self.navigationController?.popViewControllerAnimated(true)
        
        let cardMainController:CardMainController = CardMainController()
        let nvc=UINavigationController(rootViewController:cardMainController)
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
        
    }

    func saveCardToFile(){
    
        print("save to file \(cardItem.unid)")
        //var data : NSData = UIImageJPEGRepresentation(image, 1.0)
        //data.writeToFile(mydir1 + "/2.jpg", atomically: true)
        
        let filepath = DaiFileManager.document["/Card/" + cardItem.unid].path+".png"
        let data : NSData = UIImagePNGRepresentation(cardImageView.image!)!
        data.writeToFile(filepath, atomically: true)
    
        //赋值
        DaiFileManager.document[filepath].setAttr("C_Name", value: txtName.text!)
        DaiFileManager.document[filepath].setAttr("C_Address", value: txtAddress.text!)
        DaiFileManager.document[filepath].setAttr("C_Comment", value: txtMemo.text!)
        DaiFileManager.document[filepath].setAttr("C_Email", value: txtEmail.text!)
        //DaiFileManager.document[filepath].setAttr("C_IM", value: cardItem.im)
        //在上传成功后赋值
        //DaiFileManager.document[filepath].setAttr("C_ImageUrl", value: cardItem.imageurl)
        //DaiFileManager.document[filepath].setAttr("C_Label", value: cardItem.label)
        DaiFileManager.document[filepath].setAttr("C_Company", value: txtCompany.text!)
        //DaiFileManager.document[filepath].setAttr("C_Role", value: cardItem.role)
        //DaiFileManager.document[filepath].setAttr("C_SNS", value: cardItem.sns)
        DaiFileManager.document[filepath].setAttr("C_Mobile", value: txtMobile.text!)
        DaiFileManager.document[filepath].setAttr("C_Title", value: txtTitle.text!)
        DaiFileManager.document[filepath].setAttr("C_UUID", value: cardItem.unid)
        DaiFileManager.document[filepath].setAttr("C_Website", value: txtWebsite.text!)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CardDetail start view load ----")
        
        cardImageView.image = self.image
        //print(json)
        self.title = "我的名片"
        
        let backitem = UIBarButtonItem(title: Config.UI.PreNavItem, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CardDetail.returnNavView))
        self.navigationItem.leftBarButtonItem = backitem

        
        //let jsonObj = JSONClass(string:json)
        //print("name===================")
        //print(jsonObj.allKeys)
        //cardItem = processCardItem(jsonObj)
        
        cardImageView.userInteractionEnabled = true
        let tapStepGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardDetail.handleTapGesture(_:)))
        cardImageView.addGestureRecognizer(tapStepGestureRecognizer)
        
        
        //旋转手势:按住option按钮配合鼠标来做这个动作在虚拟器上  
        //var rotateGesture = UIRotationGestureRecognizer(target: self, action: "handleRotateGesture:")  
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(CardDetail.handleRotateGesture(_:)))
        cardImageView.addGestureRecognizer(rotateGesture)  
        
        self.txtName.text = cardItem.name
        self.txtTitle.text = cardItem.title
        self.txtCompany.text = cardItem.company
        self.txtMobile.text = cardItem.telephone
        self.txtEmail.text = cardItem.email
        self.txtAddress.text = cardItem.address
        
        //self.txtFax.text = cardItem.
        self.txtWebsite.text = cardItem.website
        //self.txtOther.text = cardItem.Other
        self.txtMemo.text = cardItem.memo
        
        print(cardItem.rotation_angle)


    }
    
   
   
    //旋转手势  
    func handleRotateGesture(sender: UIRotationGestureRecognizer){  
        print("旋转事件")
        //浮点类型，得到sender的旋转度数   
        let rotation : CGFloat = sender.rotation  
        //旋转角度CGAffineTransformMakeRotation,改变图像角度  
        cardImageView.transform = CGAffineTransformMakeRotation(rotation+netRotation)  
        //状态结束，保存数据  
        if sender.state == UIGestureRecognizerState.Ended{  
            netRotation += rotation  
        }  
    }  
    
    //图片旋转
    func handleTapGesture(sender:UITapGestureRecognizer){
        print("点击事件")
        /*
         enum UIImageOrientation : Int {
         case Up //0：默认方向
         case Down //1：180°旋转
         case Left //2：逆时针旋转90°
         case Right //3：顺时针旋转90°
         case UpMirrored //4：水平翻转
         case DownMirrored //5：水平翻转
         case LeftMirrored //6：垂直翻转
         case RightMirrored //7：垂直翻转
         }
 */
        let srcImage = cardImageView.image
        //翻转图片的方向
        let flipImageOrientation = (srcImage!.imageOrientation.rawValue + 2) % 8
        print(flipImageOrientation)
        //翻转图片
        let flipImage =  UIImage(CGImage:srcImage!.CGImage!,
                                 scale:srcImage!.scale,
                                 orientation:UIImageOrientation(rawValue: flipImageOrientation)!
        )
        
        //图片显示
        cardImageView.image = flipImage
    
    
    }
    

}