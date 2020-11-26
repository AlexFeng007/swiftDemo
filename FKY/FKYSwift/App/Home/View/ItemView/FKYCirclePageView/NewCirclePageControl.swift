//
//  NewCirclePageControl.swift
//  FKY
//
//  Created by 寒山 on 2019/3/14.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class NewCirclePageControl: UIView {
    var dotNomalSize: CGSize = CGSize(width:WH(4), height:WH(4))   // 正常点的size
    var dotBigSize: CGSize = CGSize(width:WH(17), height:WH(4))   // 选中点的size
    var dotMargin: CGFloat = WH(5)   // 每个点的间距
    var startPage: Int = 0   // 开始page
    var dotAlpha: CGFloat = 0.5   // 点的透明度
    var pages:Int? // 个数
    var currentPageColor:UIColor = RGBColor(0xFFFFFF)
    var normalPageColor:UIColor =  RGBAColor(0xFFFFFF, alpha: 0.6)
    var pageDots:Array<UIView> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     更新当前页面
     
     @param page 当前页面的索引
     */
   func  setCurrectPage(_ page: Int) {
        let dotNomalWidth  = self.dotNomalSize.width;
        let dotNomalHeight = self.dotNomalSize.height;
        let dotBigWidth    = self.dotBigSize.width;
        let dotBigHeight   = self.dotBigSize.height;
    
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            for index in 0..<strongSelf.pages! {
                if strongSelf.pageDots.count > index {
                    let pageView = strongSelf.pageDots[index]
                    if page == index {
                        pageView.frame = CGRect(x: CGFloat(index) * (dotNomalWidth + strongSelf.dotMargin), y: WH(0), width:dotBigWidth, height: dotBigHeight)
                        pageView.backgroundColor = strongSelf.currentPageColor;
                    } else {
                        if (index < page) {
                            pageView.frame = CGRect(x:CGFloat(index) * (strongSelf.dotMargin + dotNomalWidth), y: WH(0), width:dotNomalWidth, height: dotNomalHeight)
                        } else {
                            pageView.frame = CGRect(x: (dotBigWidth - dotNomalWidth ) + CGFloat(index) * (strongSelf.dotMargin + dotNomalWidth), y: WH(0), width:dotNomalWidth, height: dotNomalHeight)
                        }
                        pageView.backgroundColor = strongSelf.normalPageColor
                    }
                }
            }
        })
    }
    
   func setPageDotsView() {
        if self.pageDots.isEmpty == false {
            for subView in self.pageDots {
                subView.removeFromSuperview()
            }
            self.pageDots.removeAll()
        }
    
        let dotNomalWidth  = self.dotNomalSize.width;
        let dotNomalHeight = self.dotNomalSize.height;
        let dotBigWidth    = self.dotBigSize.width;
        let dotBigHeight   = self.dotBigSize.height;
        for index in 0..<self.pages! {
            let dotView = UIView.init()
            if index == 0 {
                dotView.frame =  CGRect(x: WH(0), y: WH(0), width:dotBigWidth, height: dotBigHeight)
                dotView.layer.cornerRadius = dotView.frame.size.height / 2.0
                dotView.backgroundColor = currentPageColor
            } else {
                dotView.frame =  CGRect(x: (dotBigWidth - dotNomalWidth) + CGFloat(index) * (self.dotMargin + dotNomalWidth), y: WH(0), width:dotNomalWidth, height: dotNomalHeight)
                dotView.layer.cornerRadius = dotView.frame.size.height / 2.0;
                dotView.backgroundColor = normalPageColor
            }
            self.addSubview(dotView)
            self.pageDots.append(dotView)
        }
    }
}
