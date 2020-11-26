//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

class HotSaleItemController: UIViewController {
    // MARK: - properties
    var headerModel: HotSaleHeaderModel?
    var type: HotSaleType?
    var index: Int?
    
    fileprivate lazy var viewModel: HotSaleViewModel = HotSaleViewModel.init(withHeaderModel: self.headerModel!, type: self.type!, segIndex: self.index!)
    fileprivate lazy var presenter: HotSalePresenter = HotSalePresenter()
    fileprivate lazy var baseView: HotSaleView = { [weak self] in
        return HotSaleView(frame: .zero)
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
    fileprivate func setupView() {
        view.addSubview(baseView)
        
        baseView.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
    }
}

// MARK: - delegates
extension HotSaleItemController {
    
}

// MARK: - action
extension HotSaleItemController {
    
}

// MARK: - data
extension HotSaleItemController {
    
}

// MARK: - private methods
extension HotSaleItemController {
    fileprivate func adapterView() {
        presenter.adapter(viewModel: viewModel, view: baseView)
    }
}

