//
//  ShopActivitySpaceCell.swift
//  FKY
//
//  Created by 寒山 on 2019/9/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ShopActivitySpaceCell: UITableViewCell {

    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ShopActivitySpaceCell: ShopListCellInterface {

    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        return 0.0001
    }

    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
       // self.callback = callback
    }

    func bindModel(_ model: ShopListModelInterface) {
//        if let m = model as? ShopListActivityZoneModel {
//            configCell(recommend: m)
//        }
//        else {
//            configCell(recommend: nil)
//        }
    }
}
