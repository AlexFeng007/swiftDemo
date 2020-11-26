//
//  FKYMatchingPackageEmptyCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageEmptyCell: UITableViewCell {

    /// 容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - ui
extension FKYMatchingPackageEmptyCell{
    
    func setupUI(){
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        
        self.containerView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
}
