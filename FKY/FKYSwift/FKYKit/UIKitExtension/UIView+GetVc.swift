//
//  UIView+GetVc.swift
//  FKY
//
//  Created by 寒山 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

extension UIView {
    func getFirstViewController()->UIViewController?{
        
        for view in sequence(first: self.superview, next: {$0?.superview}){
            
            if let responder = view?.next{
                
                if responder.isKind(of: UIViewController.self){
                    
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}


