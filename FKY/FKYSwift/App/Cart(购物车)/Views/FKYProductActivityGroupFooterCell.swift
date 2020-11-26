//
//  FKYProductActivityGroupFooterCell.swift
//  FKY
//
//  Created by 曾维灿 on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYProductActivityGroupFooterCell: UITableViewCell {

    ///cell数据
    var cellModel:CartCellTaocanPromationInfoProtocol = CartCellTaocanPromationInfoProtocol()
    
    ///边框layer
    let borderLayer = CAShapeLayer()
    
    ///容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.frame = CGRect(x:WH(5.0),y:0,width: SCREEN_WIDTH - WH(10) ,height:FKYProductActivityGroupFooterCell.getCellHeight())
        return view
    }()
    
    ///优惠
    var discountLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0x666666)
        lb.font = UIFont.systemFont(ofSize:WH(12.0))
        return lb
    }()
    
    ///小计
    var subTotleLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0x666666)
        lb.font = UIFont.systemFont(ofSize:WH(12.0))
        return lb
    }()
    
    override  init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


//MARK: -UI
extension FKYProductActivityGroupFooterCell{
    
    func setupView(){
        self.backgroundColor = .white
        
        self.contentView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.discountLB)
        self.containerView.addSubview(self.subTotleLB)
        
        self.subTotleLB.snp.makeConstraints { (make) in
            make.right.equalTo(self.containerView).offset(WH(-13.0))
            make.centerY.equalTo(self.containerView)
        }
        
        self.discountLB.snp.makeConstraints { (make) in
            make.right.equalTo(subTotleLB.snp.left).offset(WH(-9.0))
            make.centerY.equalTo(self.containerView)
        }
        
        configRectCornerAndBorder(view: self.containerView, corner: [.bottomLeft,.bottomRight], roundCorner: (0,0,WH(4.0),WH(4.0)), border: (false,true,true,true), borderWidth: 0.5, borderColor: RGBColor(0xFF2D5C))
        self.containerView.backgroundColor = RGBColor(0xFFFAFB)
    }
    
}

//MARK: -显示数据
extension FKYProductActivityGroupFooterCell{
    
    func showData(cellData:CartCellTaocanPromationInfoProtocol){
        self.cellModel = cellData
        configData()
    }
    
    func configData(){
        self.discountLB.text = String(format: "已优惠￥%.2f", self.cellModel.shareMoney?.doubleValue ?? 0.0)
        self.subTotleLB.attributedText = subTotleString()
    }
    
    //小计富文本
    fileprivate func subTotleString() -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let str1 : NSAttributedString = NSAttributedString(string: "套餐价: ", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x666666), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12.0))])
        
        let str2 : NSAttributedString = NSAttributedString(string:String(format: "￥%.2f", self.cellModel.comboAmount?.doubleValue ?? 0.0), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12.0))])
        
        attributedStrM.append(str1)
        attributedStrM.append(str2)
        return attributedStrM
    }
}


//MARK: -私有方法
extension FKYProductActivityGroupFooterCell {
    
    func configRectCornerAndBorder(view: UIView, corner: UIRectCorner, roundCorner: (leftTop:CGFloat,rightTop:CGFloat,rightBottom:CGFloat,leftBottom:CGFloat)=(0,0,0,0),border:(top:Bool,right:Bool,bottom:Bool,left:Bool)=(false,false,false,false),borderWidth:CGFloat = 2,borderColor:UIColor=UIColor.red)  {
        self.borderLayer.removeFromSuperlayer()
        //切圆角
        var radii:CGFloat = 0;
        if roundCorner.leftTop != 0{
            radii = roundCorner.leftTop
        }
        if roundCorner.leftBottom != 0{
            radii = roundCorner.leftBottom
        }
        if roundCorner.rightTop != 0 {
            radii = roundCorner.rightTop
        }
        if roundCorner.rightBottom != 0{
            radii = roundCorner.rightBottom
        }
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii ,height: radii ))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        
        //画边框 从左上角开始
        let pathCenter = borderWidth/2.0
        let path = UIBezierPath()
        path.move(to:CGPoint(x:0,y:0+pathCenter))
        //左上圆角
        if roundCorner.leftTop != 0 {
            path.move(to:CGPoint(x: 0+pathCenter, y: roundCorner.leftTop))
            path.addArc(withCenter: CGPoint(x:roundCorner.leftTop+pathCenter,y:roundCorner.leftTop+pathCenter), radius: roundCorner.leftTop, startAngle:.pi, endAngle: .pi*1.5, clockwise: true)
        }
        
        //右上圆角+上方边框
        if roundCorner.rightTop != 0 {
            if border.top{
                if roundCorner.leftTop != 0{
                    path.move(to: CGPoint(x:roundCorner.leftTop+pathCenter, y:0+pathCenter))
                }else{
                    path.move(to:CGPoint(x:0 ,y:0))
                }
                path.addLine(to: CGPoint(x: view.hd_width-roundCorner.rightTop, y: 0+pathCenter))
            }
            
            path.move(to:CGPoint(x: view.hd_width-roundCorner.rightTop, y: 0+pathCenter))
            path.addArc(withCenter: CGPoint(x:(view.hd_width-roundCorner.rightTop)-pathCenter,y:roundCorner.rightTop+pathCenter), radius: roundCorner.rightTop, startAngle: .pi*1.5, endAngle:0, clockwise: true)
        }else{
            if border.top{
                if roundCorner.leftTop != 0{
                    path.move(to: CGPoint(x:roundCorner.leftTop+pathCenter, y:0+pathCenter))
                }else{
                    path.move(to:CGPoint(x:0 ,y:0))
                }
                path.addLine(to: CGPoint(x:view.hd_width,y:0+pathCenter))
            }
        }
        
        //右下圆角+右边边框
        if roundCorner.rightBottom != 0{
            if border.right{
                if roundCorner.rightTop != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter, y:roundCorner.rightTop+pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width-pathCenter ,y:0))
                }
                path.addLine(to:CGPoint(x: view.hd_width-pathCenter, y: view.hd_height-roundCorner.rightBottom))
            }
            path.move(to:CGPoint(x: view.hd_width-pathCenter, y: view.hd_height-roundCorner.rightBottom))
            path.addArc(withCenter: CGPoint(x:(view.hd_width-roundCorner.rightBottom)-pathCenter,y:(view.hd_height-roundCorner.rightBottom)-pathCenter), radius: roundCorner.rightBottom, startAngle: 0, endAngle:.pi/2.0, clockwise: true)
        }else{
            
            if border.right {
                if roundCorner.rightTop != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter, y:roundCorner.rightTop+pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width-pathCenter ,y:0))
                }
                path.addLine(to: CGPoint(x:view.hd_width-pathCenter,y:view.hd_height))
            }
        }
        
        //左下圆角+下方边框
        if roundCorner.leftBottom != 0{
            if border.bottom {
                if roundCorner.rightBottom != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter-roundCorner.rightBottom, y:view.hd_height - pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width ,y:view.hd_height))
                }
                path.addLine(to:CGPoint(x: roundCorner.leftBottom+pathCenter, y: view.hd_height-pathCenter))
            }
            path.move(to:CGPoint(x: roundCorner.leftBottom+pathCenter, y: view.hd_height-pathCenter))
            path.addArc(withCenter: CGPoint(x:roundCorner.leftBottom+pathCenter,y:(view.hd_height-roundCorner.leftBottom)-pathCenter), radius: roundCorner.leftBottom, startAngle: .pi/2.0, endAngle:.pi, clockwise: true)
        }else{
            if border.bottom {
                if roundCorner.rightBottom != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter-roundCorner.rightBottom, y:view.hd_height - pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0,y:view.hd_height-pathCenter))
            }
        }
        
        //最后一条封闭直线 左边边框
        if roundCorner.leftTop != 0{
            if border.left {
                if roundCorner.leftBottom != 0{
                    path.move(to: CGPoint(x:0+pathCenter, y:view.hd_height - pathCenter-roundCorner.leftBottom))
                }else{
                    path.move(to:CGPoint(x:0+pathCenter ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0+pathCenter,y:roundCorner.leftTop + pathCenter))
            }
        }else{
            if border.left {
                if roundCorner.leftBottom != 0{
                    path.move(to: CGPoint(x:0+pathCenter, y:view.hd_height - pathCenter-roundCorner.leftBottom))
                }else{
                    path.move(to:CGPoint(x:0+pathCenter ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0+pathCenter,y:0))
            }
        }
        
        path.stroke()
        borderLayer.frame = view.bounds
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(borderLayer)
    }
}


//MARK: -类方法
extension FKYProductActivityGroupFooterCell{
    static func getCellHeight() -> CGFloat{
        return WH(33.0);
    }
}
