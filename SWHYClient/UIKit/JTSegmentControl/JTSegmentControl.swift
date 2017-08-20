//
//  JTSegmentControl.swift
//  JTSegmentControlDemo
//
//  Created by xia on 16/11/13.
//  Copyright © 2016年 JT. All rights reserved.
//

import UIKit

private class JTSliderView : UIView {
    
    var color : UIColor? {
        didSet{
            self.backgroundColor = color
        }
    }
}

 enum JTItemViewState : Int {
    case Normal
    case Selected
}

class JTItemView : UIView {
    
    func itemWidth() -> CGFloat {
        
        if let text = titleLabel.text {
            let string = text as String
            //let size = string.size(attributes: [NSFontAttributeName:selectedFont!])
            
            let width = getTexWidth(string, font: titleLabel.font, height: 100)
            return width + JTSegmentPattern.itemBorder     
            //return stringSize.width + JTSegmentPattern.itemBorder
        }
        
        return 0.0
    }
    
    
   
    
    func getTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let normalText: NSString = textStr
        
        let size = CGSizeMake(1000, height)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName)
        
        let stringSize = normalText.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        
        return stringSize.width
        
    }
    
    
    let titleLabel = UILabel()
    lazy var bridgeView : CALayer = {
        let view = CALayer()
        let width = JTSegmentPattern.bridgeWidth
        view.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        view.backgroundColor = JTSegmentPattern.bridgeColor.CGColor
        view.cornerRadius = view.bounds.size.width * 0.5
        return view
    }()
    
     func showBridge(show:Bool){
        //self.bridgeView.isHidden = !show
        self.bridgeView.hidden = !show
    }
    
     var state : JTItemViewState = .Normal {
        didSet{
            updateItemView(state)
        }
    }
    
     var font : UIFont?{
        didSet{
            if state == .Normal {
                self.titleLabel.font = font
            }
        }
    }
     var selectedFont : UIFont?{
        didSet{
            if state == .Selected {
                self.titleLabel.font = selectedFont
            }
        }
    }
    
     var text : String?{
        didSet{
            self.titleLabel.text = text
        }
    }
    
     var textColor : UIColor?{
        didSet{
            if state == .Normal {
                self.titleLabel.textColor = textColor
            }
        }
    }
     var selectedTextColor : UIColor?{
        didSet{
            if state == .Selected {
                self.titleLabel.textColor = selectedTextColor
            }
        }
    }
    
     var itemBackgroundColor : UIColor?{
        didSet{
            if state == .Normal {
                self.backgroundColor = itemBackgroundColor
            }
        }
    }
     var selectedBackgroundColor : UIColor?{
        didSet{
            if state == .Selected {
                self.backgroundColor = selectedBackgroundColor
            }
        }
    }
    
     var textAlignment = NSTextAlignment.Center {
        didSet{
            self.titleLabel.textAlignment = textAlignment
        }
    }
    
    private func updateItemView(state:JTItemViewState){
        switch state {
        case .Normal:
            self.titleLabel.font = self.font
            self.titleLabel.textColor = self.textColor
            self.backgroundColor = self.itemBackgroundColor
        case .Selected:
            self.titleLabel.font = selectedFont
            self.titleLabel.textColor = self.selectedTextColor
            self.backgroundColor = self.selectedBackgroundColor
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = NSTextAlignment.Center
        
        addSubview(titleLabel)
        
        bridgeView.hidden = true
        layer.addSublayer(bridgeView)
        
        layer.masksToBounds = true
    }
    
     override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        
        titleLabel.center.x = bounds.size.width * 0.5
        titleLabel.center.y = bounds.size.height * 0.5
        
        let width = bridgeView.bounds.size.width
        let x:CGFloat = titleLabel.frame.maxX
        bridgeView.frame = CGRect(x: x, y: bounds.midY - width, width: width, height: width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//public
@objc public protocol JTSegmentControlDelegate {
    @objc optional func didSelected(segement:JTSegmentControl, index: Int)
}

public class JTSegmentControl: UIControl {
    
     struct Constants {
        static let height : CGFloat = 40.0
    }
    
     public weak var delegate : JTSegmentControlDelegate?
    
     public var autoAdjustWidth = false {
        didSet{
            
        }
    }
    
    //recomend to use segmentWidth(index:Int)
    public func segementWidth() -> CGFloat {
        return bounds.size.width / (CGFloat)(itemViews.count)
    }
    //when autoAdjustWidth is true, the width is not necessarily the same
    public func segmentWidth(index:Int) -> CGFloat {
        guard index >= 0 && index < itemViews.count else {
            return 0.0
        }
        if autoAdjustWidth {
            return itemViews[index].itemWidth()
        }else{
            return segementWidth()
        }
    }
    
    public var selectedIndex = 0 {
        willSet{
            let originItem = self.itemViews[selectedIndex]
            originItem.state = .Normal
            
            let selectItem = self.itemViews[newValue]
            selectItem.state = .Selected
        }
    }
    
    //MARK - color set
    public var itemTextColor = JTSegmentPattern.itemTextColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.textColor = itemTextColor
            }
        }
    }
    
    public var itemSelectedTextColor = JTSegmentPattern.itemSelectedTextColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedTextColor = itemSelectedTextColor
            }
        }
    }
    public var itemBackgroundColor = JTSegmentPattern.itemBackgroundColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.itemBackgroundColor = itemBackgroundColor
            }
        }
    }
    
    public var itemSelectedBackgroundColor = JTSegmentPattern.itemSelectedBackgroundColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedBackgroundColor = itemSelectedBackgroundColor
            }
        }
    }
    
    public var sliderViewColor = JTSegmentPattern.sliderColor{
        didSet{
            self.sliderView.color = sliderViewColor
        }
    }
    
    //MAR - font
    public var font = JTSegmentPattern.textFont{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.font = font
            }
        }
    }
    
    public var selectedFont = JTSegmentPattern.selectedTextFont{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedFont = selectedFont
            }
        }
    }
    
    public var items : [String]?{
        didSet{
            guard items != nil && items!.count > 0 else {
                fatalError("Items cannot be empty")
            }
            
            self.removeAllItemView()
            
            
            for title in items! {
                let view = self.createItemView(title)
                self.itemViews.append(view)
                self.contentView.addSubview(view)
            }
            self.selectedIndex = 0
            
            self.contentView.bringSubviewToFront(self.sliderView)
        }
    }
    
    public func showBridge(show:Bool, index:Int){
        
        guard index < itemViews.count && index >= 0 else {
            return
        }
        
        itemViews[index].showBridge(show)
    }
    
    
    //when true, scrolled the itemView to a point when index changed
    public var autoScrollWhenIndexChange = true
    
    public var scrollToPointWhenIndexChanged = CGPoint(x: 0.0, y: 0.0)
    
    public var bounces = false {
        didSet{
            self.scrollView.bounces = bounces
        }
    }
    
     func removeAllItemView() {
        itemViews.forEach { (label) in
            label.removeFromSuperview()
        }
        itemViews.removeAll()
    }
    private var itemWidths = [CGFloat]()
    private func createItemView(title:String) -> JTItemView {
        return createItemView(title,
                              font: self.font,
                              selectedFont: self.selectedFont,
                              textColor: self.itemTextColor,
                              selectedTextColor: self.itemSelectedTextColor,
                              backgroundColor: self.itemBackgroundColor,
                              selectedBackgroundColor: self.itemSelectedBackgroundColor
        )
    }
    
    private func createItemView(title:String, font:UIFont, selectedFont:UIFont, textColor:UIColor, selectedTextColor:UIColor, backgroundColor:UIColor, selectedBackgroundColor:UIColor) -> JTItemView {
        let item = JTItemView()
        item.text = title
        item.textColor = textColor
        item.textAlignment = .Center
        item.font = font
        item.selectedFont = selectedFont
        
        item.itemBackgroundColor = backgroundColor
        item.selectedTextColor = selectedTextColor
        item.selectedBackgroundColor = selectedBackgroundColor
        
        item.state = .Normal
        return item
    }
    
     lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
     lazy var contentView = UIView()
    //2017-08-05
     lazy private var sliderView : JTSliderView = JTSliderView()
     var itemViews = [JTItemView]()
    
     var numberOfSegments : Int {
        return itemViews.count
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        scrollToPointWhenIndexChanged = scrollView.center
    }
    
     func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(sliderView)
        sliderView.color = sliderViewColor
        
        scrollView.frame = bounds
        contentView.frame = scrollView.bounds
        
        scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        addTapGesture()
    }
    
    private func addTapGesture() {
        //let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSegement(tapGesture:)))
        let tap = UITapGestureRecognizer(target:self, action: #selector(JTSegmentControl.didTapSegement(_:)))
        //let tap = UITapGestureRecognizer(self, action: "didTapSegement(tapGesture:))")
        contentView.addGestureRecognizer(tap)
    }
    
    //@objc private
     func didTapSegement(tapGesture:UITapGestureRecognizer) {
        let index = selectedTargetIndex(tapGesture)
        move(to: index)
    }
    
     func move(to index:Int){
        move(to: index, animated: true)
    }
    
     func move(to index:Int, animated:Bool) {
        
        let position = centerX(with: index)
        if animated {
            //UIView.animateWithDuration(<#T##duration: NSTimeInterval##NSTimeInterval#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
            UIView.animateWithDuration(0.2, animations: {
                self.sliderView.center.x = position
                self.sliderView.bounds = CGRect(x: 0.0, y: 0.0, width: self.segmentWidth(index), height: self.sliderView.bounds.height)
            })
        }else{
            self.sliderView.center.x = position
            self.sliderView.bounds = CGRect(x: 0.0, y: 0.0, width: self.segmentWidth(index), height: self.sliderView.bounds.height)
        }
        
        delegate?.didSelected?(self, index: index)
        selectedIndex = index
        
        if autoScrollWhenIndexChange {
            scrollItemToPoint(index, point: scrollToPointWhenIndexChanged)
        }
    }
    
     func currentItemX(index:Int) -> CGFloat {
        if autoAdjustWidth {
            var x:CGFloat = 0.0
            for i in 0..<index {
                x += segmentWidth(i)
            }
            return x
        }
        return segementWidth() * CGFloat(index)
    }
    
     func centerX(with index:Int) -> CGFloat {
        if autoAdjustWidth {
            return currentItemX(index) + segmentWidth(index)*0.5
        }
        return (CGFloat(index) + 0.5)*segementWidth()
    }
    
    private func selectedTargetIndex(gesture: UIGestureRecognizer) -> Int {
        let location = gesture.locationInView(contentView)
        var index = 0
        
        if autoAdjustWidth {
            for (i,itemView) in itemViews.enumerate() {
                if itemView.frame.contains(location) {
                    index = i
                    break
                }
            }
        }else{
            index = Int(location.x / sliderView.bounds.size.width)
        }
        
        if index < 0 {
            index = 0
        }
        if index > numberOfSegments - 1 {
            index = numberOfSegments - 1
        }
        return index
    }
    
    private func scrollItemToCenter(index : Int) {
        scrollItemToPoint(index, point: CGPoint(x: scrollView.bounds.size.width * 0.5, y: 0))
    }
    
    private func scrollItemToPoint(index : Int,point:CGPoint) {
        
        let currentX = currentItemX(index)
        
        let scrollViewWidth = scrollView.bounds.size.width
        
        var scrollX = currentX - point.x + segmentWidth(index) * 0.5
        
        let maxScrollX = scrollView.contentSize.width - scrollViewWidth
        
        if scrollX > maxScrollX {
            scrollX = maxScrollX
        }
        if scrollX < 0.0 {
            scrollX = 0.0
        }
        
        scrollView.setContentOffset(CGPoint(x: scrollX, y: 0.0), animated: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard itemViews.count > 0 else {
            return
        }
        
        var x:CGFloat = 0.0
        let y:CGFloat = 0.0
        var width:CGFloat = segmentWidth(selectedIndex)-10
        let height:CGFloat = bounds.size.height
        
        sliderView.frame = CGRect(x: currentItemX(selectedIndex), y: contentView.bounds.size.height - JTSegmentPattern.sliderHeight, width: width, height: JTSegmentPattern.sliderHeight)
        
        var contentWidth:CGFloat = 0.0
        
        for (index,item) in itemViews.enumerate() {
            x = contentWidth
            width = segmentWidth(index)
            item.frame = CGRect(x: x, y: y, width: width, height: height)
            
            contentWidth += width
        }
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: contentWidth, height: contentView.bounds.height)
        scrollView.contentSize = contentView.bounds.size
    }
}