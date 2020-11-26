//
//  FKYCouponShopOrPrdView.swift
//  FKY
//
//  Created by yyc on 2020/2/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYCouponShopOrPrdView: UIView {
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = RGBColor(0xFCFCFC)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(200)
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(18)))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(14)))
        tableView.register(FKYCouponUseTableViewCell.self, forCellReuseIdentifier: "FKYCouponUseTableViewCell")
        
        return tableView
        }()
    //确定按钮
    fileprivate lazy var certainBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(RGBColor(0xffffff), for: .normal)
        btn.titleLabel?.font = t73.font
        btn.backgroundColor = t73.color
        btn.layer.cornerRadius = WH(4)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickCertianBtnBlock {
                block()
            }
        }).disposed(by: disposeBag)
        return btn
    }()
    
    //属性
    var couponArr : [FKYReCheckCouponModel]? //优惠券列表
    var viewType = 1 //1 可用券 2 不可用券
    var typeNum = 0 //(0：店铺优惠券1：平台优惠券)
    var clickButtonBlock : ((Int,FKYReCheckCouponModel)->(Void))?
    var clickCertianBtnBlock : (()->(Void))? //点击确定按钮
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FKYCouponShopOrPrdView {
    fileprivate func setupView() {
        self.backgroundColor = RGBColor(0xFCFCFC)
        self.addSubview(self.certainBtn)
        self.certainBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-WH(30))
            make.left.equalTo(self.snp.left).offset(WH(30))
            make.bottom.equalTo(self.snp.bottom).offset(-WH(20))
            make.height.equalTo(WH(0))
        }
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    func configCouponShopOrPrdViewData(_ typeNum:Int,_ arr:[FKYReCheckCouponModel]) {
        //动态显示或者隐藏确定按钮
        if self.viewType == 1 && arr.count > 0 {
            self.certainBtn.isHidden = false
            self.certainBtn.snp.updateConstraints { (make) in
                make.height.equalTo(WH(42))
            }
            self.tableView.snp.remakeConstraints { (make) in
                make.left.right.top.equalTo(self)
                make.bottom.equalTo(self.certainBtn.snp.top).offset(-WH(5))
            }
        }else {
            self.certainBtn.isHidden = true
            self.certainBtn.snp.updateConstraints { (make) in
                make.height.equalTo(WH(0))
            }
            self.tableView.snp.remakeConstraints { (make) in
                make.edges.equalTo(self)
            }
        }
        self.typeNum = typeNum
        self.couponArr = arr
        self.tableView.reloadData()
    }
}
extension FKYCouponShopOrPrdView: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let desArr = self.couponArr {
            return desArr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYCouponUseTableViewCell(style: .default, reuseIdentifier: "FKYCouponUseTableViewCell")
        if let desArr = self.couponArr {
            let couponModel = desArr[indexPath.item]
            cell.configCouponViewCell(couponModel,self.typeNum,self.viewType)
            cell.clickInteractButtonBlock = { [weak self] typeIndex in
                if let strongSelf = self {
                    if typeIndex == 1 {
                        //可用商品
                    }else if typeIndex == 2 {
                        //可用商家
                        couponModel.isShowUseShopList = !couponModel.isShowUseShopList
                        strongSelf.tableView.reloadData()
                    }else if typeIndex == 3 {
                        //选择或者取消
                    }
                    if let block = strongSelf.clickButtonBlock {
                        block(typeIndex,couponModel)
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let desArr = self.couponArr {
            return FKYCouponUseTableViewCell.getCouponCellHeight(desArr[indexPath.item],self.typeNum,self.viewType)
        }
        return WH(0)
    }
}
extension FKYCouponShopOrPrdView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "img_coupon_emptypage")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text = self.viewType == 1 ? "暂无可用平台优惠券" : "暂无不可用平台优惠券"
        if self.typeNum == 0 {
            text = self.viewType == 1 ? "暂无可用店铺优惠券" : "暂无不可用店铺优惠券"
        }
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: RGBColor(0x5c5c5c)]
        return NSAttributedString.init(string: text, attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return WH(-10)
    }
}
