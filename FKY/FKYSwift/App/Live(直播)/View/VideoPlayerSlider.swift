//
//  VideoPlayerSlider.swift
//  FKY
//
//  Created by 寒山 on 2020/8/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class VideoPlayerSlider: UISlider {
    //左侧轨道的颜色
    var leftBarColor: UIColor?
    //右侧轨道的颜色
    var rightBarColor:UIColor?
    //轨道高度
    var barHeight: CGFloat?
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置样式的默认值
        self.leftBarColor = UIColor(red: 55/255.0, green: 55/255.0, blue: 94/255.0,
                                    alpha: 0.8)
        self.rightBarColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 193/255.0,
                                     alpha: 0.8)
        self.barHeight = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //得到左侧带有刻度的轨道图片（注意：图片不拉伸）
        let leftTrackImage = createTrackImage(rect: rect, barColor: self.leftBarColor!)
            .resizableImage(withCapInsets: .zero)
        
        //得到右侧带有刻度的轨道图片
        let rightTrackImage = createTrackImage(rect: rect, barColor: self.rightBarColor!)
        
        //将前面生产的左侧、右侧轨道图片设置到UISlider上
        self.setMinimumTrackImage(leftTrackImage, for: .normal)
        self.setMaximumTrackImage(rightTrackImage, for: .normal)
    }
    
    //生成轨道图片
    func createTrackImage(rect: CGRect, barColor:UIColor) -> UIImage {
        //开始图片处理上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        //绘制轨道背景
        context.setLineCap(.round)
        context.setLineWidth(self.barHeight!)
        context.move(to: CGPoint(x:self.barHeight!/2, y:rect.height/2))
        context.addLine(to: CGPoint(x:rect.width-self.barHeight!/2, y:rect.height/2))
        context.setStrokeColor(barColor.cgColor)
        context.strokePath()
        
        //得到带有刻度的轨道图片
        let trackImage = UIGraphicsGetImageFromCurrentImageContext()!
        //结束上下文
        UIGraphicsEndImageContext()
        return trackImage
    }
}
