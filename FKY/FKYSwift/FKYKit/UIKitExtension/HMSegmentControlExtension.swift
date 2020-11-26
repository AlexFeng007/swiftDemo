//
//  HMSegmentControlExtension.swift
//  FKY
//
//  Created by 乔羽 on 2018/8/20.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import Foundation

extension HMSegmentedControl
{
    func defaultSetting() {
        //设定背景色
        self.backgroundColor = UIColor.white
        //设定线条的颜色
        self.selectionIndicatorColor = RGBColor(0xFF2D5C)
        //设定title的颜色和字体
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor:RGBColor(0x333333), NSAttributedString.Key.font:FKYSystemFont(15)]
        //设定选中title时的颜色和字体
        self.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor:RGBColor(0xFF2D5C),
                                            NSAttributedString.Key.font:FKYSystemFont(15)];
        //设定线条的位置
        self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down;
        //设定线条的宽度
        self.selectionStyle = HMSegmentedControlSelectionStyle.textWidthStripe;
        //设定线条的高度
        self.selectionIndicatorHeight = 1;
        
        self.borderType = HMSegmentedControlBorderType.bottom;
        
        self.borderColor = RGBColor(0xD8D8D8);
        
        self.borderWidth = 0.6;
    }
}
