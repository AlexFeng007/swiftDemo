//
//  CartSpaceCell.swift
//  FKY
//
//  Created by 寒山 on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class CartSpaceCell: UITableViewCell {
    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override  init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.contentView);
        })
        
    }
    
}
