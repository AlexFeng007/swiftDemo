//
//  InvoiceProtocol.swift
//  FKY
//
//  Created by Rabe on 12/07/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum OutputResult {
    case ok
    case empty(message: String)
    case failed(message: String)
}

extension OutputResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
