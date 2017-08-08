//  
//  OrderViewController.swift  
//  GeLin  
//  
//  Created by 陈诚 on 16/3/14.  
//  Copyright © 2016年 陈诚. All rights reserved.  
//  

import Foundation  
import UIKit  

let kScreenWidth = UIScreen.mainScreen().bounds.width  
let kScreenHeight = UIScreen.mainScreen().bounds.height  

@objc(CardList) class CardList: UIViewController {  
    @IBOutlet var sg_Order: UISegmentedControl!  
    @IBOutlet var view_Order: UIView!  
    
    override func viewDidLoad() {//页面初始化代码,  
        super.viewDidLoad()  
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()  
        // NSLog("as","")  
        print("cardlist create")
        
        let orderservingview = CardFileList()//第一个用于切换的controller  
        
        //orderservingview.view.width(sel//根据用来切换的view的高宽调整页面内容的高宽  
        //orderservingview.view.height(self.view_Order.height())  
        
              
        [self.view_Order.addSubview(orderservingview.view)];  
        orderservingview.viewDidLoad()//在添加完视图以后启动视图加载函数,因为addSubview方法并不会自动启动页面加载，如果各位有什么更好的方法请告知~  
    }  
    
    
    
    @IBAction func onSegmentItemClicked(sender: AnyObject) {//点击segment切换页面函数  
        // NSLog(String(sender.selectedSegmentIndex),"")  
        switch(sender.selectedSegmentIndex){  
        case 0:  
            let array1 = [self.view_Order.subviews] as NSArray  
            if ([array1.count] == 2) {//如果用于切换页面的view中已经有了两个子页面，那么就去掉一个，这样可以实现segment的无限制次数的切换  
                array1.objectAtIndex(1).removeFromSuperview()  
            }  
            let orderservingview = CardFileList()  
            orderservingview.viewDidLoad()//同样在切换的时候需要启动页面加载函数  
            //orderservingview.view.width(self.view_Order.width())  
            [self.view_Order.addSubview(orderservingview.view)];  
            break;  
        case 1:  
            let array1 = [self.view_Order.subviews] as NSArray  
            if ([array1.count] == 2) {  
                array1.objectAtIndex(1).removeFromSuperview()  
            }  
            let orderhistoryview = CardMain()//第二个用于切换的controller  
            orderhistoryview.viewDidLoad()  
            //orderhistoryview.view.width(self.view_Order.width())  
            [self.view_Order.addSubview(orderhistoryview.view)];  
            break;  
        default:  
            break;  
            
        }  
    }  
    
    
}  