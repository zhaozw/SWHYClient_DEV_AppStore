import UIKit

class AudioRecorderMenuViewController : UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var btnAudioList: UIView!
    @IBOutlet weak var btnLogout: UIView!
    var fileViewController: UIViewController!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap_audiolist:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onClickEvent_AudioList:")
        btnAudioList.addGestureRecognizer(tap_audiolist)
        
        let tap_logout:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onClickEvent_Logout:")
        btnLogout.addGestureRecognizer(tap_logout)
        
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
    
    func onClickEvent_AudioList(sender:UITapGestureRecognizer!){
        print("click audiolist button")
        //let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        //let settingController = storyboard.instantiateViewControllerWithIdentifier("SettingMenuController") as! SettingViewController
        
        let fileViewController:FileViewController = FileViewController()
        self.fileViewController = UINavigationController(rootViewController: fileViewController)
        //self.navigationController?.pushViewController(self.fileViewController, animated: true)
        self.slideMenuController()?.changeMainViewController(self.fileViewController, close: true)
        //self.slideMenuController()?.showViewController(self.fileViewController, sender: nil)
    }
    
    
    func onClickEvent_Logout(sender:UITapGestureRecognizer!){
        print("click Logout button")
        
        self.slideMenuController()?.closeRight()
        let btn_OK:PKButton = PKButton(title: "登出",
                                       action: { (messageLabel, items) -> Bool in
                                        print("=========click==========)")
                                        //===code here
                                        Message.shared.logout = true
                                        exit(0)
                                        //self.removeAddressFromSystemContact()
                                        //return true
            },
                                       fontColor: UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0),
                                       backgroundColor: nil)
        
        // call alert
        PKNotification.alert(
            title: "退出程序",
            message: "确认退出本程序?",
            items: [btn_OK],
            cancelButtonTitle: "取消",
            tintColor: nil)
        
    }
    
    
}