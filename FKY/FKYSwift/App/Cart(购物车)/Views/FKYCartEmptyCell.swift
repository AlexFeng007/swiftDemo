//
//  FKYCartEmptyCell.swift
//  FKY
//
//  Created by 曾维灿 on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYCartEmptyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = .white
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FKYCartEmptyCell {
    static func getCellHeight() -> CGFloat{
        return WH(10.0)
    }
}
