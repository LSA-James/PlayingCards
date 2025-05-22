//
//  PlayingCardView.swift
//  PlayingCards
//
//  Created by James Liu on 2025/5/24.
//

import UIKit

//view本体

class PlayingCardView: UIView {

    //数据
    var rank: Int = 9 { didSet { setNeedsDisplay(); setNeedsLayout()} }
    var suit: String = "❤️" { didSet { setNeedsDisplay(); setNeedsLayout()} }
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout()} }

    //MARK: NSAttrubutedString
    private var cornerString:NSAttributedString {
        return centerdAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }

    //配置 NSAttrubutedString 内容、字体、大小
    private func centerdAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle,.font:font])
    }

    

    //MARK: UILabel
    private lazy var upperLeftCornerLable = createCornerLabel()
    private lazy var lowerRightCornerLable = createCornerLabel()

    //设置 UILabel 的示例创建
    //设置 UILabel 的行数
    //设置 UILabel 在层级结构的位置（添加到 UI 的层级结构中才能被显示）
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0 //允许任意行数
        addSubview(label) //添加到层级结构
        return label
    }

    //设置 UILabel 的 AttributedString
    //设置 UILabel 的 大小
    private func configureCornerLabel(_ label: UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
        /*
        if isFaceUp {
            label.isHidden = false
        }else{
            label.isHidden = true
        }
         */
    }
    
    //布置子视图 这个函数只能被系统调用，用户可以通过调用 setNeedsLayout() 间接调用 layoutSubviews()
    override func layoutSubviews() {
        super.layoutSubviews()

        //设置UILabel的位置、旋转
        configureCornerLabel(upperLeftCornerLable)
        configureCornerLabel(lowerRightCornerLable)
        upperLeftCornerLable.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        //print(lowerRightCornerLable.frame)

        lowerRightCornerLable.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLable.frame.width/2,
                          y: lowerRightCornerLable.frame.height/2)
            // 如果调整位置为目的，不应该用translate调整位置，推荐用label.center，这里仅仅是做出一个演示
            // 必须设定一个确定的frame的位置才能配合translate使用，否则frame位置是被默认分配的，在不确定的位置上进行变换，结果自然也是不确定的
            .rotated(by: CGFloat.pi) // 现在默认以中心旋转，而非左上角圆点
        
        lowerRightCornerLable.center = bounds.origin
            .offsetBy(dx: bounds.width, dy: bounds.height)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLable.frame.width, dy: -lowerRightCornerLable.frame.height)
        
        //print(upperLeftCornerLable.frame)
        //print(lowerRightCornerLable.frame)
        

    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        //这行代码相当于设置了contentMode.Redraw
        //旋转屏幕后，会自动触发这个
        registerForTraitChanges([UITraitHorizontalSizeClass.self, UITraitVerticalSizeClass.self]) {
            (view: Self, previousTraitCollection: UITraitCollection) in
            
            let newH = view.traitCollection.horizontalSizeClass
            let oldH = previousTraitCollection.horizontalSizeClass
            let newV = view.traitCollection.verticalSizeClass
            let oldV = previousTraitCollection.verticalSizeClass

            if newH != oldH || newV != oldV {
                print("HorizontalSizeClass和VerticalSizeClass发生变化")
            }
            self.setNeedsDisplay()
            self.setNeedsLayout()
        }
        
        //当系统字体大小发生变化，会自动触发这个
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self], handler: {
            (view: Self, previousTraitCollection: UITraitCollection) in
            
            let new = view.traitCollection.preferredContentSizeCategory
            let old = previousTraitCollection.preferredContentSizeCategory

            if new != old {
                print("preferredContentSizeCategory发生了变化")
            }
            // self.setNeedsDisplay()
            // self.setNeedsLayout()
        })
        
        //离开程序后，会自动触发这个
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: {
            (view: Self, previousTraitCollection: UITraitCollection) in
            
            let newH = view.traitCollection.userInterfaceStyle
            let oldH = previousTraitCollection.userInterfaceStyle

            if newH != oldH {
                print("UserInterfaceStyle发生了变化")
            }
            //self.setNeedsDisplay()
            //self.setNeedsLayout()
        })
    }


    //绘制图像 这个函数只能被系统调用，用户可以通过调用 setNeedsDisplay() 间接调用 setNeedsDisplay()
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()//除了roundedRect，其他位置都被剪裁掉了，所以只有roundedRect中可以进行绘制，这就是Clip的概念。总结一下，Clip中的内容可见，非Clip的内容必然不可见
        UIColor.white.setFill()
        roundedRect.fill()
        
        print(rankString+suit)
        if let cardImage = UIImage(named: rankString+suit){
            print(cardImage)
            //cardImage.draw(at: CGPoint(x: bounds.midX-cardImage.size.width/2, y: bounds.midY-cardImage.size.height/2))
            cardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
        }
        
        
        if (1...10).contains(rank){
            
            drawRank()
            
            /*
            //配置String
            let myString = NSAttributedString(string: suit, attributes:[
                .font:UIFontMetrics(forTextStyle: UIFont.TextStyle.body).scaledFont(for: UIFont.systemFont(ofSize: cornerFontSize+10))
            ])
            
            //配置Lable
            let myLable = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            myLable.attributedText = myString
            myLable.backgroundColor = UIColor.blue
            myLable.textAlignment = NSTextAlignment.center
            //配置Lable
            let myLable2 = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            myLable2.attributedText = myString
            myLable2.backgroundColor = UIColor.green
            myLable2.textAlignment = NSTextAlignment.center
            
            //配置Stack
            let myStackView = UIStackView(arrangedSubviews: [myLable,myLable2])
            
            print(myStackView.subviews)
            myStackView.frame = bounds.leftHalf
            myStackView.axis = NSLayoutConstraint.Axis.vertical
            myStackView.alignment = UIStackView.Alignment.fill
            myStackView.distribution = UIStackView.Distribution.fillEqually
            myStackView.sizeToFit()
            myStackView.backgroundColor = UIColor.black
            addSubview(myStackView)
             */
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //setNeedsDisplay()
        //setNeedsLayout()
    }
    
    func drawRank(){
        let rankLayout = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        let Layout = rankLayout[rank]
        let BigStack = UIStackView(frame: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
        BigStack.axis = .vertical
        BigStack.alignment = .fill
        BigStack.distribution = .fillEqually
        BigStack.center = CGPoint(x: bounds.midX, y: bounds.midY)
        for numebrOfSuitIneachLine in Layout {
            let smallStack = UIStackView()
            smallStack.axis = .horizontal
            smallStack.alignment = .fill
            smallStack.distribution = .fillEqually
            for numberOfSuit in 1...numebrOfSuitIneachLine {
                let string = NSAttributedString(string:suit, attributes: [
                    .font:UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: cornerFontSize) )
                ])
                let label = UILabel()
                label.attributedText = string
                label.textAlignment = .center
                //label.backgroundColor = .black
                smallStack.addArrangedSubview(label)
            }
            BigStack.addArrangedSubview(smallStack)
            print(BigStack.subviews)
        }
        addSubview(BigStack)
    }
}



//记录字体和相关数据的比值，这样可以大小可以根据缩放自如的调整
extension PlayingCardView{
    
    //Swift 惯例用 Struct 封装一系列相关的 静态常量
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat{
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat{
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat{
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String{
        switch rank{
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect{
    var leftHalf: CGRect{
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: midY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat)->CGPoint{
        return CGPoint(x: x+dx, y: y+dy)
    }
}




/*
//NSAttributedString可以直接调用draw绘制在View上面
let text1 = NSAttributedString.init(string: "❤️", attributes: [
    .font: UIFont.systemFont(ofSize: 24),
    .foregroundColor: UIColor.black,
])
let text2 = text1
let leftUpCorner = CGPoint(x: 20, y: 20)
text1.draw(at: leftUpCorner)

//let rightDownCorner = CGPoint(x: bounds.width-text2.size().width-20, y: bounds.height-text2.size().height-20)
//text2.draw(at: rightDownCorner)



//将❤️倒置的绘图方法
if let context = UIGraphicsGetCurrentContext() {
    context.saveGState() // 保存当前状态
    
    // 将坐标系平移到 text2 的绘制起点 + 中心
    let textSize = text2.size()
    let origin = CGPoint(x: bounds.width - textSize.width - 20,
                         y: bounds.height - textSize.height - 20)
    
    context.translateBy(x: origin.x + textSize.width / 2, y: origin.y + textSize.height / 2)
    context.rotate(by: .pi) // 旋转 180 度（上下颠倒）
    
    // 由于旋转之后坐标系也跟着变了，要从 (-w/2, -h/2) 开始绘制
    let flippedOrigin = CGPoint(x: -textSize.width / 2, y: -textSize.height / 2)
    text2.draw(at: flippedOrigin)
    
    context.restoreGState() // 恢复上下文状态
}
*/


/*
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.addArc(center: .init(x: bounds.midX, y: bounds.midY), radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        context.setLineWidth(20)
        guard let path = context.path else { return }
        UIColor.red.setStroke()
        UIColor.green.setFill()
        context.strokePath()
        context.fillPath()
        
        let path = UIBezierPath.init()
        path.addArc(withCenter: .init(x: bounds.midX, y: bounds.midY), radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.lineWidth = 20
        UIColor.red.setStroke()
        UIColor.green.setFill()
        path.stroke()
        path.fill()
*/
