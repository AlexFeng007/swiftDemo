//
//  FKYInvoiceEmptyCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/7.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYInvoiceEmptyCell: UITableViewCell {

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
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension FKYInvoiceEmptyCell{
    func setupView(){
        self.selectionStyle = .none
        
        self.backgroundColor = RGBColor(0xF4F4F4)
    }
}

extension FKYInvoiceEmptyCell{
    static func getCellHeight() -> CGFloat{
        return WH(10)
    }
}
