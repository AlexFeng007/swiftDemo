//
//  FKYSearchScanView.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchScanView: UIView {
    
    /// 跳转到扫描界面
    @objc static var gotoSacnView = "gotoSacnView";
    
    /// 容器视图
    fileprivate var containerView:UIView = {
        let view = UIView();
        return view;
    }()
    
    /// 扫描图标
    fileprivate var scanIcon:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"search_scan")
        return iv;
    }()
    
    /// title文描
    fileprivate var titleLB:UILabel = {
        let lb = UILabel()
        lb.text = "扫码识药"
        lb.textColor = RGBColor(0x333333)
        lb.textAlignment = .center;
        lb.font = .systemFont(ofSize: WH(12))
        return lb;
    }()
    
    /// 点击按钮
    fileprivate var actionBtn:UIButton = {
        let bt = UIButton()
        return bt;
    }()
    
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
extension FKYSearchScanView{
    @objc func actionBtnClicked(){
        self.endSupeViewEditing(superView: self)
        self.routerEvent(withName: FKYSearchScanView.gotoSacnView, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - 私有方法
extension FKYSearchScanView{
    func endSupeViewEditing(superView:UIView){
        superView.endEditing(true);
        if let superView_t = superView.superview {
            endSupeViewEditing(superView: superView_t)
        }
    }
}

//MARK: - UI
extension FKYSearchScanView{
    func setupUI(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.scanIcon)
        self.containerView.addSubview(self.titleLB)
        self.containerView.addSubview(self.actionBtn)
        
        self.containerView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        self.scanIcon.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset((WH(5)))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(WH(18))
        }
        
        self.titleLB.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset((WH(-5)))
            make.left.equalTo(self.scanIcon.snp_right)
            make.centerY.equalToSuperview()
        }
        
        self.actionBtn.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        self.actionBtn.addTarget(self, action: #selector(FKYSearchScanView.actionBtnClicked), for: .touchUpInside)
    }
    
    @objc func setCorner(){
        let  corner:UIRectCorner = [.topLeft,.bottomLeft]
        let mask = CAShapeLayer()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: WH(80), height: WH(25)), byRoundingCorners: corner, cornerRadii: CGSize(width: WH(12.5), height: WH(12.5)));
        mask.path = path.cgPath
        mask.frame = CGRect(x: 0, y: 0, width: WH(80), height: WH(25))
        
        let borderLayer = CAShapeLayer()
        borderLayer.path=path.cgPath;
        borderLayer.fillColor = UIColor.clear.cgColor;
        borderLayer.strokeColor = RGBColor(0xE5E5E5).cgColor;
        borderLayer.lineWidth = 1;
        borderLayer.frame = CGRect(x: 0, y: 0, width: WH(80), height: WH(25))
        self.containerView.layer.mask = mask;
        self.containerView.layer.addSublayer(borderLayer)
    }
}
