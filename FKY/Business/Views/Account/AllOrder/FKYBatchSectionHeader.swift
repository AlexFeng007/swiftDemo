//
//  FKYBatchSectionHeader.swift
//  FKY
//
//  Created by mahui on 16/9/12.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import Foundation
import SnapKit

@objc
class FKYBatchSectionHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    fileprivate var NumLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() -> () {
        NumLabel = {
            let label = UILabel()
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp.centerY)
                make.right.equalTo(self.snp.right).offset(-j1)
                make.height.equalTo(btn1.size.height)
            })
            label.fontTuple = t3
            return label
        }()
        
        let line = UIView.init()
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(j1)
            make.right.equalTo(self.snp.right).offset(-j1)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(FKYWHWith2ptWH(0.5));
        }
        line.backgroundColor = m2
    }
    
    @objc func configViewWith(_ des : String, count:NSNumber) -> () {
        NumLabel?.text = "实发货: \(count)"
    }
}
