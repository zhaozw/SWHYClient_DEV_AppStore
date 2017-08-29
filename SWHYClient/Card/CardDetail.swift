//
//  CardDetail.swift
//  SWHYClient_DEV
//
//  Created by sunny on 8/6/17.
//  Copyright © 2017 DY-INFO. All rights reserved.
//

import Foundation

@objc(CardDetail) class CardDetail: UIViewController {
  
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtDept: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtTel: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtFax: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtOther: UITextField!
    @IBOutlet weak var txtMemo: UITextField!
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var imglinephone: UIImageView!
    @IBOutlet weak var imgmobilephone: UIImageView!
    
    //var cardImage:UIImage
    //var cardString:String
    //var cardItem:CardItem
    var image:UIImage = UIImage()
    var netRotation : CGFloat = 1;//旋转  
    var cardItem:CardItem = CardItem()
    //var flipImage:UIImage = nil
    
    var floatButton:UIButton = UIButton(type: .Custom)
    
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
        self.scrollView.showsHorizontalScrollIndicator = true
        //滚动时是否显示垂直滚动条
        self.scrollView.showsVerticalScrollIndicator = true
        self.scrollView.scrollEnabled = true
        
        self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 800)
        //self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 50)
        if cardItem.uploadflag != "Y" && cardItem.saveflag == "Y" {
            creatSusPendBtn()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.floatButton.removeFromSuperview()
    }
    
    func creatSusPendBtn(){
        print ("---- creatSusPendBtn")
        
        floatButton.setTitle("上传到云名片夹", forState: .Normal)
        
        let screensize:CGSize = UIScreen.mainScreen().bounds.size
        
        let frame:CGRect = CGRectMake(screensize.width/2-100, screensize.height - 32, 200, 30)
        floatButton.frame = frame
        floatButton.backgroundColor = UIColor.redColor()
        floatButton.alpha = 0.7
        floatButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        floatButton.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
        floatButton.addTarget(self, action: #selector(CardDetail.uploadCard(_:)), forControlEvents: .TouchUpInside)
            
        
        UIApplication.sharedApplication().windows[0].addSubview(floatButton)
        
        //self.parentViewController?.view.addSubview(floatButton)
        //self.view.bringSubviewToFront(floatButton)
    }
    
    /*
 
     -(void)creatSuspendBtn{
     //悬浮按钮
     _button = [UIButton buttonWithType:UIButtonTypeCustom];
     [_button setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
     CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
     CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
     _button.frame = CGRectMake(0,0, 64, 64);
     [_button addTarget:self action:@selector(suspendBtnClick) forControlEvents:UIControlEventTouchUpInside];
     
     //悬浮按钮所处的顶端UIWindow
     _window = [[UIWindow alloc] initWithFrame:CGRectMake(screenWidth*0.5-32, screenHeight-84, 64, 64)];
     //使得新建window在最顶端
     _window.windowLevel = UIWindowLevelAlert + 1;
     _window.backgroundColor = [UIColor clearColor];
     [_window addSubview:_button];
     //显示window
     [_window makeKeyAndVisible];
     }
 
 */
  
    
    override func viewDidDisappear(animated: Bool) {
       
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        //self.floatButton.removeFromSuperview()
        
    } 
    
    func returnNavView(){
        print("click return button")
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        //let cardMainController:CardMainController = CardMainController()
        //let nvc=UINavigationController(rootViewController:cardMainController)
        //self.slideMenuController()?.changeMainViewController(nvc, close: true)
        
    }

    func saveCardToFile(){
    
        print("save to file \(cardItem.unid) Name\(txtName.text!)")
        //var data : NSData = UIImageJPEGRepresentation(image, 1.0)
        //data.writeToFile(mydir1 + "/2.jpg", atomically: true)
        
        
        let filepath = DaiFileManager.document["/Card/" + cardItem.unid].path+".png"
        let filename = "/Card/" + cardItem.unid+".png"
        
        //cardImageView.image = self.image
        print("原始方向 \(self.image.imageOrientation.rawValue)")
        //return
        
        let data : NSData = UIImagePNGRepresentation(self.image)!
        data.writeToFile(filepath, atomically: true)
        print ("save image to path \(filepath)")
    
        //赋值
        DaiFileManager.document[filename].setAttr("C_Name", value: txtName.text!)
        DaiFileManager.document[filename].setAttr("C_Address", value: txtAddress.text!)
        DaiFileManager.document[filename].setAttr("C_Comment", value: txtMemo.text!)
        DaiFileManager.document[filename].setAttr("C_Email", value: txtEmail.text!)
        DaiFileManager.document[filename].setAttr("C_Other", value: txtOther.text!)
        //在上传成功后赋值
        DaiFileManager.document[filename].setAttr("C_Memo", value: txtMemo.text!)
        //DaiFileManager.document[filepath].setAttr("C_Label", value: cardItem.label)
        DaiFileManager.document[filename].setAttr("C_Company", value: txtCompany.text!)
        DaiFileManager.document[filename].setAttr("C_Dept", value: txtDept.text!)
        DaiFileManager.document[filename].setAttr("C_Fax", value: txtFax.text!)
        DaiFileManager.document[filename].setAttr("C_Mobile", value: txtMobile.text!)
        DaiFileManager.document[filename].setAttr("C_Tel", value: txtTel.text!)
        DaiFileManager.document[filename].setAttr("C_Title", value: txtTitle.text!)
        DaiFileManager.document[filename].setAttr("C_UNID", value: cardItem.unid)
        DaiFileManager.document[filename].setAttr("C_Website", value: txtWebsite.text!)
        
        DaiFileManager.document[filename].setAttr("C_ImageUrl", value: cardItem.imageurl)
        
        DaiFileManager.document[filename].setAttr("C_Orientation", value: String(self.image.imageOrientation.rawValue))
        
        cardItem.saveflag = "Y"
        
        print("save adress =\(txtAddress.text!)")
        
        if cardItem.uploadflag != "Y" && cardItem.saveflag == "Y" {
            creatSusPendBtn()
        }               
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CardDetail start view load ----")
        
        print("CardDetail cardItem.imageOrientation ----\(cardItem.imageOrientation)")

        print("CardDetail cardItem ----\(self.cardItem.name) \(self.cardItem.unid)")
        
        
        var orientation:Int
        if cardItem.imageOrientation == nil {
            orientation = self.image.imageOrientation.rawValue
        }else{
            orientation = Int(cardItem.imageOrientation)!
        }
        print("CardDetail orientation ----\(orientation)")

        
        //cardImageView.image = self.image
        cardImageView.image = changeImageOrientation(self.image,orientation: orientation)
        //print(json)
        navItem.title = "名片信息"
        
        let backitem = UIBarButtonItem(title: Config.UI.PreNavItem, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CardDetail.returnNavView))
        navItem.leftBarButtonItem = backitem

        let rightitem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CardDetail.saveCardToFile))
        navItem.rightBarButtonItem = rightitem
        
        
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
        self.txtDept.text = cardItem.dept
        self.txtTel.text = cardItem.tel
        self.txtMobile.text = cardItem.mobile
        self.txtEmail.text = cardItem.email
        self.txtAddress.text = cardItem.address
        
        self.txtFax.text = cardItem.fax
        
        self.txtWebsite.text = cardItem.website
        self.txtOther.text = cardItem.other
        self.txtMemo.text = cardItem.memo
        
     
        
        
        print("\(cardItem.rotation_angle)   unid= \(cardItem.unid)")
      
        let tap_linephone:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardDetail.onClick_LinePhone(_:)))
        imglinephone.addGestureRecognizer(tap_linephone)
        
        
        let tap_mobilephone:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardDetail.onClick_MobilePhone(_:)))
        imgmobilephone.addGestureRecognizer(tap_mobilephone)
        
     

        //2016-11-02 键盘打开时 窗口显示在键盘上面
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "keyboardWillChange:",
                                                         name: UIKeyboardWillChangeFrameNotification, object: nil)

    }
    
    func onClick_LinePhone(sender:UITapGestureRecognizer!){
        print("click line phone")
        let num = txtTel?.text
        if num != nil{
            confirmCall(num!)
        }}
    func onClick_MobilePhone(sender:UITapGestureRecognizer!){
        print ("click mobile phone")
        let num = txtMobile?.text
        if num != nil{
            confirmCall(num!)
        }}
    
    func keyboardWillChange(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            
            
            print("UIKeyboardFrameEndUserInfoKey \(value)")
            
            //let frame = value.CGRectValue()
            //let frame = self.scrollView.frame
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            //let screenSize: CGRect = self.scrollView.bounds
            
            var intersection = CGRectIntersection(value.CGRectValue(), screenSize)
            //var intersection = CGRectIntersection(value.CGRectValue(), alertView.frame)
            
            print("screenSize\(screenSize)")
            print("instersection height =\(intersection.height)")
            //print("frame before =\(frame)")
            
            //if intersection.height == 0.0 {
            //    intersection = CGRect(x: intersection.origin.x, y: intersection.origin.y, width: intersection.width, height: 100)
            //}
            UIView.animateWithDuration(duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve), animations: {
                                        _ in
                                        //改变下约束
                                        //当键盘消失，让view回归原始位置
                                        if intersection.height == 0.0 {
                                            print("键盘  消失")
                                            //self.view.center = UIApplication.sharedApplication().windows[0].center
                                            //self.scrollView.center = self.view.center
                                            let position:CGPoint = CGPointMake(0, 0)
                                            self.scrollView.setContentOffset(position, animated: true)
                                        }else{
                                            print("键盘 出现")
                                            let position:CGPoint = CGPointMake(0, intersection.height)
                                            self.scrollView.setContentOffset(position, animated: true)
                                            //self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, screenSize.height - intersection.height - self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
                                            //self.view.frame = frame
                                        }
                                        //print("self.view.frame after \(self.view.frame)")
                                        //self.bottomConstraint.constant = CGRectGetHeight(intersection)
                                        //self.view.layoutIfNeeded()
                }, completion: nil)
        }
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
        //let srcImage = cardImageView.image
        let srcImage = self.image
        //翻转图片的方向
        print("原始方向 \(srcImage.imageOrientation.rawValue)")
        let flipImageOrientation = (srcImage.imageOrientation.rawValue + 2) % 8
        print("待旋转方向 \(flipImageOrientation)")
        //翻转图片
        self.image =  UIImage(CGImage:srcImage.CGImage!,
                                 scale:srcImage.scale,
                                 orientation:UIImageOrientation(rawValue: flipImageOrientation)!
        )
        
        //图片显示
        cardImageView.image = self.image
    
    
    }
    
    
    func uploadCard(sender:UITapGestureRecognizer){
        print("点击上传按钮事件")
        let filename = "/Card/" + cardItem.unid+".png"
        //登陆成功后，上传日志
        if(self.txtName.text == ""){
            PKNotification.toast("姓名不允许为空!")
        }else{
            let text = "请稍候，正在上传中..."
            //self.showWaitOverlayWithText(text)
            SwiftOverlays.showBlockingWaitOverlayWithText(text)
            
            let imageurl = DaiFileManager.document[filename].getAttr("C_ImageUrl")
            print(imageurl)
            if imageurl == "" {
                //DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_Title", value: self.txtTitle.text!)
                //DaiFileManager.document["/Audio/"+self.audioFileName].setAttr("C_Desc", value: self.txtDesc.text!)
               
                //let filePath = DaiFileManager.document[filename].path
                 //print("上传文件开始 --------------\(filePath)")
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardDetail.HandleNetworkResult(_:)), name: Config.RequestTag.PostUploadCardFile, object: nil)
                NetworkEngine.sharedInstance.postUploadModuleFile(Config.URL.PostUploadCardFile, filename: filename, moduleName:"Card",tag: Config.RequestTag.PostUploadCardFile,key:filename)
            }else{
                print("直接发布Card")
                PKNotification.toast("直接发布Card")
                postCardRecord()
                
                //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardDetail.HandleNetworkResult(_:)), name: Config.RequestTag.GetWeiXinToken, object: nil)
                //NetworkEngine.sharedInstance.addRequestWithUrlString(Config.URL.GetWeiXinToken, tag: Config.RequestTag.GetWeiXinToken, useCache: false) 
            }
        }

        
    }
    
    func HandleNetworkResult(notify:NSNotification)
    {
        
        let result:Result = notify.valueForKey("object") as! Result
        print(result)
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: Config.RequestTag.PostUploadFile, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: result.tag, object: nil)
        
        if result.status == "Error" {
            print("-------post  error-------------")
            PKNotification.toast("名片 \(result.key) 上传失败")
            SwiftOverlays.removeAllBlockingOverlays()
            
        }else if result.status=="OK"{
            if result.tag == Config.RequestTag.PostUploadCardFile {
                        
                postCardRecord()
                
            }else if result.tag == Config.RequestTag.PostCardRecord{
                //result.userinfo as! String
               
                //print("OK userinfo= \(result.userinfo as! String)")
                DaiFileManager.document["Card/" + cardItem.unid+".png"].setAttr("C_UploadFlag", value: "Y")
                cardItem.uploadflag = "Y"
                self.floatButton.removeFromSuperview()
                //PKNotification.toast("名片上传成功")
                SwiftOverlays.removeAllBlockingOverlays()                
            }
            
            
            
        }
        
    }

    func postCardRecord(){
    
        //Audio文件保留上传的URL地址 
        DaiFileManager.document["Card/" + cardItem.unid+".png"].setAttr("C_ImageUrl", value: Config.URL.CardBaseURL + "Card/"+Message.shared.postUserName + "/" + cardItem.unid+".png")
        //PKNotification.toast(result.message)
         //PKNotification.toast("名片相片上传成功或已上传...")
       
        //print(result.message)
        
        //上传图片成功的话 再上传名片信息
        /*
         {
         "userldap":"weiwei",
         "unid": "A65D1847-6E81-44D5-B2C0-966F234F6249D",
         "name": "黄厚琳",
         "organization": "上海登岩信息科技有限公司222",
         "dept": "项目部22",
         "title": "项目经理22",
         "address": "上海市浦东南泉北路1015号222",
         "mobile": "18616829776",
         "tel": "61997565",
         "email": "houlin_huang@163.com",
         "imageurl": "https: //eqeq/icon.jpg",
         "comment": "OAOAOAOAOA",
         "website": "www.dy-info.com"
         }
         */
        
        let c_Name = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Name")
        let c_Address = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Address")
        let c_Comments = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Comment")
        let c_Email = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Email")
        let c_Company = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Company")
        let c_Dept = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Dept")
        let c_Mobile = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Mobile")
        let c_Tel = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Tel")
        let c_Title = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Title")
        let c_UNID = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_UNID")
        let c_Website = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Website")
        let c_Fax = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Fax")
        let c_Other = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Other")
        let c_Memo = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_Memo")

               
        let c_ImageUrl = DaiFileManager.document["Card/" + cardItem.unid+".png"].getAttr("C_ImageUrl")
        
        let json = "[{\"userldap\":\"\(Message.shared.postUserName)\",\"unid\":\"\(c_UNID)\",\"name\":\"\(c_Name)\",\"organization\":\"\(c_Company)\",\"dept\":\"\(c_Dept)\",\"title\":\"\(c_Title)\",\"address\":\"\(c_Address)\",\"mobile\":\"\(c_Mobile)\",\"tel\":\"\(c_Tel)\",\"email\":\"\(c_Email)\",\"imageurl\":\"\(c_ImageUrl)\",\"comments\":\"\(c_Comments)\",\"website\":\"\(c_Website)\",\"fax\":\"\(c_Fax)\",\"other\":\"\(c_Other)\",\"memo\":\"\(c_Memo)\"}]"
        print(json)
        
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(Config.Encoding.GB2312))
        //NSUTF8StringEncoding
        
        //这步是字符串的URLEncode
        let data = json.stringByAddingPercentEscapesUsingEncoding(enc)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CardDetail.HandleNetworkResult(_:)), name: Config.RequestTag.PostCardRecord, object: nil)
        
        NetworkEngine.sharedInstance.processRequestWithUrlString(Config.URL.PostCardRecord, postData:data!.dataUsingEncoding(enc)!,method:"post",contenttype:"application/json; charset=gb2312",tag:Config.RequestTag.PostCardRecord,key:"Card/" + cardItem.unid+".png")
        

    }
    
    func changeImageOrientation(srcImage:UIImage,orientation:Int) -> UIImage{
        
       
        let image:UIImage =  UIImage(CGImage:srcImage.CGImage!,
                              scale:srcImage.scale,
                              orientation:UIImageOrientation(rawValue: orientation)!)
        return image

        
   
    
    }
    
    
    
    func confirmCall(num:String){
        
        if num != "" {
            let btn_OK:PKButton = PKButton(title: "拨打",
                                           action: { (messageLabel, items) -> Bool in
                                            let urlstr = "tel://\(num)"
                                            //print("=========click==========\(urlstr)")
                                            let url1 = NSURL(string: urlstr)
                                            UIApplication.sharedApplication().openURL(url1!)
                                            return true
                },
                                           fontColor: UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0),
                                           backgroundColor: nil)
            
            // call alert
            PKNotification.alert(
                title: "通话确认",
                message: "确认拨打电话:\(num)?",
                items: [btn_OK],
                cancelButtonTitle: "取消",
                tintColor: nil)
            
        }
        
    }

}