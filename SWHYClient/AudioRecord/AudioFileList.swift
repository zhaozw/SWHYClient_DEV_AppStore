//
//  AudioFileList.swift
//  SWHYClient_DEV
//
//  Created by sunny on 9/4/16.
//  Copyright © 2016 DY-INFO. All rights reserved.
//

import UIKit
@objc(AudioFileList) class AudioFileList: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate {
    var itemlist = [AudioFileItem]()
    var filteredItemList = [AudioFileItem]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
       
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init() {
         self.init(nibName: "AudioFileList", bundle: nil)

    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "录音库"
        print("view did load")
        //opensectionindex = NSNotFound
        //getaddress = false
        //getdept = false
        /*
         if Message.shared.loginType == "Online" {
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleNetworkResult:", name: Config.RequestTag.GetInnerAddressBook, object: nil)
         NetworkEngine.sharedInstance.addRequestWithUrlString(Config.URL.InnerAddressBook, tag: Config.RequestTag.GetInnerAddressBook,useCache:false)
         
         
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "HandleNetworkResult:", name: Config.RequestTag.GetInnerAddressBook_Dept, object: nil)
         NetworkEngine.sharedInstance.addRequestWithUrlString(Config.URL.InnerAddressBook_Dept, tag: Config.RequestTag.GetInnerAddressBook_Dept,useCache:false)
         }
         */
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        let _ = AudioListCell()
        let nib = UINib(nibName:"AudioListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        self.searchDisplayController?.searchResultsTableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        
        
        /*
         if let data:AnyObject = DBAdapter.shared.queryInnerAddressList("'1'=?", paralist: ["1"]) {
         //self.fillViewFromSql = true
         self.itemlist = data as! [InnerAddressItem]
         self.getaddress = true
         }
         
         if let deptdata:AnyObject = DBAdapter.shared.queryInnerAddressDeptList("'1'=?", paralist: ["1"]) {
         //self.fillViewFromSql = true
         self.deptlist = deptdata as! [InnerAddressDeptItem]
         self.getdept = true
         
         }
         */
        //ComputeAddressInfo()
        
        
    }
    
    func getFileList(){
        //self.items = DaiFileManager.document["/Audio/"].files.all()
        self.itemlist.removeAll()
        var items = DaiFileManager.document["/Audio/"].files.filter(".mp3")
        
        
        if items.isEmpty {
            print("audio file list empty")
            //self.itemlist = nil
        } else{
            
            for (index, elem ) in items.enumerate() {
                
                let audioFileItem:AudioFileItem = AudioFileItem()
                
                //print(elem)
                audioFileItem.title = DaiFileManager.document["/Audio/"+elem].getAttr("C_Title")
                audioFileItem.filename = elem
                audioFileItem.description = DaiFileManager.document["/Audio/"+elem].getAttr("C_Desc")
                audioFileItem.url = DaiFileManager.document["/Audio/"+elem].getAttr("C_URL")
                audioFileItem.duration = DaiFileManager.document["/Audio/"+elem].getAttr("C_Duration")
                
                audioFileItem.query = audioFileItem.title + audioFileItem.description
                
                self.itemlist.append(audioFileItem)
                
            } 
            
            //self.itemlist.addObject(audioFileItem)
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let backitem = UIBarButtonItem(title: Config.UI.PreNavItem, style: UIBarButtonItemStyle.Plain, target: self, action: "returnNavView")
        self.navigationItem.leftBarButtonItem = backitem
        
        //let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        //let innerAddressViewController = storyboard.instantiateViewControllerWithIdentifier("InnerAddresMenuViewController") as! InnerAddressMenuViewController
        //self.slideMenuController()?.changeRightViewController(innerAddressViewController, closeRight: true)
        //self.setNavigationBarItem()
        print("table reload data")
        getFileList()
        self.tableView.reloadData()
    }
    
    func returnNavView(){
        let audioRecorderViewController:AudioRecorder = AudioRecorder()
        let nvc=UINavigationController(rootViewController:audioRecorderViewController);
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return 1
            
        } else {
            return 1
        }
        
    }
    
    // UITableViewDataSource Functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.filteredItemList.count
        } else {
            return self.itemlist.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 在tableview中查询一个条目，如果没有创建一个。
       
        // 从我们的糖果数组中获得相应的内容
        var item:AudioFileItem
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            //print("cell for search")
            item = filteredItemList[indexPath.row]
            
        } else {
            //print("cell for content")
            item = self.itemlist[indexPath.row] as AudioFileItem
        }
        
        let cell:AudioListCell! = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? AudioListCell
       
        //cell.textLabel?.text = item.name
        
        cell.title.text = item.title == "" ? item.filename : item.title
       
        if item.url == ""{
            cell.icon?.image = UIImage(named: "audio")
        }else{
            cell.icon?.image = UIImage(named: "audio_cloud")
        }
        
        cell.duration.text = item.duration
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //println("---end cellForRowAtIndexPath section----")
       
        return cell
         
    }

    func filterContentForSearchText(searchText: String) {
        // 使用过滤方法过滤数组 陈陈
        print("filterContentForSearchText \(searchText)")
        self.filteredItemList = self.itemlist.filter({( audioFileItem: AudioFileItem) -> Bool in
            let stringMatch = audioFileItem.query.rangeOfString(searchText)
              return (stringMatch != nil)
        })
    }
    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool { 
        print("searchDisplayController = \(searchString)")
        self.filterContentForSearchText(searchString!)
        return true   
    }
    
    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        print("searchDisplayController Search Scope")
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true 
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("did select row at index path =\(indexPath)")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var item:AudioFileItem
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            item = self.filteredItemList[indexPath.row] as AudioFileItem
 
        } else {
            item = self.itemlist[indexPath.row] as AudioFileItem
            
        }

        let nextController:AudioDetail = AudioDetail()
        Message.shared.audioFileName = self.itemlist[indexPath.row].filename
        self.navigationController?.pushViewController(nextController,animated:false);
    } 
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
        //var searchBarTextField : UITextField? = nil
        for mainview in searchBar.subviews
        {
            for subview in mainview.subviews {
                if subview.isKindOfClass(UIButton)
                {
                    let cancelbutton = subview as? UIButton
                    cancelbutton?.setTitle("取消", forState: UIControlState.Normal)
                    break
                }
            }
        }
        
    }
        
}
