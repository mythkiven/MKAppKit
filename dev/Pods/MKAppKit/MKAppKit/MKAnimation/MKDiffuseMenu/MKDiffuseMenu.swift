//
//
//  V1.2.1
//
//  Created by mythkiven on 17/1/11.
//  github 地址:https://github.com/mythkiven
//
//  说明如下:
//  1、本动画是 Swift 版本的 AwesomeMenu,OC 版请参考 https://github.com/levey/AwesomeMenu
//  2、代码解析见 https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/README.md
//  3、修订记录见 https://github.com/mythkiven/DiffuseMenu_Swift/blob/master/Revision History.md
//  4、支持 cocoaPods



import UIKit
import QuartzCore


@objc public protocol MKDiffuseMenuDelegate : NSObjectProtocol {
    
    /// 将要开始展开动画
    @objc func MKDiffuseMenuWillOpen(_ menu: MKDiffuseMenu)
    
    /// 将要开始关闭动画
    @objc func MKDiffuseMenuWillClose(_ menu: MKDiffuseMenu)
    
    /// 选中选项按钮
    @objc func MKDiffuseMenuDidSelectMenuItem(_ menu: MKDiffuseMenu, didSelectIndex index: Int)
    
    /// 展开动画展开结束
    @objc  func MKDiffuseMenuDidOpen(_ menu: MKDiffuseMenu)
    
    /// 关闭动画关闭结束
    @objc func MKDiffuseMenuDidClose(_ menu: MKDiffuseMenu)
    
}

open class MKDiffuseMenu : UIView, MKDiffuseMenuItemDelegate, CAAnimationDelegate {
    
    
    /// 动画展示的2种类型:直线状\圆弧状
    public enum MKDiffuseMenuGrapyType : String {
        case line
        case arc
    }
    
    /// 动画展示的角度:已给出常见的8个方位可直接使用,默认upperRight
    /// 本枚举对 line 和 arc 皆有效
    public enum MKDiffuseMenuDirection : String {
        case above      // 上方180°
        
        case left       // 左方180°
        
        case right      // 右方180°
        
        case below      // 下方180°
        
        case upperLeft  // 左上方90°
        
        case upperRight // 右上方90°
        
        case lowerLeft  // 左下方90°
        
        case lowerRight // 右下方90°
        
        case other      // 其他方向
    }
    
    
    // MARK: - 属性
    
    
    ///弧线动画,则动画中半径的变化:从0-->最大farRadius-->最小nearRadius-->结束endRadius
    ///直线动画,则半径长度就是线段的长度,线段长度从0 -->farRadius-->nearRadius-->endRadius
    open var nearRadius:             CGFloat!
    open var endRadius:              CGFloat!
    open var farRadius:              CGFloat!
    
    /// 动画起始点
    open var startPoint:             CGPoint!
    
    /// 单个动画开始执行时间间隔
    open var timeOffset:             TimeInterval = 0
    
    /// 整体偏移角度，注意与menuWholeAngle差异，一般默认0不偏移
    open var rotateAngle:            CGFloat!
    
    /// 如果是弧线动画,则 menuWholeAngle配置弧线的圆心角
    /// 如果是直线动画,则 menuWholeAngle未参与计算,值无效
    open var menuWholeAngle:         CGFloat!
    
    /// 展开时选项自旋角度
    open var expandRotation:         CGFloat!
    
    /// 关闭时选项自旋角度
    open var closeRotation:          CGFloat!
    
    /// 动画时长
    open var animationDuration:      CFTimeInterval!
    
    /// 是否要旋转菜单按钮
    open var rotateAddButton:        Bool!
    
    /// 旋转菜单按钮旋转的角度
    open var rotateAddButtonAngle:   CGFloat!
    
    /// 是否在展开状态
    open var expanding:              Bool = false
    
    /// delegate
    open var delegate:               MKDiffuseMenuDelegate!
    
    /// 动画的类型:默认弧线动画
    open var sDiffuseMenuGrapyType:  MKDiffuseMenuGrapyType = .arc {
        didSet {
            if  menusItems.count > 0 {
                _setMenu(immediateActivity: false)
            }
        }
    }
    
    /// 动画的方向:方向默认右上角
    open var sDiffuseMenuDirection: MKDiffuseMenuDirection = .upperRight {
        didSet {
            var lineRotateAngle = CGFloat(0.0)
            
            switch sDiffuseMenuDirection {
            case .above: // 上方 180°
                menuWholeAngle  = CGFloat(M_PI)
                rotateAngle     = CGFloat(M_PI_2*3)
                lineRotateAngle = CGFloat(0.0)
                
            case .left: // 左方 180°
                menuWholeAngle  = CGFloat(M_PI)
                rotateAngle     = CGFloat(M_PI)
                lineRotateAngle = CGFloat(-M_PI_2)
                
            case .below: // 下方 180°
                menuWholeAngle  = CGFloat(M_PI)
                rotateAngle     = CGFloat(M_PI_2)
                lineRotateAngle = CGFloat(M_PI)
                
            case .right: // 右方 180°
                menuWholeAngle  = CGFloat(M_PI)
                rotateAngle     = CGFloat(0)
                lineRotateAngle = CGFloat(M_PI_2)
                
            case .upperLeft: // 左上角90°
                menuWholeAngle  = CGFloat(M_PI_2)
                rotateAngle     = CGFloat(-M_PI_2)
                lineRotateAngle = CGFloat(-M_PI_4)
                
            case .upperRight: // 右上角90°
                menuWholeAngle  = CGFloat(M_PI_2)
                rotateAngle     = CGFloat(0)
                lineRotateAngle = CGFloat(M_PI_4)
                
            case .lowerLeft: // 左下角90°
                menuWholeAngle  = CGFloat(M_PI_2)
                rotateAngle     = CGFloat(-M_PI)
                lineRotateAngle = CGFloat(-M_PI_4*3)
                
            case .lowerRight: // 右下角90°
                menuWholeAngle  = CGFloat(M_PI_2)
                rotateAngle     = CGFloat(M_PI_2)
                lineRotateAngle = CGFloat(M_PI_4*3)
                
            default:
                break
            }
            
            if sDiffuseMenuGrapyType == MKDiffuseMenuGrapyType.line { // 直线形
                rotateAngle = lineRotateAngle
            }
        }
    }
    
    /// 选项数组
    open var menusItems: NSArray!{
        willSet {
            if (menusItems == newValue) {
                return
            }
            
            for v in self.subviews {
                if (v.tag >= 1000) {
                    v.removeFromSuperview()
                }
            }
        }
    }
    
    private var _flag:          Int = 0
    private var _timer:         Timer!
    private var _startButton:   MKDiffuseMenuItem!
    private var _isAnimating:   Bool = false
    
    
    let kDiffuseMenuDefaultNearRadius                   = CGFloat(110.0)
    let kDiffuseMenuDefaultEndRadius                    = CGFloat(120.0)
    let kDiffuseMenuDefaultFarRadius                    = CGFloat(140.0)
    let kDiffuseMenuDefaultStartPointX                  = CGFloat(160.0)
    let kDiffuseMenuDefaultStartPointY                  = CGFloat(240.0)
    let kDiffuseMenuDefaultTimeOffset                   = 0.036
    let kDiffuseMenuDefaultRotateAngle                  = CGFloat(0.0)
    let kDiffuseMenuRotateAddButtonAngle                = CGFloat(-M_PI_4)
    let kDiffuseMenuDefaultMenuWholeAngle               = CGFloat(M_PI * 2)
    let kDiffuseMenuDefaultExpandRotation               = CGFloat(M_PI)
    let kDiffuseMenuDefaultCloseRotation                = CGFloat(M_PI * 2)
    let kDiffuseMenuDefaultAnimationDuration            = 0.5
    let kDiffuseMenuStartMenuDefaultAnimationDuration   = 0.3
    
    
    // MARK: - 初始化
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    public init(frame: CGRect, startItem: MKDiffuseMenuItem, menusArray: NSArray, grapyType: MKDiffuseMenuGrapyType) {
        super.init(frame: frame)
        
        self.sDiffuseMenuGrapyType  = grapyType
        
        self.nearRadius             = kDiffuseMenuDefaultNearRadius
        self.endRadius              = kDiffuseMenuDefaultEndRadius
        self.farRadius              = kDiffuseMenuDefaultFarRadius
        self.timeOffset             = Double(kDiffuseMenuDefaultTimeOffset)
        self.rotateAngle            = kDiffuseMenuDefaultRotateAngle
        self.menuWholeAngle         = kDiffuseMenuDefaultMenuWholeAngle
        self.startPoint             = CGPoint(x: kDiffuseMenuDefaultStartPointX, y: kDiffuseMenuDefaultStartPointY)
        self.expandRotation         = kDiffuseMenuDefaultExpandRotation
        self.closeRotation          = kDiffuseMenuDefaultCloseRotation
        self.animationDuration      = Double(kDiffuseMenuDefaultAnimationDuration)
        self.rotateAddButton        = true
        self.rotateAddButtonAngle   = kDiffuseMenuRotateAddButtonAngle
        self.backgroundColor        = UIColor.white
        
        self.menusItems             = menusArray
        _startButton                = startItem
        _startButton.delegate       = self
        _startButton.center         = self.startPoint
        
        self.addSubview(_startButton)
    }
    
    
    //
    //    func setStartPoint(_ aPoint: CGPoint) {
    //        startPoint          = aPoint
    //        _startButton.center = aPoint
    //    }
    //    func setImage(_ image: UIImage) {
    //        _startButton.image = image
    //    }
    //    func image() -> UIImage {
    //        return _startButton.image!
    //    }
    //    func setHighlightedImage(_ highlightedImage: UIImage) {
    //        _startButton.highlightedImage = highlightedImage
    //    }
    //    func getHighlightedImage() -> UIImage {
    //        return _startButton.highlightedImage!
    //    }
    //    func setContentImage(_ contentImage: UIImage) {
    //        _startButton.contentImageView.image = contentImage
    //    }
    //    func getContentImage() -> UIImage {
    //        return _startButton.contentImageView.image!
    //    }
    //    func setHighlightedContentImage(_ highlightedContentImage: UIImage) {
    //        _startButton.contentImageView.highlightedImage = highlightedContentImage
    //    }
    //    func getHighlightedContentImage() -> UIImage {
    //        return _startButton.contentImageView.highlightedImage!
    //    }
    
    
    
    // MARK: - public
    
    
    /// 展开动画
    open func open() {
        if _isAnimating == true || self.expanding == true {
            return
        }
        _expandingMenu(true)
    }
    
    /// 关闭动画
    open func close() {
        if _isAnimating == true || self.expanding == false {
            return
        }
        _expandingMenu(false)
    }
    
    /// 某 index 对应的选项
    open func menuItemAtIndex(_ index: Int) -> MKDiffuseMenuItem? {
        if index >= menusItems.count {
            return nil
        }
        return menusItems.object(at: index) as? MKDiffuseMenuItem
    }
    
    
    // MARK: - MKDiffuseMenuItemDelegate
    
    
    public func MKDiffuseMenuItemTouchesBegan(_ item: MKDiffuseMenuItem) {
        if (item == _startButton) {
            self.expanding = !self.expanding
            _expandingMenu(self.expanding)
        }
    }
    
    public func MKDiffuseMenuItemTouchesEnd(_ item: MKDiffuseMenuItem) {
        if (item == _startButton) {
            return
        }
        
        let blowup = self._blowupAnimationAtPoint(item.center)
        item.layer.add(blowup, forKey: "blowup")
        item.center = item.startPoint
        
        for index in 0 ..< menusItems.count {
            let otherItem = menusItems.object(at: index) as! MKDiffuseMenuItem
            let shrink    = self._shrinkAnimationAtPoint(otherItem.center)
            if (otherItem.tag == item.tag) {
                continue
            }
            otherItem.layer.add(shrink, forKey: "shrink")
            otherItem.center = otherItem.startPoint
        }
        
        expanding = false
        
        let angle =  self.expanding ? -M_PI_4 : 0.0
        UIView.animate(withDuration: animationDuration, animations: {
            ()-> Void in
            self._startButton.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        })
        
        self.delegate.MKDiffuseMenuDidSelectMenuItem(self, didSelectIndex: (item.tag - 1000))
    }
    
    
    // MARK: - touch
    
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (_isAnimating) {
            return false
            
        }else if (true == expanding) {
            return true
            
        } else {
            return _startButton.frame.contains(point)
            
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.expanding = !self.expanding
        _expandingMenu(self.expanding)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(anim.value(forKey: "id") as? NSString == "lastAnimation") {
            self.delegate?.MKDiffuseMenuDidClose(self)
        }
        if(anim.value(forKey: "id") as? NSString == "firstAnimation") {
            self.delegate?.MKDiffuseMenuDidOpen(self)
        }
    }
    
    
    // MARK: - private
    
    
    private func _expandingMenu(_ expanding: Bool) {
        if (expanding) {
            self._setMenu(immediateActivity: true)
            self.delegate?.MKDiffuseMenuWillOpen(self)
        }else {
            self.delegate?.MKDiffuseMenuWillClose(self)
        }
        
        self.expanding = expanding
        
        if ((rotateAddButton) == true) {
            let angle = self.expanding ? rotateAddButtonAngle : 0.0
            UIView.animate(withDuration: Double(kDiffuseMenuStartMenuDefaultAnimationDuration), animations: {
                ()-> Void in
                self._startButton.transform = CGAffineTransform(rotationAngle: CGFloat(angle!))
            })
        }
        
        if (_timer == nil) {
            _flag = self.expanding ? 0 : (menusItems.count - 1)
            let selector =  self.expanding ? #selector(_expandAnimation) : #selector(_closeAnimation)
            _timer = Timer(timeInterval: timeOffset,
                           target: self,
                           selector: selector,
                           userInfo: nil,
                           repeats: true)
            RunLoop.current.add(_timer, forMode: RunLoop.Mode.common)
            _isAnimating = true
        }
    }
    
    @objc private func _expandAnimation() {
        if (_flag == menusItems.count) {
            _isAnimating = false
            _timer.invalidate()
            _timer = nil
            return
        }
        let tag =  1000 + _flag
        
        if self.viewWithTag(tag) == nil {
            return
        }
        
        let item = self.viewWithTag(tag) as! MKDiffuseMenuItem
        
        let rotateAnimation         =  CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values      = [CGFloat(0.0),
                                       CGFloat(expandRotation),
                                       CGFloat(0.0)]
        rotateAnimation.duration    = animationDuration
        rotateAnimation.keyTimes    = [NSNumber(value: 0.1 as Float),
                                       NSNumber(value: 0.3 as Float),
                                       NSNumber(value: 0.4 as Float)]
        
        let positionAnimation       =  CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration  = animationDuration
        
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
        path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
        path.addLine(to: CGPoint(x: item.nearPoint.x, y: item.nearPoint.y))
        path.addLine(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
        positionAnimation.path = path.cgPath
        
        /*  写法2:
         
         let path =  CGMutablePath()
         path.move(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
         path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
         path.addLine(to: CGPoint(x: item.nearPoint.x, y: item.nearPoint.y))
         path.addLine(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
         positionAnimation.path = path
         
         */
        
        let animationgroup          =  CAAnimationGroup()
        animationgroup.animations   = [positionAnimation, rotateAnimation ]
        animationgroup.duration     = animationDuration
        animationgroup.fillMode     = CAMediaTimingFillMode.forwards
        animationgroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animationgroup.delegate     = self
        
        if(_flag == menusItems.count - 1) {
            animationgroup.setValue("firstAnimation", forKey: "id")
        }
        
        item.layer.add(animationgroup, forKey: "Expand")
        item.center = item.endPoint
        
        _flag += 1
    }
    
    @objc private func _closeAnimation() {
        if (_flag == -1) {
            _isAnimating = false
            _timer.invalidate()
            _timer = nil
            return
        }
        
        let tag  =  1000 + _flag
        let item =  self.viewWithTag(tag) as! MKDiffuseMenuItem
        
        let rotateAnimation         =  CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values      = [CGFloat(0.0),
                                       CGFloat(closeRotation),
                                       CGFloat(0.0)]
        rotateAnimation.duration    = animationDuration
        rotateAnimation.keyTimes    = [NSNumber(value: 0.0 as Float),
                                       NSNumber(value: 0.4 as Float),
                                       NSNumber(value: 0.5 as Float)]
        
        let positionAnimation       =  CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration  = animationDuration
        
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
        path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
        path.addLine(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
        positionAnimation.path = path.cgPath
        
        /*  写法2:
         
         let path =  CGMutablePath()
         path.move(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
         path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
         path.addLine(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
         positionAnimation.path = path
         
         */
        
        let animationgroup          =  CAAnimationGroup()
        animationgroup.animations   = [positionAnimation, rotateAnimation]
        animationgroup.duration     = animationDuration
        animationgroup.fillMode     = CAMediaTimingFillMode.forwards
        animationgroup.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)
        animationgroup.delegate     = self
        
        if(_flag == 0){
            animationgroup.setValue("lastAnimation", forKey: "id")
        }
        
        item.layer.add(animationgroup, forKey: "Close")
        item.center = item.startPoint
        
        _flag -= 1
    }
    
    private func _blowupAnimationAtPoint(_ p:CGPoint) -> CAAnimationGroup {
        
        let positionAnimation =  CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [NSValue(cgPoint: p)]
        positionAnimation.keyTimes = [NSNumber(value: 0.3 as Float)]
        
        let scaleAnimation =  CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(3.0, 3.0, 1.0))
        
        let opacityAnimation =  CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue  = NSNumber(value: 0.0 as Float)
        
        let animationgroup =  CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = animationDuration
        animationgroup.fillMode = CAMediaTimingFillMode.forwards
        
        return animationgroup
    }
    
    private func _shrinkAnimationAtPoint(_ p: CGPoint) -> CAAnimationGroup {
        
        let positionAnimation       =  CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values    = [ NSValue(cgPoint: p) ]
        positionAnimation.keyTimes  = [ NSNumber(value: 0.3 as Float) ]
        
        let scaleAnimation          =  CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue      = NSValue(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1))
        
        let opacityAnimation        =  CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue    = NSNumber(value: 0.0 as Float)
        
        let animationgroup          =  CAAnimationGroup()
        animationgroup.animations   = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration     = animationDuration
        animationgroup.fillMode     = CAMediaTimingFillMode.forwards
        
        return animationgroup
    }
    
    private func _rotateCGPointAroundCenter( _ point: CGPoint, center: CGPoint, angle: CGFloat) -> CGPoint {
        
        let translation     = CGAffineTransform(translationX: center.x, y: center.y)
        let rotation        = CGAffineTransform(rotationAngle: angle)
        let transformGroup  = translation.inverted().concatenating(rotation).concatenating(translation)
        
        return point.applying(transformGroup)
    }
    
    private func _setMenu(immediateActivity: Bool) {
        
        if !immediateActivity && (_isAnimating == true || expanding == true ){
            return
        }
        
        for index in 0 ..< menusItems.count {
            
            let icount      = CGFloat(menusItems.count)
            let item        = menusItems.object(at: index) as! MKDiffuseMenuItem
            let ti          = CGFloat(index)
            item.tag        = 1000 + index
            item.startPoint = self.startPoint
            
            if (menuWholeAngle >= CGFloat(M_PI * 2)) {
                menuWholeAngle = menuWholeAngle - menuWholeAngle / (icount)
            }
            
            var sinValue = CGFloat(0.0)
            var cosValue = CGFloat(0.0)
            
            if icount == 1 {
                sinValue = CGFloat(sinf(Float(menuWholeAngle / 2)))
                cosValue = CGFloat(cosf(Float(menuWholeAngle / 2)))
            }else {
                sinValue = CGFloat(sinf(Float(ti * menuWholeAngle / (icount - CGFloat(1.0)))))
                cosValue = CGFloat(cosf(Float(ti * menuWholeAngle / (icount - CGFloat(1.0)))))
            }
            
            
            
            if sDiffuseMenuGrapyType == MKDiffuseMenuGrapyType.line { // 直线形
                var x           = startPoint.x
                var y           = startPoint.y + ti * CGFloat(endRadius / (icount + 1))
                let endPoint    =  CGPoint(x: x,y: y)
                item.endPoint   = _rotateCGPointAroundCenter(endPoint, center: startPoint, angle:  rotateAngle - CGFloat(M_PI))
                
                x               = startPoint.x
                y               = startPoint.y + ti * CGFloat(nearRadius / (icount + 1))
                let nearPoint   =  CGPoint(x: x, y: y)
                item.nearPoint  = _rotateCGPointAroundCenter(nearPoint, center: startPoint, angle: rotateAngle - CGFloat(M_PI))
                
                x               = startPoint.x
                y               = startPoint.y + ti * CGFloat(farRadius / (icount + 1))
                let farPoint    =  CGPoint(x: x, y: y)
                item.farPoint   = _rotateCGPointAroundCenter(farPoint, center: startPoint, angle: rotateAngle - CGFloat(M_PI))
                
            }else { // 弧线形
                var x           = startPoint.x + CGFloat(endRadius) * sinValue
                var y           = (CGFloat(startPoint.y) - endRadius * cosValue)
                let endPoint    =  CGPoint(x: x,y: y)
                item.endPoint   = _rotateCGPointAroundCenter(endPoint, center: startPoint, angle: rotateAngle)
                
                x               = startPoint.x + nearRadius * CGFloat(sinValue)
                y               = startPoint.y - nearRadius * CGFloat(cosValue)
                let nearPoint   =  CGPoint(x: x, y: y)
                item.nearPoint  = _rotateCGPointAroundCenter(nearPoint, center: startPoint, angle: rotateAngle)
                
                x               = startPoint.x + farRadius * sinValue
                y               = startPoint.y - farRadius * cosValue
                let farPoint    =  CGPoint(x: x, y: y)
                item.farPoint   = _rotateCGPointAroundCenter(farPoint, center: startPoint, angle: rotateAngle)
            }
            
            item.center    = item.startPoint
            item.delegate  = self
            
            if immediateActivity {
                self.insertSubview(item, belowSubview:_startButton)
            }
            
        }
    }
    
}















