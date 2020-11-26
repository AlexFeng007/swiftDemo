//
//  UseCouponItemController.swift
//  FKY
//
//  Created by zengyao on 2018/1/19.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  使用优惠券之单个item类型优惠券vc

import UIKit

class UseCouponItemController: UIViewController {
    
    // MARK: - properties
    typealias reListBlock = (FKYReCheckCouponModel)->()
    var block:reListBlock?
    
    var couponList: NSMutableArray?{
        didSet {
            self.baseView.couponList = self.couponList
            self.baseView.showTxt = self.showTxt
            self.baseView.usageType = self.usageType
            self.baseView.reloadDataList()
        }
    }
    var showTxt:String?
    var usageType: CouponItemUsageType?
    fileprivate lazy var baseView: UseCouponView = { [weak self] in
        return UseCouponView(frame: .zero)
    }()
    
    // MARK: - life cycle
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        adapterView()
    }
    // MARK: - ui
    func setupView() {
        view.addSubview(baseView)
        baseView.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        
        baseView.callBlock{ [weak self] (model:FKYReCheckCouponModel) in
            if let strongSelf = self {
                strongSelf.block!(model)
            }
        }
    }
    
    func callBlock(block:@escaping reListBlock)  {
        self.block = block
    }
}

// MARK: - delegates
extension UseCouponItemController {
    
}

// MARK: - action
extension UseCouponItemController {
    
}

// MARK: - data
extension UseCouponItemController {
    
}

// MARK: - private methods
extension UseCouponItemController {
    func adapterView() {
//        presenter.adapter(viewModel: viewModel, view: baseView)
    }
}
