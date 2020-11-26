//
//  FKYNewPrdSetDeatilViewController.swift
//  FKY
//
//  Created by yyc on 2020/3/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 新品登记详情

import UIKit

class FKYNewPrdSetDeatilViewController: UIViewController {
    fileprivate lazy var newPrdDetailTableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.backgroundColor = RGBColor(0xF4F4F4)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.bounces = false
        tableV.estimatedRowHeight = WH(300) //最多
        tableV.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYNewPrdDetailTitleCell.self, forCellReuseIdentifier: "FKYNewPrdDetailTitleCell")
        tableV.register(FKYNewprdDetailContentCell.self, forCellReuseIdentifier: "FKYNewprdDetailContentCell")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    //请求工具类
    fileprivate lazy var newPrdDetailServiece : FKYNewPrdSetServiece = {
        let serviece = FKYNewPrdSetServiece()
        return serviece
    }()
    var navBar : UIView?
    var increateId = ""
    var desModel: FKYNewPrdSetItemModel? //请求数据
    var imageArr = [UIImageView]() //存放image数组
    //MARK:生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationView()
        self.setContentView()
        self.getNewPrdSetDeatilData()
    }
    deinit {
        print(" FKYNewPrdSetDeatilViewController deinit~!@")
    }
    
}
//MARK:ui相关
extension FKYNewPrdSetDeatilViewController {
    func setNavigationView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] in
            if let strongSelf = self {
                FKYNavigator.shared().pop()
                // 埋点
                FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName:nil, itemId: ITEMCODE.NEW_PRODUCT_REGISTER_DETAIL_BACK_CODE.rawValue, itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: ["pageValue":strongSelf.increateId] as [String : AnyObject], viewController: strongSelf)
            }
        }
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("登记详情")
        self.fky_hiddedBottomLine(false)
    }
    func setContentView() {
        self.view.backgroundColor = bg2
        self.view.addSubview(self.newPrdDetailTableView)
        self.newPrdDetailTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    // 创建临时用于查看大图的图片数组
    fileprivate func createImageList(){
        if let model = self.desModel, let arr = model.imagePaths,arr.count > 0 {
            self.imageArr.removeAll()
            for index in 0..<arr.count {
                let imgview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: WH(62), height: WH(62)))
                imgview.backgroundColor = .clear
                imgview.contentMode = .scaleAspectFit
                imgview.clipsToBounds = true
                imgview.isUserInteractionEnabled = true
                imgview.sd_setImage(with: URL(string: arr[index]), placeholderImage: UIImage(named: "image_default_img"))
                self.imageArr.append(imgview)
            }
        }
    }
}
//MARK:请求相关
extension FKYNewPrdSetDeatilViewController {
    func getNewPrdSetDeatilData() {
        self.showLoading()
        self.newPrdDetailServiece.getNewProductDetail(self.increateId) { [weak self] (model, tip) in
            guard let strongSelf = self else{
                return
            }
            strongSelf.dismissLoading()
            if let msg = tip {
                strongSelf.toast(msg)
            }else {
                //请求成功
                if let getModel = model {
                    strongSelf.desModel = getModel
                    strongSelf.createImageList()
                    strongSelf.newPrdDetailTableView.reloadData()
                }
            }
        }
    }
}
//MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension FKYNewPrdSetDeatilViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.desModel {
            return 2
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: FKYNewPrdDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "FKYNewPrdDetailTitleCell", for: indexPath) as! FKYNewPrdDetailTitleCell
            cell.configNewPrdDetailTitleData(self.desModel)
            return cell
        }else {
            let cell: FKYNewprdDetailContentCell = tableView.dequeueReusableCell(withIdentifier: "FKYNewprdDetailContentCell", for: indexPath) as! FKYNewprdDetailContentCell
            cell.configPrdDetailData(self.desModel,self.imageArr)
            cell.clickItem = { [weak self] indexNum in
                if let strongSelf = self {
                    // 埋点
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName:nil, itemId: ITEMCODE.NEW_PRODUCT_REGISTER_DETAIL_LOOK_PIC_CODE.rawValue, itemPosition: "1", itemName: "查看图片", itemContent: nil, itemTitle: nil, extendParams: ["pageValue":strongSelf.increateId] as [String : AnyObject], viewController: strongSelf)
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WH(10)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spaceView = UIView()
        spaceView.backgroundColor = RGBColor(0xF4F4F4)
        return spaceView
    }
}
