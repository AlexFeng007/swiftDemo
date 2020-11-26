//
//  SellerComplainViewModel.swift
//  FKY
//
//  Created by 寒山 on 2019/1/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class SellerComplainViewModel: NSObject {
    // 当前最大可上传照片个数...<默认为1>
    let maxUploadNumber = 1
    var inputInfoModel: ComplaintInputInfoModel? //输入投诉数据
   
    var complainSellerInfo:  ComplainSellerInfoModel? //投诉商家详情
    var orderModel: FKYOrderModel?
    var picList = [String]()                // 上传的图片数组
    var problemDescription: String?         // 问题描述
    var complainTypeModel: ComplaintTypeInfoModel?
    // 选中的申请原因索引...<默认未选中>
    var index4Reason: Int = -1
     //投诉详情
    var complainDetailInfo: ComplainDetailInfoModel = {
        let model = ComplainDetailInfoModel()
        return model
    }()
    
    // 更新上传图片数据内容
    func deletePicAtIndex(_ index: Int) {
        guard picList.count  > 0, index >= 0, index < picList.count else {
            return
        }
        picList.remove(at: index)
    }
    
    // 若上传图片超过最大数量，则自动移除前面的
    func updatePicListForException() {
        if picList.count > maxUploadNumber {
            let list = picList.suffix(maxUploadNumber)
            picList = Array.init(list)
        }
    }
    
    // 创建临时用于查看大图的图片数组
    func createImageList() -> [UIImageView]? {
        guard picList.count > 0 else {
            return nil
        }
        
        var list = [UIImageView]()
        for index in 0..<picList.count {
            let url = picList[index]
            let x = WH(17) + (WH(60) + WH(5)) * CGFloat(index) + WH(8)
            var y = WH(42+94) + WH(10) + WH(45) * 2 + WH(40) + WH(130) + WH(3) + WH(8)
            
//            if applyReason == nil {
//                // 若未选择申请原因，则不会显示退回方式， 故坐标需调整
//                y -= WH(45)
//            }
            
            // 适配iPhoneX
            var top = WH(20) + WH(44)
            if #available(iOS 11, *) {
                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                    top = iPhoneX_SafeArea_TopInset
                }
            }
            y += top
            
            let imgview = UIImageView.init(frame: CGRect.init(x: x, y: y, width: WH(44), height: WH(44)))
            imgview.backgroundColor = .clear
            imgview.contentMode = .scaleAspectFit
            imgview.clipsToBounds = true
            imgview.isUserInteractionEnabled = true
            imgview.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_default_img"))
            list.append(imgview)
        } // for
        return list
    }
    // 判断用户输入信息是否完整
    func checkSubmitInfoStatus() -> (status: Int, msg: String) {
        guard index4Reason >= 0, complainTypeModel != nil else {
            return (1, "请选择投诉类型")
        }
        guard let txt = problemDescription, txt.isEmpty == false else {
            return (2, "请输入问题描述")
        }
        guard txt.count > 0, txt.count <= 300 else {
            return (3, "问题描述长度不符")
        }
//        guard picList.count > 0 else {
//            return (4, "请上传图片")
//        }
        // 异常情况的特殊处理
        guard picList.count <= maxUploadNumber else {
            // 若超过5张，则取后5张图片
            let list = picList.suffix(maxUploadNumber)
            picList = Array.init(list)
            return (0, "ok")
        }
        
        // ok
        return (0, "ok")
    }
    // 请求投诉详情
    func sellerComplainAction(_ param: Dictionary<String, Any>?, _ type: Int?, block: @escaping (Bool, String?)->()) {
        let dic: [String: Any]
        if type == 1{
            //提交投诉
            if picList.isEmpty == false{
                dic = [
                    "flowId":self.orderModel!.orderId as Any,
                    "complaintUrlList":picList as Any,
                    "content":problemDescription as Any,
                    "complaintType":complainTypeModel?.type as Any
                ]
            }else{
                dic = [
                    "flowId":self.orderModel!.orderId as Any,
                    "content":problemDescription as Any,
                    "complaintType":complainTypeModel?.type as Any
                    ] 
            }
           
        }else{
            //2、投诉详情
            //3、投诉商家详情（点击投诉商家按钮显示的订单信息）
            //4、关闭投诉
            //5、、申请平台处理
            dic = [
                "flowId":self.orderModel!.orderId as Any
            ]
        }
        // 请求
        let params = ["action":type as Any,"jsonParams":dic] as [String : Any]
        FKYRequestService.sharedInstance()?.sellerComplainAction(withParam: params, completionBlock: { (success, error, response, model) in
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "请求失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            // 操作成功
            if let data = response as? NSDictionary {
               // 1-新增投诉；2-投诉详情；3-投诉商家详情；4-关闭投诉；5-申请平台处理
                if type == 2{
                     self.complainDetailInfo = data.mapToObject(ComplainDetailInfoModel.self)
                }else if type == 3{
                       self.complainSellerInfo =  data.mapToObject(ComplainSellerInfoModel.self)
                }
                block(true, "")
                return
            }
            block(true, "")
        })
    }
}
