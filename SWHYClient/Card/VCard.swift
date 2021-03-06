//
//  VCard.swift
//  SwiftyVCard
//
//  Created by Ruslan on 29.10.15.
//  Copyright © 2015 GRG. All rights reserved.
//

import Foundation

public class VCard {
    private var scanner: NSScanner!
    
    public var firstName = ""
    public var secondName = ""
    public var lastName = ""
    //public var photo: UIImage!
    //public var logo: UIImage!
    public var eMail = ""
    public var title = ""
    public var tel = ""
    public var mobile = ""
    public var fax = ""
    public var company = ""
    public var website = ""
  
    public var address = ""
   
    
    public var vCardRepresentation: String {
        var result =  "BEGIN:VCARD\r\n" +
        "VERSION:4.0\r\n"
        
        if !firstName.isEmpty || !secondName.isEmpty || !lastName.isEmpty {
            result +=   "\(VCardProperty.N.rawValue):\(lastName);\(firstName);\(secondName);\r\n"
        }
        /*
        if photo != nil {
            if let base64Data = UIImagePNGRepresentation(photo)?.base64EncodedDataWithOptions([]) {
                if let base64String = String(data: base64Data, encoding: NSUTF8StringEncoding) {
                    result += "\(VCardProperty.PHOTO.rawValue):data:image/png;base64,\(base64String)"
                }
            }
        }
        
        if logo != nil {
            if let base64Data = UIImagePNGRepresentation(logo)?.base64EncodedDataWithOptions([]) {
                if let base64String = String(data: base64Data, encoding: NSUTF8StringEncoding) {
                    result += "\(VCardProperty.LOGO.rawValue):data:image/png;base64,\(base64String)\r\n"
                }
            }
        }
 */
        
        if !title.isEmpty {
            result += "\(VCardProperty.TITLE.rawValue):\(title)\r\n"
        }
        
        if !company.isEmpty {
            result += "\(VCardProperty.ORG.rawValue):\(company)\r\n"
        }
        
        if !website.isEmpty {
            result += "\(VCardProperty.URL.rawValue):\(website)\r\n"
        }
        
        if !tel.isEmpty {
            result += "\(VCardProperty.TEL.rawValue):\(tel)\r\n"
        }
        
        if !address.isEmpty {
            result += "\(VCardProperty.ADR.rawValue):\(address);;;;;\r\n"
        }
        /*
        
        if !facebook.isEmpty {
            result += "\(VCardProperty.FACEBOOK.rawValue):\(facebook)\r\n"
        }
        
        if !skype.isEmpty {
            result += "\(VCardProperty.SKYPE.rawValue):\(skype)\r\n"
        }
        
        if !instagram.isEmpty {
            result += "\(VCardProperty.INSTAGRAM.rawValue):\(instagram)\r\n"
        }
        
        if !linkedIn.isEmpty {
            result += "\(VCardProperty.LINKEDIN.rawValue):\(linkedIn)\r\n"
        }
        
        if !twitter.isEmpty {
            result += "\(VCardProperty.TWITTER.rawValue):\(twitter)\r\n"
        }
        */
        result += "END:VCARD\r\n"
        
        return result
    }
    
    public init() {}
    
    public init(vCardString: String) {
        fillFromVCardString(vCardString)
    }
    
    func fillFromVCardString(string: String) {
        let preparedString = string.stringByReplacingOccurrencesOfString("\r\n ", withString: "").stringByReplacingOccurrencesOfString("\r\n\t", withString: "").stringByReplacingOccurrencesOfString("\n ", withString: "").stringByReplacingOccurrencesOfString("\n\t", withString: "")
        
        print("==scan string \(preparedString)")
        
        scanner = NSScanner(string: preparedString)
        scanner.charactersToBeSkipped = NSCharacterSet()
        
        guard scanBegin() else { return }
        guard scanNewLine() else { return }
        guard scanVersion() else { return }
        guard scanNewLine() else { return }
        
        print("=====Scan Begin ===================\(scanner.atEnd)")
        
        while !scanner.atEnd {
            print("--------scan ------------------")
            //guard let property = scanProperty() else { return }
            guard let property = scanProperty() else { continue }
             print("--------scan -----property-------\(property)------")
            guard let value = scanValue() else {
                scanNewLine()
                continue
            }
            print("scan property \(property) = \(value)")
            switch property {
            case .N:
                parseNValue(value)
            /*
            case .PHOTO:
                parsePhotoValue(value)
             */   
            case .TITLE:
                parseTitleValue(value)
            case .MOBILE:
                parseMobileValue(value)
            case .FAX:
                parseFaxValue(value)
                
            case .EMAIL:
                parseEmailValue(value)
                
            case .ORG:
                parseOrgValue(value)
                
            case .URL:
                parseUrlValue(value)
                
            case .TEL:
                parseTelValue(value)
                
            case .ADR:
                parseAdrValue(value)
            /*    
            case .FACEBOOK:
                parseFacebookValue(value)
                
            case .SKYPE:
                parseSkypeValue(value)
                
            case .INSTAGRAM:
                parseInstagramValue(value)
                
            case .LINKEDIN:
                parseLinkedInValue(value)
                
            case .TWITTER:
                parseTwitterValue(value)
                
            case .LOGO:
                parseLogoValue(value)
            */
            default:
                break
            }
            
            scanNewLine()
        }
    }
    
    private func scanNewLine() -> Bool {
        return scanner.scanCharactersFromSet(NSCharacterSet.newlineCharacterSet(), intoString: nil)
    }
    
    private func scanBegin() -> Bool {
        return scanner.scanString("BEGIN:VCARD", intoString: nil)
    }
    
    private func scanVersion() -> Bool {
       
        //return scanner.scanString("VERSION:4.0", intoString: nil)
        return scanner.scanString("VERSION:2.1", intoString: nil)
    }
    
    private func scanProperty() -> VCardProperty? {
        var propertyName: NSString?
        scanner.scanUpToString(":", intoString: &propertyName)
        print("---uptostring: \(propertyName)")
        scanner.scanString(":", intoString: nil)
        
        print("---scanstring: \(propertyName)")
        
        if let thePropertyName = propertyName as? String {
            let property = VCardProperty(rawValue: thePropertyName)
            print("property is \(property)")
            return property
        }
        return nil
    }
    
    private func scanValue() -> String? {
        var value: NSString?
        scanner.scanUpToCharactersFromSet(NSCharacterSet.newlineCharacterSet(), intoString: &value)
        
        return value as? String
    }
    
    private func parseNValue(value: String) {
        let namesArray = value.componentsSeparatedByString(";")
        (lastName, firstName, secondName) = (namesArray[0], namesArray[1], namesArray[2])
    }
    
    //private func parsePhotoValue(value: String) {
    //   photo = imageFromValue(value)
    //}
    
    //private func parseLogoValue(value: String) {
    //    logo = imageFromValue(value)
    //}
    
    private func imageFromValue(value: String) -> UIImage? {
        let regPattern = "data:image/(jpg|jpeg|png);base64,(.*)"
        do {
            let regExp = try NSRegularExpression(pattern: regPattern, options: [])
            if let result = regExp.firstMatchInString(value,
                                                      options: [],
                                                      range: NSMakeRange(0, value.characters.count)) {
                let fileExtension = (value as NSString).substringWithRange(result.rangeAtIndex(1))
                let base64Image = (value as NSString).substringWithRange(result.rangeAtIndex(2))
                
                if let imageData = NSData(base64EncodedString: base64Image, options: []) {
                    return UIImage(data: imageData)
                }
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func parseEmailValue(value: String) {
        eMail = value
    }
    
    private func parseTitleValue(value: String) {
        title = value
    }
    
    private func parseMobileValue(value: String) {
        mobile = value
    }
    private func parseFaxValue(value: String) {
        fax = value
    }
    private func parseOrgValue(value: String) {
        company = value
    }
    
    private func parseUrlValue(value: String) {
        website = value
    }
   
    private func parseTelValue(value: String) {
        tel = value
    }
    
    private func parseAdrValue(value: String) {
        address = value.componentsSeparatedByString(";").filter{!$0.isEmpty}.joinWithSeparator(", ")
    }
     /*
    private func parseFacebookValue(value: String) {
        facebook = value
    }
    
    private func parseSkypeValue(value: String) {
        skype = value
    }
    
    private func parseInstagramValue(value: String) {
        instagram = value
    }
    
    private func parseLinkedInValue(value: String) {
        linkedIn = value
    }
    
    private func parseTwitterValue(value: String) {
        twitter = value
    }
    */
    private func scanEnd() -> Bool {
        return scanner.scanString("END:VCARD", intoString: nil)
    }
    
}

extension VCard: CustomStringConvertible {
    public var description: String {
        let result =  "firstName: \(firstName)\n" +
            "secondName: \(secondName)\n" +
            "lastName: \(lastName)\n" +
            "title: \(title)\n" +
            "company: \(company)\n" +
            "website: \(website)\n" +
            "address: \(address)\n" //+
            //"facebook: \(facebook)\n" +
            //"skype: \(skype)\n" +
            //"instagram: \(instagram)\n" +
            //"linkedIn: \(linkedIn)\n" +
           // "twitter: \(twitter)"
        return result
    }
}
