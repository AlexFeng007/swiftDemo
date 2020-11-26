//
//  FKYEnvironment.swift
//  FKYNetwork
//
//  Created by yangyouyong on 2016/8/4.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit

class FKYEnvironmentation: NSObject {
    
    let userAgent: String = {
            // 'User-Agent: FKYNetwork/1.0 (iPhone; iOS 9.3 ; Scale/2.0)'
            if let info = Bundle.main.infoDictionary {
                
                let executable: AnyObject = info[kCFBundleExecutableKey as String] as AnyObject
                let model = UIDevice.current.model
                let sysVersion = UIDevice.current.systemVersion
                let bundleVersion = info["CFBundleShortVersionString"]!
                
                let mutableUserAgent = NSMutableString(string: "\(executable)/\(bundleVersion) (\(model); iOS \(sysVersion) ; Scale/\(UIScreen.main.scale))") as CFMutableString
                let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
                
                if CFStringTransform(mutableUserAgent, nil, transform, false) {
                    return mutableUserAgent as String
                }
            }
            
            return "FKYNetwork"
    }()
    
    // 'Accept-Language: zh-Hans-US;,en-US;'
    let acceptLanguage: String = {
        
        var acceptLanguageComponents = [String]()
        for obj in Locale.preferredLanguages {
            let formatString = String.localizedStringWithFormat("\(obj);")
            acceptLanguageComponents.append(formatString)
        }
        return String(NSMutableArray(array: acceptLanguageComponents).componentsJoined(by: ","))
        
    }()
    
    @objc let station: String = {
        let str = UserDefaults.standard.value(forKey: "currentStation")
        if str != nil { return String(describing: str!) }
        return "000000"
    }()
    
    let stationName: String = {
        let stationNameObj = UserDefaults.standard.value(forKey: "currentStationName")
        if let stationName = stationNameObj as? String, "" != stationName {
            return stationName
        }
        return "默认"
    }()
    
    let token: String = {
        let str = UserDefaults.standard.value(forKey: "user_token")
        if str != nil { return String(describing: str!) }
        return ""
    }()
    
    let api_version: String = {
      return "v1.2"
    }()
    
    let app_version: String = {
        if let appVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            return appVersion
        }
        return "0"
    }()
}
