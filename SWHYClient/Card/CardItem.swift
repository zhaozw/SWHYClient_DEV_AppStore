//
//  CardItem.swift
//  SWHYClient_DEV
//
//  Created by sunny on 8/6/17.
//  Copyright © 2017 DY-INFO. All rights reserved.
//


import Foundation
class CardItem {
    
    var unid:String!
    var address :String!
    var name:String!
    var memo:String!
    var tel:String!
    var mobile:String!
    var email:String!
    var title:String!
    var role:String!
    var company:String!
    var dept:String!
    var website:String!
    var sns:String!
    var im:String!
    var imageurl:String!
    var other:String!
    var fax:String!
    
    
    var query:String!
    var filename:String!
    
    var rotation_angle:String!  //拍照返回的原始图片方向 
    var imageOrientation:String!  //用户调整保存后的图片方向
    
    var uploadflag:String!  //是否已上传
    var saveflag:String!    //是否已经保存
    
    init(){
    
    //self.imageOrientation = "0"
    //self.rotation_angle = "0"
        self.tel = ""
        self.mobile = ""
        self.other = ""
    }
}