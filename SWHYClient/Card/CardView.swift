//
//  CardView.swift
//  SWHYClient_DEV
//
//  Created by sunny on 4/24/17.
//  Copyright © 2017 DY-INFO. All rights reserved.
//

import Foundation
@objc(CardView) class CardView: UIViewController {

    var cardImage:UIImage
    var cardString:String
    
    @IBOutlet weak var txtCard: UITextView!
    @IBOutlet weak var imgCard: UIImageView!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        self.cardImage = UIImage()
        self.cardString = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init() {
        
        self.init(nibName: "CardView", bundle: nil)
        //self.init(nibName: "LaunchScreen", bundle: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCard.text = cardString
        imgCard.image = cardImage
       
    }




}