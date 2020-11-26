//
//  FKYSearchContentHeader.swift
//  FKY
//
//  Created by 寒山 on 2019/6/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

typealias ClearHistoryClick = ()->Void

class FKYSearchContentHeader: UICollectionReusableView {
    
    /// 清除历史搜索词action
    static let clearHistoryWordListAction = "clearHistoryWordListAction"
    
    fileprivate var typeLabel : UILabel?
    fileprivate var clearButn : UIButton?
    @objc var clearHistoryClick : ClearHistoryClick?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    fileprivate func setupView() -> () {
        
        typeLabel = UILabel()
        self.addSubview(typeLabel!)
        typeLabel!.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(j5)
            make.top.equalTo(self.snp.top).offset(WH(19))
        }
        typeLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        typeLabel!.textColor = RGBColor(0x333333)
        
        clearButn = UIButton()
        self.addSubview(clearButn!)
        clearButn!.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-j5)
            make.centerY.equalTo(self.typeLabel!.snp.centerY)
        }
        clearButn!.setTitle("清空", for: UIControl.State())
        clearButn!.titleLabel?.font = t3.font
        clearButn?.setTitleColor(RGBColor(0x666666), for: UIControl.State())
        clearButn!.addTarget(self, action: #selector(FKYSearchContentHeader.clearBtnClicked), for: .touchUpInside)
        _ = clearButn?.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.clearHistoryClick != nil{
                strongSelf.clearHistoryClick!()
                strongSelf.routerEvent(withName: FKYSearchContentHeader.clearHistoryWordListAction, userInfo: [FKYUserParameterKey:""])
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    @objc func congigView(_ title : String, cancleApper : Bool) -> () {
        typeLabel?.text = title
        clearButn?.isHidden = cancleApper
    }
}

//MARK: - 事件响应
extension FKYSearchContentHeader{
    @objc func clearBtnClicked(){
        self.routerEvent(withName: FKYSearchContentHeader.clearHistoryWordListAction, userInfo: [FKYUserParameterKey:""])
    }
}
