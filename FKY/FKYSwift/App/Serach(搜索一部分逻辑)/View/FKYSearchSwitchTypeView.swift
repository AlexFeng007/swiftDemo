//
//  FKYSearchSwitchTypeView.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchSwitchTypeView: UIView {
    
    /// 切换搜索类型事件
    @objc static var switchSearchType = "switchSearchType";
    
    /// 搜商品按钮
    fileprivate var searchProductBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("搜商品", for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: WH(17))
        bt.setTitleColor(RGBColor(0x333333), for: .normal)
        return bt
    }()
    
    /// 搜商家按钮
    fileprivate var searchSellerBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("搜店铺", for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: WH(17))
        bt.setTitleColor(RGBColor(0x333333), for: .normal)
        return bt
    }()
    
    /// 选中状态标记视图
    fileprivate var selectMarkView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFF2D5C)
        view.layer.cornerRadius = WH(1.5)
        view.layer.masksToBounds = true;
        return view
    }()

    /// 扫码view
    @objc var scanView:FKYSearchScanView = FKYSearchScanView();

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - 事件响应
extension FKYSearchSwitchTypeView{
    func endSupeViewEditing(superView:UIView){
        superView.endEditing(true);
        if let superView_t = superView.superview {
            endSupeViewEditing(superView: superView_t)
        }
    }
}

//MARK: - 事件响应
extension FKYSearchSwitchTypeView{
    
    /// 搜商品按钮
    @objc func searchProductBtnClicked(){
        self.endSupeViewEditing(superView: self)
        self.routerEvent(withName: FKYSearchSwitchTypeView.switchSearchType, userInfo: [FKYUserParameterKey:1])
    }
    
    /// 搜商家按钮
    @objc func searchSellerBtnClicked(){
        self.endSupeViewEditing(superView: self)
        self.routerEvent(withName: FKYSearchSwitchTypeView.switchSearchType, userInfo: [FKYUserParameterKey:2])
    }
    
    /// 切换搜索类型
    /// - Parameter index: 1搜商品  2搜店铺
    @objc func switchSearchType(index:Int){
        if index == 1 {// 搜商品
            self.searchProductBtn.titleLabel?.font = .boldSystemFont(ofSize: WH(18));
            self.searchSellerBtn.titleLabel?.font = .systemFont(ofSize: WH(17));
//            self.selectMarkView.snp_updateConstraints { (make) in
//                make.centerX.equalTo(self.searchProductBtn)
//            }
            self.selectMarkView.snp_remakeConstraints { (make) in
                make.centerX.equalTo(self.searchProductBtn)
                make.bottom.equalToSuperview().offset(WH(-4))
                make.width.equalTo(WH(40))
                make.height.equalTo(WH(3))
            }
        }else if index == 2 {// 搜店铺
            self.searchSellerBtn.titleLabel?.font = .boldSystemFont(ofSize: WH(18));
            self.searchProductBtn.titleLabel?.font = .systemFont(ofSize: WH(17));
//            self.selectMarkView.snp_updateConstraints { (make) in
//                make.centerX.equalTo(self.searchSellerBtn)
//            }
            self.selectMarkView.snp_remakeConstraints { (make) in
                make.centerX.equalTo(self.searchSellerBtn)
                make.bottom.equalToSuperview().offset(WH(-4))
                make.width.equalTo(WH(40))
                make.height.equalTo(WH(3))
            }
        }
    }
}

//MARK: - UI
extension FKYSearchSwitchTypeView{
    func setupUI(){
        self.addSubview(self.searchProductBtn)
        self.addSubview(self.searchSellerBtn)
        self.addSubview(self.scanView)
        self.addSubview(self.selectMarkView)
        
        self.searchProductBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_centerX).offset(WH(-13.5))
            make.centerY.equalToSuperview()
        }
        
        self.searchSellerBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_centerX).offset(WH(13.5))
            make.centerY.equalToSuperview()
        }
        
        self.scanView.snp_makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(WH(80))
            make.height.equalTo(WH(25))
        }
        
        self.selectMarkView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.searchProductBtn)
            make.bottom.equalToSuperview().offset(WH(-4))
            make.width.equalTo(WH(40))
            make.height.equalTo(WH(3))
        }
        self.switchSearchType(index: 1)
        self.searchProductBtn.addTarget(self, action: #selector(FKYSearchSwitchTypeView.searchProductBtnClicked), for: .touchUpInside)
        self.searchSellerBtn.addTarget(self, action: #selector(FKYSearchSwitchTypeView.searchSellerBtnClicked), for: .touchUpInside)
    }
    
    
    /// 只有搜商品时候的布局
    @objc func layoutOnlySearchProduct(){
        self.searchProductBtn.isHidden = false;
        self.searchSellerBtn.isHidden = true;
        self.searchProductBtn.snp_remakeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    /// 只有搜索商家时候的布局
    @objc func layoutOnlySearchSeller(){
        self.searchProductBtn.isHidden = true;
        self.searchSellerBtn.isHidden = false;
        self.searchSellerBtn.snp_remakeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    /// 两种搜索方式都有
    @objc func layoutBothSearch(){
        self.searchProductBtn.isHidden = false;
        self.searchSellerBtn.isHidden = false;
        self.searchProductBtn.snp_remakeConstraints { (make) in
            make.right.equalTo(self.snp_centerX).offset(WH(-13.5))
            make.centerY.equalToSuperview()
        }
        
        self.searchSellerBtn.snp_remakeConstraints { (make) in
            make.left.equalTo(self.snp_centerX).offset(WH(13.5))
            make.centerY.equalToSuperview()
        }
    }
}
