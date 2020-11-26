//
//  FKYGlobalDefines.swift
//  FKY
//
//  Created by yangyouyong on 16/1/13.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
//import SCSwift

let SCREEN_SIZE = UIScreen.main.bounds.size
let IS_IPHONEXS_MAX = SCREEN_SIZE.equalTo(CGSize(width: 414, height: 896))
let IS_IPHONEXR = SCREEN_SIZE.equalTo(CGSize(width: 414, height: 896))
let IS_IPHONEX = SCREEN_SIZE.equalTo(CGSize(width: 375, height: 812))
let IS_IPHONE6 = SCREEN_SIZE.equalTo(CGSize(width: 375, height: 667))
let IS_IPHONE6PLUS = SCREEN_SIZE.equalTo(CGSize(width: 414, height: 736))
let IS_IPHONE5 = SCREEN_SIZE.equalTo(CGSize(width: 320, height: 568))
let IS_IPHONE4 = SCREEN_SIZE.equalTo(CGSize(width: 320, height: 480))
let IS_IPAD = UI_USER_INTERFACE_IDIOM() == .pad
let IS_RETINA = UIScreen.main.scale >= 2.0

let SCREEN_WIDTH = SCREEN_SIZE.width
let SCREEN_HEIGHT = SCREEN_SIZE.height

let Height_TabBar = CGFloat(IS_IPHONEX ? 83.0 : 49.0)

let MAX_CartCoutForZiYing = 9999999

let DOCUMENT_PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

let FKYAppDelegate = UIApplication.shared.delegate as? AppDelegate

// SYSTEM Version
func iOS9Later() -> Bool {
    if ((UIDevice.current.systemVersion as NSString).floatValue >= 9.0) {
        return true
    }
    return false
}

func WH(_ length: CGFloat) -> CGFloat {
    if IS_IPHONE6 || IS_IPHONEX {
        return length
    }
    else if (IS_IPHONE5 || IS_IPHONE4) {
        return length * (320.0 / 375.0)
    }
    else if (IS_IPHONE6PLUS || IS_IPHONEXR || IS_IPHONEXS_MAX) {
        return length * (414.0 / 375.0)
    }
    else if (IS_IPAD) {
        if IS_RETINA {
            return length * (768.0 / 375.0)
        }
        else {
            return length * (384.0 / 375.0)
        }
    }

    return length
}

func SystemFont(_ length: CGFloat) -> UIFont {
    if iOS9Later(){
         return UIFont.systemFont(ofSize: length)
    }
    return UIFont.init(name: "PingFangSC-Regular", size: length)!
}

func SystemBoldFont(_ length: CGFloat) -> UIFont {
    if iOS9Later(){
        return UIFont.boldSystemFont(ofSize: length)
    }
    return UIFont.init(name: "PingFangSC-Medium", size: length)!
}

private func FKY_PREFER_HOST() -> String {
    return "https://mobile.test.fangkuaiyi.com/json"
}

private func FKY_NORMAL_HOST() -> String {
    return "https://mobile.fangkuaiyi.com/json"
}

func RGBColor(_ rgbValue: UInt) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0, blue: CGFloat(rgbValue & 0x0000FF)/255.0, alpha: 1.0)
}

func RGBAColor(_ rgbValue: UInt, alpha: Float) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0, blue: CGFloat(rgbValue & 0x0000FF)/255.0, alpha: CGFloat(alpha))
}

// MARK:-
// MARK: UI设计规范

// MARK: 背景样式 bgcolor
let bg1 = RGBColor(0xffffff)
let bg2 = RGBColor(0xf4f4f4)
let bg3 = RGBColor(0xfe5050)
let bg4 = RGBColor(0xf8f8f8)
let bg5 = RGBColor(0xf7f7f7)
let bg6 = RGBColor(0xf4fcf1)
let bg7 = RGBColor(0xe5e5e5)
let bg8 = RGBColor(0xf5f5f5)
let bg9 = RGBColor(0xfe5050)

// MARK: 描边样式 borderColor
let m1 = RGBColor(0xeaecee)
let m2 = RGBColor(0xebedec)
let m3 = RGBColor(0xbbbbbb)
let m4 = RGBColor(0x81869e)

// MARK: 搜索样式
class SearchBarStyle {
    let height = WH(23)
    let bgColor = RGBColor(0xf4f4f4)
    let borderColor = RGBColor(0xebedec)
    let borderWidth = 1
    let placeholderColor = RGBColor(0x999999)
    let textColor = RGBColor(0x666666)
}

class s1: SearchBarStyle {
    let width = WH(255)
}

class s2: SearchBarStyle {
    let width = WH(305)
}

let lineHeight = WH(0.5)


// MARK: 间距样式
let j1 = WH(10)
let j2 = WH(7.5)
let j3 = WH(5.5)
let j4 = WH(5)
let j5 = WH(15)
let j6 = WH(55)
let j7 = WH(25)
let j8 = WH(20)
let j9 = WH(45)
let j10 = WH(65)
let j11 = WH(2)
let j12 = WH(9)


// MARK: 图片样式
let bn = (width: SCREEN_WIDTH, height: WH(115))
let p1 = (width: WH(42), height: WH(42))
let p2 = (width: WH(100), height: WH(118))
let p3 = (width: WH(180), height: WH(90))
let p4 = (width: WH(182.5), height: WH(185))
let p5 = (width: WH(80), height: WH(80))
let p6 = (width: WH(365), height: WH(102))
let p7 = (width: WH(0), height: WH(35)) // width 为auto 使用时需更改
let p8 = (width: WH(200), height: WH(200))


// MARK: 文字样式
typealias labelTuple = (color: UIColor, font: UIFont)

let t1 = (color:RGBColor(0xffffff),font:UIFont.systemFont(ofSize: WH(13)))
let t2 = (color:RGBColor(0xff5450),font:UIFont.systemFont(ofSize: WH(15)))
let t3 = (color:RGBColor(0x666666),font:UIFont.systemFont(ofSize: WH(12)))
let t4 = (color:RGBColor(0x61a8ea),font:UIFont.systemFont(ofSize: WH(15)))
let t5 = (color:RGBColor(0x4cc2cb),font:UIFont.systemFont(ofSize: WH(15)))
let t6 = (color:RGBColor(0xffa163),font:UIFont.systemFont(ofSize: WH(15)))
let t7 = (color:RGBColor(0x333333),font:UIFont.systemFont(ofSize: WH(14)))
let t8 = (color:RGBColor(0x666666),font:UIFont.systemFont(ofSize: WH(13)))
let t9 = (color:RGBColor(0x333333),font:UIFont.systemFont(ofSize: WH(13)))
let t10 = (color:RGBColor(0xe60012),font:UIFont.systemFont(ofSize: WH(15)))

let t11 = (color:RGBColor(0x999999),font:UIFont.systemFont(ofSize: WH(12)))
let t12 = (color:RGBColor(0xbf990b),font:UIFont.systemFont(ofSize: WH(15)))
let t13 = (color:RGBColor(0xe60012),font:UIFont.systemFont(ofSize: WH(14)))
let t14 = (color:RGBColor(0x333333),font:UIFont.systemFont(ofSize: WH(18)))
let t15 = (color:RGBColor(0xe60012),font:UIFont.systemFont(ofSize: WH(18)))
let t16 = (color:RGBColor(0x666666),font:UIFont.systemFont(ofSize: WH(14)))
let t17 = (color:RGBColor(0x3f4257),font:UIFont.boldSystemFont(ofSize: WH(16)))
let t18 = (color:RGBColor(0x3f4257),font:UIFont.systemFont(ofSize: WH(13)))
let t19 = (color:RGBColor(0xe60012),font:UIFont.systemFont(ofSize: WH(14)))
let t20 = (color:RGBColor(0x999999),font:UIFont.systemFont(ofSize: WH(13)))

let t21 = (color:RGBColor(0x3f4257),font:UIFont.boldSystemFont(ofSize: WH(14)))
let t22 = (color:RGBColor(0x3f4257),font:UIFont.systemFont(ofSize: WH(12)))
let t23 = (color:RGBColor(0x999999),font:UIFont.systemFont(ofSize: WH(14)))
let t24 = (color:RGBColor(0x3f4257),font:UIFont.systemFont(ofSize: WH(14)))
let t25 = (color:RGBColor(0x999999),font:UIFont.systemFont(ofSize: WH(11)))
let t26 = (color:RGBColor(0x666666),font:UIFont.systemFont(ofSize: WH(11)))
let t27 = (color:RGBColor(0x3f4257),font:UIFont.boldSystemFont(ofSize: WH(12)))
let t28 = (color:RGBColor(0x999999),font:UIFont.systemFont(ofSize: WH(10)))
let t29 = (color:RGBColor(0x4a8cf9),font:UIFont.systemFont(ofSize: WH(10)))
let t30 = (color:RGBColor(0x4a8cf9),font:UIFont.systemFont(ofSize: WH(13)))

let t31 = (color:RGBColor(0x333333),font:UIFont.systemFont(ofSize: WH(12)))
let t32 = (color:RGBColor(0xe60012),font:UIFont.systemFont(ofSize: WH(12)))
let t33 = (color:RGBColor(0x999999),font:UIFont.boldSystemFont(ofSize: WH(14)))
let t34 = (color:RGBColor(0xffffff),font:UIFont.systemFont(ofSize: WH(14)))
let t35 = (color:RGBColor(0xbf990b),font:UIFont.systemFont(ofSize: WH(13)))
let t36 = (color:RGBColor(0x333333),font:UIFont.systemFont(ofSize: WH(16)))
let t37 = (color:RGBColor(0x666666),font:UIFont.systemFont(ofSize: WH(16)))
let t38 = (color:RGBColor(0x4a8cf9),font:UIFont.systemFont(ofSize: WH(12)))
let t39 = (color:RGBColor(0xe60012),font:UIFont.systemFont(ofSize: WH(11)))
let t40 = (color:RGBColor(0xFE403B),font:UIFont.systemFont(ofSize: WH(15)))

let t41 = (color:RGBColor(0xffffff),font:UIFont.systemFont(ofSize: WH(15)))
let t42 = (color:RGBColor(0x8F8E94),font:UIFont.systemFont(ofSize: WH(15)))
let t43 = (color:RGBColor(0xFE403B),font:UIFont.systemFont(ofSize: WH(13)))
let t44 = (color:RGBColor(0x333333),font:UIFont.systemFont(ofSize: WH(15)))
let t45 = (color:RGBColor(0xffffff),font:UIFont.systemFont(ofSize: WH(16)))
let t46 = (color:RGBColor(0xFE5050),font:UIFont.systemFont(ofSize: WH(13)))
let t47 = (color:RGBColor(0x999999),font:UIFont.systemFont(ofSize: WH(15)))
let t48 = (color:RGBColor(0x666666),font:UIFont.systemFont(ofSize: WH(15)))
let t49 = (color:RGBColor(0x000000),font:UIFont.systemFont(ofSize: WH(16)))
let t50 = (color:RGBColor(0x000000),font:UIFont.systemFont(ofSize: WH(15)))

let t61 = (color:RGBColor(0x343434),font:UIFont.boldSystemFont(ofSize: WH(13)))
let t62 = (color:RGBColor(0x787878),font:UIFont.systemFont(ofSize: WH(13)))
let t63 = (color:RGBColor(0x343434),font:UIFont.systemFont(ofSize: WH(13)))
let t64 = (color:RGBColor(0x000000),font:UIFont.systemFont(ofSize: WH(14)))
let t65 = (color:RGBColor(0xFE5050),font:UIFont.systemFont(ofSize: WH(11)))
let t66 = (color:RGBColor(0x606060),font:UIFont.systemFont(ofSize: WH(11)))

let t70 = (color:RGBColor(0xe60012),font:UIFont.systemFont(ofSize: WH(13)))

let t71 = (color:RGBColor(0xFD394D),font:UIFont.systemFont(ofSize: WH(8)))
let t72 = (color:RGBColor(0x151515),font:UIFont.systemFont(ofSize: WH(14)))
let t73 = (color:RGBColor(0xFF2D5C),font:UIFont.boldSystemFont(ofSize: WH(15)))
// 行高
let h1 = WH(10)
let h2 = WH(5)
let h3 = WH(65)
let h4 = WH(11.5)
let h5 = WH(25)
let h6 = WH(15)
let h7 = WH(110)
let h8 = WH(30)
let h9 = WH(20)
let h10 = WH(35)

let h11 = WH(40)
let h12 = WH(200)
let h13 = WH(63)
let h14 = WH(90)
let h15 = WH(50)
let h16 = WH(65)
let h17 = WH(45)
let h18 = WH(82.5)
let h19 = WH(7.5)
let h20 = WH(85)

let h21 = WH(95)
let h22 = WH(150)
let h23 = WH(70)
let h24 = WH(47.5)
let h25 = WH(115)
let h26 = WH(240)
let h27 = WH(160)
let h28 = WH(60)
let h29 = WH(44)

let n1 = (bg : RGBColor(0xfeefb8), txt:(color : RGBColor(0x333333), font : UIFont.systemFont(ofSize: WH(12))),height : WH(30) ,leftMargin : WH(15))


// 选择进货数量样式
let num1 = (width : WH(125), height : WH(41), bg : RGBColor(0xf5f5f5), borderColor : RGBColor(0xd5d9da), borderWidth : WH(0.5))
let num2 = (width : WH(75), height : WH(26), bg : RGBColor(0xf5f5f5), borderColor : RGBColor(0xd5d9da), borderWidth : WH(0.5))

// 滚动点，菜单样式
let d = (width : WH(7), height : WH(7), defaultColor : RGBColor(0xffffff), alpha : 0.7, selectedColor : RGBColor(0xe60012))
let d1 = (width : WH(7), height : WH(7), defaultColor : RGBColor(0xd9dde0), selectedColor : RGBColor(0xe60012))
let d2 = (width : WH(15), height : WH(15), bgColor : RGBColor(0xe60012), text : (color : RGBColor(0xffffff),font:UIFont.systemFont(ofSize: WH(12))))

let menu = (defaultStyle : (color :  RGBColor(0x666666),font:UIFont.systemFont(ofSize: WH(11))),
            selectedStyle : (color :  RGBColor(0xe60012),font:UIFont.systemFont(ofSize: WH(11))),
            icon : ( width : WH(30), height : WH(30)))

// 修复Xcode10.2不允许tuple元组中只有单个元素的问题~!@
// Cannot create a single-element tuple with an element label

// 按钮样式
let btn1 = (size : (width : WH(155), height : WH(42)),
            defaultStyle : (color :  RGBColor(0xfe5050), alpha: 1),
            selectedStyle : (color :  RGBColor(0xc62121), alpha: 1),
            title : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(16))))

let btn2 = (size : (width : WH(62), height : WH(22)),
            defaultStyle : (color :  RGBColor(0x66c9d5), alpha: 1),
            selectedStyle : (color :  RGBColor(0x15abbc), alpha: 1),
            title : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(12))))

let btn3 = (size : (width : WH(75), height : WH(22)),
            defaultStyle : (color :  RGBColor(0xfe5050), alpha: 1),
            selectedStyle : (color :  RGBColor(0xc62121), alpha: 1),
            title : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(13))))

let btn4 = (size : (width : WH(75), height : WH(22)),
            defaultStyle : (color :  RGBColor(0xe4c13f), alpha: 1),
            selectedStyle : (color :  RGBColor(0xc3a32d), alpha: 1),
            title : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(13))))

let btn5 = (size : (width : WH(75), height : WH(22)),
            defaultStyle : (color :  RGBColor(0xbbbbbb), alpha: 1),
            title : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(13))))

let btn6 = (size : (width : WH(80), height : WH(27)),
            defaultStyle : (color :  RGBColor(0xfe5050), alpha: 1),
            selectedStyle : (color :  RGBColor(0xc62121), alpha: 1),
            title : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(12))))

let btn11 = (size : (width : WH(80), height : WH(28)),
             border : (color : RGBColor(0xd5d9da), width : WH(0.5)),
             title : (color : RGBColor(0xe60012), font:UIFont.systemFont(ofSize: WH(12))))

let btn16 = (size : (width : WH(335), height : WH(42)),
             defaultStyle : (color :  RGBColor(0xfe5050), alpha: 1),
             selectedStyle : (color :  RGBColor(0xc62121), alpha: 1),
             border : (color : RGBColor(0xd5d9da) , width : WH(0.5)),
             title : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(16))))

let btn17 = (size : (width : WH(154), height : WH(41)),
             defaultStyle : (color :  RGBColor(0xf4f4f4), alpha: 1),
             selectedStyle : (color :  RGBColor(0xeeeeee), alpha: 1),
             border : (color : RGBColor(0xd5d9da) , width : WH(0.5)),
             title : (color :  RGBColor(0xe60012), font:UIFont.systemFont(ofSize: WH(16))))

let btn18 = (size: (width : WH(150), height : WH(30)),
             title : (color :  RGBColor(0x333333), font:UIFont.systemFont(ofSize: WH(12))))

let btn19 = (size : (width : WH(92), height : WH(32)),
             defaultStyle : (color :  RGBColor(0xfe5050), cornerRadius : WH(3)),
             selectedStyle : (color :  RGBColor(0xc62121), cornerRadius : WH(3)),
             title : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(14)))
)

let btn20 = (size: (width : WH(124), height : WH(40)),
             title : (color :  RGBColor(0x333333), font:UIFont.systemFont(ofSize: WH(40))))

let btn21 = (size : (width : WH(92), height : WH(32)),
             defaultStyle : (color :  UIColor.clear, cornerRadius : WH(3)),
             selectedStyle : (color :  UIColor.clear, cornerRadius : WH(3)),
             title : (color :  RGBColor(0xff394e), font : UIFont.systemFont(ofSize: WH(14)),
                      border : (width : WH(1), color : RGBColor(0xff394e))))

let tx1 = (selectedStyle : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(14)), alpha : 0.6),
           defaultStyle : (color :  RGBColor(0xffffff), font:UIFont.systemFont(ofSize: WH(14))))

let s6 = (size : (width : WH(354), height : WH(100)),
          border : (color : RGBColor(0xebedec), width : WH(0.5)),
          defaultType : (color : RGBColor(0x999999), font : UIFont.systemFont(ofSize: WH(12))),
          title : (color : RGBColor(0x333333),  font : UIFont.systemFont(ofSize: WH(12))))


let bq1 = (size : (width : WH(37), height : WH(15)),
           bg : RGBColor(0xfe5050),
           title : (color : RGBColor(0xffffff),  font : UIFont.systemFont(ofSize: WH(12))))

func randomInt(min: Int, max: Int) -> Int {
    let y = arc4random() % UInt32(max) + UInt32(min)
    return Int(y)
}

// MARK:  init sinacloud

func configSinaCloud() {
    //    SCSwift.SCS.GlobalConfig("u9baetwoaFOZtsEfNLRN", secretKey:"SINA0000000000U9BAET", useSSL:false, maxConcurrentOperationCount:5)
}

func uploadHTLM(_ html: String){
//    let filePath:String = "YourFilePath"

//    SCSwift.SCS.sharedInstance.uploadObject(
//        ["filePath":filePath,
//            "bucket":"BucketName",
//            "key":"FileKey",
//            "accessPolicy": AccessPolicy.access_private.rawValue],
//        finished:{request in
//            let object = NSString(format:"%@ uploaded", request.key) as String
//            print(object)
//        },
//        failed:{request in
//            let error = NSString(format:"%@", request.error) as String
//            print(error)
//        },
//        progress:{request, sentSize, totalSize in
//            print("uploaded bytes: \(sentSize) in total: \(totalSize)")
//        }
//    )
}

func alert() -> () {
    
}

func naviBarHeight() -> CGFloat {
    if #available(iOS 11, *) {
        let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
        if (insets?.bottom)! > CGFloat.init(0) {
            return WH(88) // swift代码里高度和oc不一样。。。
        } else {
            return WH(64)
        }
    } else {
        return WH(64)
    }
}
    
func bootSaveHeight() -> CGFloat {
    if #available(iOS 11, *) {
        let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
        if (insets?.bottom)! > CGFloat.init(0) {
            return iPhoneX_SafeArea_BottomInset
        } else {
            return 0
        }
    } else {
        return 0
    }
}



