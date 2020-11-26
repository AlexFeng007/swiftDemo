//
//  UITableView+Extension.swift
//  FKY
//
//  Created by My on 2019/8/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import Foundation

protocol FKYRegisterCellProtocol {}
extension FKYRegisterCellProtocol {
    static var indentifier: String {
        return "\(self)"
    }
}

extension UITableView {
    //注册cell
    func fky_registerCell<T: UITableViewCell>(cell: T.Type) where T: FKYRegisterCellProtocol {
        register(cell, forCellReuseIdentifier: T.indentifier)
    }
    
    //取cell
    func fky_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: FKYRegisterCellProtocol {
        return dequeueReusableCell(withIdentifier: T.indentifier, for: indexPath) as! T
    }
}

