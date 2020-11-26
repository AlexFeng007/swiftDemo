//
//  MyCouponItemController.swift
//  FKY
//
//  Created by Rabe on 13/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class MyCouponItemController: UIViewController {
    // MARK: - properties
    var type: CouponItemUsageType?
    
    fileprivate lazy var viewModel: MyCouponViewModel = MyCouponViewModel(withUsageType: self.type!)
    fileprivate lazy var presenter: MyCouponPresenter = MyCouponPresenter()
    fileprivate lazy var baseView: MyCouponView = { [weak self] in
        return MyCouponView(frame: .zero)
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
    }
}

// MARK: - delegates
extension MyCouponItemController {
    
}

// MARK: - action
extension MyCouponItemController {
    
}

// MARK: - data
extension MyCouponItemController {
    
}

// MARK: - private methods
extension MyCouponItemController {
    func adapterView() {
        presenter.adapter(viewModel: viewModel, view: baseView)
    }
}
