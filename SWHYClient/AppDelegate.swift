//
//  AppDelegate.swift
//  SWHYClient
//
//  Created by sunny on 3/21/15.
//  Copyright (c) 2015 DY-INFO. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {
    
    var window: UIWindow?
    //let router = SHNUrlRouter()
    
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        print(" catch universal url")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            print("userActivity.webpageURL = \(userActivity.webpageURL)")
            let url = userActivity.webpageURL
            if url != nil{
                let queryUrl:String? = url!.query
                print ("url = \(url!.query)")
                
                let range=queryUrl?.rangeOfString("url=", options: NSStringCompareOptions()) //Swift 2.0
                let startIndex=range?.endIndex 
                if queryUrl != nil{
                    let dispatchUrl:String?=queryUrl?.substringFromIndex((startIndex)!) //Swift 2.0
                    print ("dispatchUrl = \(dispatchUrl)")
                    self.dispatchView((dispatchUrl!))
                }else{
                    self.dispatchView((""))
                }
            }else{
                self.dispatchView((""))
            }
            
        }
        //self.router.dispatch(url)
        return true
    }
    
    /*
     func bindRoutes(){
     //let storyboard = UIStoryboard(name: "Main", bundle: nil)
     //let root = self.window?.rootViewController
     
     router.register("/swinbak/openapp.html") { (params) -> Void in
     //let list: AuthorsTableViewController = storyboard.instantiateViewControllerWithIdentifier("AuthorsTableViewController") as! AuthorsTableViewController
     print(" do universal url --- /ios/openapp")
     //let webview:WebViewController = WebViewController()
     
     //root!.navigationController?.pushViewController(webview, animated: true)
     self.dispatchView("")
     }
     
     /*
     router.register("/authors/{id}") { (params) -> Void in
     let profileVC: AuthorProfileViewController = storyboard.instantiateViewControllerWithIdentifier("AuthorProfileViewController") as! AuthorProfileViewController
     profileVC.authorID = Int(params["id"]!)
     root.pushViewController(profileVC, animated: true)
     }
     
     router.register("/authors/{id}/books") { (params) -> Void in
     let list: BooksTableViewController = storyboard.instantiateViewControllerWithIdentifier("BooksTableViewController") as! BooksTableViewController
     list.authorID = Int(params["id"]!)
     root.pushViewController(list, animated: true)
     }
     */
     
     }    
     */
    
    func dispatchView(url:String){
        print("dispatchview")
        let tmpchkpassword: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("ChkPassword") as! Bool? 
        if tmpchkpassword == true{
            Message.shared.loginType = "Online"
            Message.shared.postUserName = NSUserDefaults.standardUserDefaults().objectForKey("UserName") as! String
            Message.shared.postPassword = (NSUserDefaults.standardUserDefaults().objectForKey("Password") as? String)!
            
            if url==""{
                //UIApplication.sharedApplication().keyWindow?.rootViewController = nvc
                let mainViewController:MainViewController = MainViewController()
                let nvc=UINavigationController(rootViewController:mainViewController);
                
                let storyboard = UIStoryboard(name: "Setting", bundle: nil)
                let rightViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
                
                let slideMenuController = SlideMenuController(mainViewController: nvc, rightMenuViewController: rightViewController)
                UIApplication.sharedApplication().keyWindow?.rootViewController = slideMenuController
            }else{
                let webViewController:WebViewController = WebViewController()
                
                //let aClass = NSClassFromString(arrobj.classname) as! UIViewController.Type
                //let aObject = aClass.init() as UIViewController
                var menuItem:MainMenuItemBO = MainMenuItemBO()
                menuItem.name = ""
                menuItem.uri = "http://"+url
                print("url ==================\(url)")
                Message.shared.curMenuItem = menuItem
                //记录模块访问日志
                /*
                 let accessLogItem = AccessLogItem()
                 accessLogItem.userid = NSUserDefaults.standardUserDefaults().objectForKey("UserName") as! String
                 accessLogItem.online = Message.shared.loginType == "Online" ? "true" : "false"
                 accessLogItem.moduleid = arrobj.id
                 accessLogItem.time = Util.getCurDateString()
                 accessLogItem.type = "OpenModule"
                 accessLogItem.modulename = arrobj.name
                 
                 DBAdapter.shared.syncAccessLogItem(accessLogItem)
                 */
                //aObject.title = arrobj.name
                //self.navigationController?.pushViewController(webViewController,animated:false);
                self.window!.rootViewController = webViewController
            }
        }
        else{
            //这里应该是空 还是会默认到登陆界面 
            
        }
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print ("launch options fun do")
        let logview:LoginViewController = LoginViewController()
        self.window!.rootViewController = logview        
        
        //self.window?.makeKeyAndVisible;
        self.window!.backgroundColor = UIColor.whiteColor()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = Util.uicolorFromHex(0xffffff)
        
        //0x298EB1
        navigationBarAppearace.barTintColor = Util.uicolorFromHex(0x067AB5)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        //初始化sqlite 判断是否有表
        let result = DBAdapter.shared.initTable()
        //println(result)
        //bindRoutes()
        WXApi.registerApp("wxfd085868c9f9f3d7") //改成你实际的AppID
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        //print("-----------appliction Will Resign Active--------------")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.saveContext()
        //print("-----------appliction Did Enter Background--------------")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //print("-----------appliction Will Enter Foreground--------------")
        if Message.shared.logout == true {
            let logview:LoginViewController = LoginViewController()
            self.window!.rootViewController = logview
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //print("-----------appliction Did Become Active--------------")
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        //print("-----------appliction Will Terminate--------------")
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.simpleflow.SWHYClient" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CoreDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        print("application HandleOpenURL 111= \(url)")
        return WXApi.handleOpenURL(url, delegate: self)
        //return CCOpenAPI.handleOpenURL(url, sourceApplication: <#T##String!#>)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        print("application HandleOpenURL 222= \(url) sourceapp \(sourceApplication)")
        if url.scheme == NSURLFileScheme {
            print("Started downloading file from \(url)")
            do {
                //let documentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
                let fileNameFromURL = url.lastPathComponent
                let documentDirectoryPath: String = DaiFileManager.document["/Audio/"].path
                let filePathForDocs = String(format:"%@%@", documentDirectoryPath, fileNameFromURL! as String)
                
                print("filePathForDocs = \(filePathForDocs)")
                
                let fileData = try NSData(contentsOfURL: url, options: NSDataReadingOptions())
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    fileData.writeToFile(filePathForDocs, atomically: true)
                    print("File saved")
                }
                
            }
            catch {
                print("I am not able to download this file")
            }
            return false;
        }else{
            //return WXApi.handleOpenURL(url, delegate: self)
            return CCOpenAPI.handleOpenURL(url, sourceApplication: sourceApplication)
        } 
   }

    func onReq(req: BaseReq!) {
        //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    }
    
    func onResp(resp: BaseResp!) {
        //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    }
    
}