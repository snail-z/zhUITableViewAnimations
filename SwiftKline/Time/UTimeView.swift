//
//  UTimeView.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

// MARK: - UTimeView

open class UTimeView: UTimeBase, UTimeViewInterface, NSGestureRecognizerDelegate {
    
    /// 主图区横轴网格线
    private var majorXaxisLineLayer: UShapeLayer!
    
    /// 副图区横轴网格线
    private var minorXaxisLineLayer: UShapeLayer!
    
    /// 主图区价格参考线
    private var majorDashLayer: UShapeLayer!
    
    /// 日期时间线
    private var dateLineLayer: UShapeLayer!

    /// 分时走势线
    private var trendLineLayer: UShapeLayer!
    
    /// 分时走势线填充
    private var trendFillLayer: UGradientLayer!
    
    /// 走势均线
    private var trendAverageLineLayer: UShapeLayer!
    
    /// 成交量柱状图涨
    private var VOLRiseLayer: UShapeLayer!
    
    /// 成交量柱状图跌
    private var VOLFallLayer: UShapeLayer!
    
    /// 成交量柱状图平
    private var VOLFlatLayer: UShapeLayer!
    
    /// 时间线文本
    private var dateLineTextLayer: UTextLayers!
    
    /// 主图区x轴文本
    private var majorXaxisTextLayer: UTextLayers!
    
    /// 副图区x轴文本
    private var minorXaxisTextLayer: UTextLayers!
    
    /// 主图区数据文本
    private var majorBriefTextLayer: UTextLayers!
    
    /// 副图区数据文本
    private var minorBriefTextLayer: UTextLayers!
    
    /// 鼠标跟踪线
    private var trackingLineLayer: UTrackingLineLayer!
    
    /// 坐标轴提示框
    private var trackingWidgetLayer: UTrackingWidgetLayer!
    
    /// 数据跟踪提示框
    private var trackingTooltipLayer: UTrackingTooltipLayer!
    
    /// 计算结果
    private var calculated: UTimeCalculate!
    
    /// 外观样式
    public var preference: UTimePreferences! = UTimePreferences()
    
    /// 走势列表
    public var dataList: [UTimeDataSource]?
    
    /// 坐标参考系
    public var referenceSystem: UTimeReferenceSystem?
    
    /// 绘制区测量
    public private(set) var meas = UTimeMeasurement()
    
    override func defaultInitialization() {
        majorXaxisLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(majorXaxisLineLayer)
        
        minorXaxisLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(minorXaxisLineLayer)
        
        majorDashLayer = UShapeLayer()
        chartContainerLayer.addSublayer(majorDashLayer)
        
        dateLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(dateLineLayer)
        
        trendLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(trendLineLayer)
        
        trendFillLayer = UGradientLayer()
        chartContainerLayer.insertSublayer(trendFillLayer, at: 0)
        
        trendAverageLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(trendAverageLineLayer)
        
        VOLRiseLayer = UShapeLayer()
        chartContainerLayer.addSublayer(VOLRiseLayer)
        
        VOLFallLayer = UShapeLayer()
        chartContainerLayer.addSublayer(VOLFallLayer)
        
        VOLFlatLayer = UShapeLayer()
        chartContainerLayer.addSublayer(VOLFlatLayer)
        
        dateLineTextLayer = UTextLayers()
        textContainerLayer.addSublayer(dateLineTextLayer)
        
        majorXaxisTextLayer = UTextLayers()
        textContainerLayer.addSublayer(majorXaxisTextLayer)
        
        minorXaxisTextLayer = UTextLayers()
        textContainerLayer.addSublayer(minorXaxisTextLayer)
        
        majorBriefTextLayer = UTextLayers()
        textContainerLayer.addSublayer(majorBriefTextLayer)
        
        minorBriefTextLayer = UTextLayers()
        textContainerLayer.addSublayer(minorBriefTextLayer)
        
        trackingLineLayer = UTrackingLineLayer()
        chartContainerLayer.addSublayer(trackingLineLayer)
        
        trackingWidgetLayer = UTrackingWidgetLayer()
        chartContainerLayer.addSublayer(trackingWidgetLayer)
        
        trackingTooltipLayer = UTrackingTooltipLayer()
        chartContainerLayer.addSublayer(trackingTooltipLayer)
    }

    override func sublayerInitialization() {
        majorXaxisLineLayer.fillColor = NSColor.clear.cgColor
        majorXaxisLineLayer.strokeColor = preference.gridLineColor?.cgColor
        majorXaxisLineLayer.lineWidth = preference.gridLineWidth
        
        minorXaxisLineLayer.fillColor = majorXaxisLineLayer.fillColor
        minorXaxisLineLayer.strokeColor = majorXaxisLineLayer.strokeColor
        minorXaxisLineLayer.lineWidth = majorXaxisLineLayer.lineWidth
        
        majorDashLayer.fillColor = NSColor.clear.cgColor
        majorDashLayer.strokeColor = preference.dashLineColor?.cgColor
        majorDashLayer.lineWidth = preference.dashLineWidth
        majorDashLayer.lineDashPattern = preference.dashLinePattern
        
        dateLineLayer.fillColor = majorXaxisLineLayer.fillColor
        dateLineLayer.strokeColor = majorXaxisLineLayer.strokeColor
        dateLineLayer.lineWidth = majorXaxisLineLayer.lineWidth
        
        trendLineLayer.fillColor = NSColor.clear.cgColor
        trendLineLayer.strokeColor = preference.timeLineColor?.cgColor
        trendLineLayer.lineWidth = preference.timeLineWidth
        
        trendFillLayer.gradientClolors = preference.timeLineFillGradientClolors
        
        trendAverageLineLayer.fillColor = NSColor.clear.cgColor
        trendAverageLineLayer.strokeColor = preference.averageLineColor?.cgColor
        trendAverageLineLayer.lineWidth = preference.averageLineWidth
        
        VOLRiseLayer.fillColor = preference.riseColor?.cgColor
        VOLRiseLayer.strokeColor = preference.riseColor?.cgColor
        VOLRiseLayer.lineWidth = preference.strokeLineWidth
        
        VOLFallLayer.fillColor = preference.fallColor?.cgColor
        VOLFallLayer.strokeColor = preference.fallColor?.cgColor
        VOLFallLayer.lineWidth = preference.strokeLineWidth
        
        VOLFlatLayer.fillColor = preference.flatColor?.cgColor
        VOLFlatLayer.strokeColor = preference.flatColor?.cgColor
        VOLFlatLayer.lineWidth = preference.strokeLineWidth
        
        trackingLineLayer.lineColor = .orange
        trackingLineLayer.lineWidth = 5
    }
    
    override func gestureInitialization() {
//        NSGestureRecognizer
        
        let singleTap = NSClickGestureRecognizer.pk.addGestureHandler { (g) in
            print("===g is: \(g)")
        }
        self.addGestureRecognizer(singleTap)
        
        let pan = NSPanGestureRecognizer.init(target: self, action: #selector(doublesdkja(tap:)))
//        doubleTap.delaysPrimaryMouseButtonEvents = true
//        doubleTap.delaysOtherMouseButtonEvents = true
//        doubleTap.delaysSecondaryMouseButtonEvents = true
        self.addGestureRecognizer(pan)
    }
    
    open override func mouseMoved(with event: NSEvent) {
        
        
//        return
        let p = event.locationInWindow
        let vapp = convert(p, from: window!.contentView)
        
        var lp: CGPoint = .zero
        lp.x = vapp.x - meas.unionChartFrame.minX
        lp.y = vapp.y - meas.unionChartFrame.minY
        let index = xaxisToIndex(lp.x, shapeWidth: preference.shapeWidth, shapeSpacing: preference.shapeSpacing, count: dataList!.count)
        
        let ppxxx = meas.midxaixs(by: index)
        let pppppp = CGPoint(x: ppxxx, y: vapp.y)
        
        let rectss = [meas.majorChartFrame, meas.minorBriefFrames.first!]
        trackingLineLayer.updateTracking(location: pppppp, in: rectss)
        
//        trackingTooltipLayer.frame = meas.unionChartFrame
//        trackingTooltipLayer.frame = bounds
//        trackingTooltipLayer.setText(text: "sdf", for: .left)
        let item = dataList![index]
        let timeText = item._date.pk.toString(format: "MM/dd HH:mm")
        
        trackingWidgetLayer.boundsRect = meas.unionChartFrame
        trackingWidgetLayer.updateTracking(location: vapp, widgets: [.left("90.8 "), .right("啊哈哈是"), .bottom(timeText), .top("swift top数据的")])
        
        trackingTooltipLayer.isDisableActions = true
//        trackingTooltipLayer.frame = CGRect(x: 150, y: 10, width: 200, height: 180)
//        trackingTooltipLayer.frame = CGRect(x: 10, y: 10, width: 100, height: 50)
        let orColor = NSColor.orange.withAlphaComponent(0.5)
        trackingTooltipLayer.backgroundColor = orColor.cgColor
        
        
        
        let rp = NSMutableParagraphStyle()
            rp.pk.alignment(.right)
            
            let leftp = NSMutableParagraphStyle()
            leftp.pk.alignment(.left)
            
            let attri1 = NSMutableAttributedString.init(string: "时间")
            attri1.pk.foregroundColor(.white).font(.systemFont(ofSize: 12)) .paragraphStyle(leftp)
        
        
            let attri2 = NSMutableAttributedString.init(string: timeText)
            attri2.pk.foregroundColor(.black).font(.systemFont(ofSize: 12)) .paragraphStyle(rp)
            
            let attrib1 = NSMutableAttributedString.init(string: "价格")
            attrib1.pk.foregroundColor(.white).font(.systemFont(ofSize: 12)).paragraphStyle(leftp)
            
            let attrib2 = NSMutableAttributedString.init(string: "\(item._latestPrice)")
            attrib2.pk.foregroundColor(.red).font(.systemFont(ofSize: 12)).paragraphStyle(rp)
        
        let Tattrib1 = NSMutableAttributedString.init(string: "涨跌额")
        Tattrib1.pk.foregroundColor(.white).font(.systemFont(ofSize: 12)).paragraphStyle(leftp)
        
        let Tattrib2 = NSMutableAttributedString.init(string: "+0.40%")
        Tattrib2.pk.foregroundColor(.white).font(.systemFont(ofSize: 12)).paragraphStyle(rp)
        
        let volTrib1 = NSMutableAttributedString.init(string: "成交量")
        volTrib1.pk.foregroundColor(.white).font(.systemFont(ofSize: 12)).paragraphStyle(leftp)
        
        let voldm = item._volume.pk.stringValueShortened() + "手"
        let volTrib2 = NSMutableAttributedString.init(string: voldm)
        volTrib2.pk.foregroundColor(.white).font(.systemFont(ofSize: 12)).paragraphStyle(rp)
        
        if meas.minorChartFrame.contains(vapp) {
            trackingTooltipLayer.items = nil
        } else {
            trackingTooltipLayer.items = [.make(left: attri1, right: attri2),
                                          .make(left: attrib1, right: attrib2),
                                          .make(left: attrib1, right: attrib2),
                                          .make(left: Tattrib1, right: Tattrib2),
                                          .make(left: volTrib1, right: volTrib2)]
            trackingTooltipLayer.itemCount = 5
            
            trackingTooltipLayer.sizeToFit(width: 150)
        }
        let width: CGFloat = 150
        let height = trackingTooltipLayer.frame.height

        let refMinX = meas.unionChartFrame.minX + width
        let refMaxX = meas.unionChartFrame.maxX - width
        
        if vapp.x > refMaxX {
            let poitns = CGPoint(x: meas.unionChartFrame.minX + width / 2, y: meas.unionChartFrame.minY + height/2)
            trackingTooltipLayer.position = poitns
        } else if vapp.x < refMinX  {
            let poitns = CGPoint(x: meas.unionChartFrame.maxX - width / 2, y: meas.unionChartFrame.minY + height/2)
            trackingTooltipLayer.position = poitns
        } else {}
    }
    
    open override func mouseDragged(with event: NSEvent) {
        print("mouseDragged")
    }
    
    public func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        return false
    }
    
    open override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    @objc func single(tap: NSClickGestureRecognizer) {
        print("单击哈哈哈")
    }
    
    @objc func doublesdkja(tap: NSClickGestureRecognizer) {
        print("双击了哈哈哈")
    }
    

    public func drawChart() {
        guard let list = dataList, !list.isEmpty else {
            return
        }
        
        calculated = UTimeCalculate(target: self)
        calculated.recalculate()
        
        updateChartLayout()
        
//        clearChart()
        
        updateMajorXlines()
        updateMajorTrendChart()
        
        updateMinorCharts()
        
        
        
        let tracking = NSTrackingArea.init(rect: bounds, options: [.mouseMoved, .activeAlways, .inVisibleRect], owner: self, userInfo: nil)
        
        self.addTrackingArea(tracking)
    }

    open override func updateTrackingAreas() {
        print("updateTrackingAreas--")
    }
    
    public func clearChart() {
        backgroundColor = .lightGray
        
        majorXaxisLineLayer.path = NSBezierPath(rect: meas.majorChartFrame).cgPath
        majorXaxisLineLayer.fillColor = NSColor.orange.cgColor
        
        minorXaxisLineLayer.path = NSBezierPath(rect: meas.minorChartFrame).cgPath
        minorXaxisLineLayer.fillColor = NSColor.orange.cgColor
                
        dateLineLayer.path = NSBezierPath(rect: meas.dateBarFrame).cgPath
        dateLineLayer.fillColor = NSColor.blue.cgColor
    }
    
    open override func layout() {
        super.layout()
//        trackingTooltipLayer.frame = meas.unionChartFrame
//        majorBriefTextLayer.frame = measurement.majorBriefFrame
//        majorBriefTextLayer.backgroundColor = NSColor.yellow.cgColor
//
//        minorBriefTextLayer.frame = measurement.minorBriefFrame
//        minorBriefTextLayer.backgroundColor = NSColor.green.cgColor
    }
    
    private func updateMeasurement() {
        updateChartLayout()
    }
    
    private func updateChartLayout() {
        var datesBarFrame = CGRect.zero
        var majorChartFrame = CGRect.zero, majorBriefFrame = CGRect.zero
        var minorChartFrame = CGRect.zero, minorBriefFrame = CGRect.zero
        
        // .integral - 表示原点的值向下取整，表示大小的值向上取整，可以保证绘制范围平整地对齐到像素边界
        let rect = bounds.inset(by: preference.contentEdgeInsets).integral
        let majorChartHeight = fmin(rect.height * preference.majorChartRatio, rect.height)
        
        
        // 计算五个区域 (区分日期栏不同位置)
        switch preference.dateBarPosition {
        case .top:
            datesBarFrame.origin = rect.origin
            datesBarFrame.size = CGSize(width: rect.width, height: preference.dateBarHeight)
            
            majorBriefFrame.origin = CGPoint(x: rect.minX, y: datesBarFrame.maxY)
            majorBriefFrame.size = CGSize(width: rect.width, height: preference.majorBriefHeight)
            
            majorChartFrame.origin = CGPoint(x: rect.minX, y: majorBriefFrame.maxY)
            majorChartFrame.size = CGSize(width: rect.width, height: majorChartHeight)
            
            minorBriefFrame.origin = CGPoint(x: rect.minX, y: majorChartFrame.maxY)
            minorBriefFrame.size = CGSize(width: rect.width, height: preference.minorBriefHeight)
            
            minorChartFrame.origin = CGPoint(x: rect.minX, y: minorBriefFrame.maxY)
            minorChartFrame.size = CGSize(width: rect.width, height: rect.maxY - minorBriefFrame.maxY)
        case .middle:
            majorBriefFrame.origin = rect.origin
            majorBriefFrame.size = CGSize(width: rect.width, height: preference.majorBriefHeight)
            
            majorChartFrame.origin = CGPoint(x: rect.minX, y: majorBriefFrame.maxY)
            majorChartFrame.size = CGSize(width: rect.width, height: majorChartHeight)
            
            datesBarFrame.origin = CGPoint(x: rect.minX, y: majorChartFrame.maxY)
            datesBarFrame.size = CGSize(width: rect.width, height: preference.dateBarHeight)
            
            minorBriefFrame.origin = CGPoint(x: rect.minX, y: datesBarFrame.maxY)
            minorBriefFrame.size = CGSize(width: rect.width, height: preference.minorBriefHeight)
            
            minorChartFrame.origin = CGPoint(x: rect.minX, y: minorBriefFrame.maxY)
            minorChartFrame.size = CGSize(width: rect.width, height: rect.maxY - minorBriefFrame.maxY)
        case .bottom:
            majorBriefFrame.origin = rect.origin
            majorBriefFrame.size = CGSize(width: rect.width, height: preference.majorBriefHeight)
            
            majorChartFrame.origin = CGPoint(x: rect.minX, y: majorBriefFrame.maxY)
            majorChartFrame.size = CGSize(width: rect.width, height: majorChartHeight)
            
            minorBriefFrame.origin = CGPoint(x: rect.minX, y: majorChartFrame.maxY)
            minorBriefFrame.size = CGSize(width: rect.width, height: preference.minorBriefHeight)
            
            minorChartFrame.origin = CGPoint(x: rect.minX, y: minorBriefFrame.maxY)
            let minorChartHeight = rect.maxY - minorBriefFrame.maxY - preference.dateBarHeight
            minorChartFrame.size = CGSize(width: rect.width, height: minorChartHeight)
            
            datesBarFrame.origin = CGPoint(x: rect.minX, y: minorChartFrame.maxY)
            datesBarFrame.size = CGSize(width: rect.width, height: preference.dateBarHeight)
        }

        /// 计算条形图宽度或间距
        if preference.shapeSpacing > 0 {
            var allSpacing = CGFloat(preference.maximumNumberOfEntries - 1) * preference.shapeSpacing
            allSpacing = fmin(allSpacing, majorChartFrame.width)
            preference.shapeWidth = (majorChartFrame.width - allSpacing) / CGFloat(preference.maximumNumberOfEntries)
        } else {
            var allWidth = CGFloat(preference.maximumNumberOfEntries) * preference.shapeWidth
            allWidth = fmin(allWidth, majorChartFrame.width)
            preference.shapeSpacing = (majorChartFrame.width - allWidth) / CGFloat(preference.maximumNumberOfEntries - 1)
        }
        
        meas.shapeWidth = preference.shapeWidth
        meas.shapeSpacing = preference.shapeSpacing
        meas.dateBarFrame = datesBarFrame
        meas.majorBriefFrame = majorBriefFrame
        meas.majorChartFrame = majorChartFrame
        meas.minorBriefFrames = [minorBriefFrame]
        meas.minorChartFrames = [minorChartFrame]
    }
    
    
    /// 绘制主图区横轴线
    private func updateMajorXlines() {
        let leftValues = calculated.pricePeakValue
            .fragments(by: preference.majorNumberOfLines, { (_, doubleValue) -> String in
            return String(format: "%.*lf", preference.decimalKeepPlace, doubleValue)
        })
        
        let rightValues = calculated.changeRatePeakValue
            .fragments(by: preference.majorNumberOfLines) { (_, doubleValue) -> String in
            return String(format: "%.*lf", 6, doubleValue)
        }
        
        // 横轴线间距
        let spacing = meas.majorChartFrame.height / CGFloat(leftValues.count - 1)
        let originY = meas.majorChartFrame.minY + preference.gridLineWidth/2
        
        // 计算参考线位置
        let distance = calculated.changeRatePeakValue.distance
        guard distance.isValid else { return }
        let percentage = calculated.changeRatePeakValue.max / distance
        let dashY = originY + meas.majorChartFrame.height * percentage.cgFloat
        
        // 浮动颜色
        func floatedColor(by current: CGFloat) -> NSColor? {
            if current < dashY {
                return preference.riseColor
            } else if current > dashY {
                return preference.fallColor
            } else {
                return preference.plainTextColor
            }
        }
        
        // 绘制参考线
        let dash = CGMutablePath()
        let dasp = CGPoint(x: meas.majorChartFrame.minX, y: dashY)
        dash.addLine(horizontal: dasp, length: meas.majorChartFrame.width)
        majorDashLayer.path = dash
        
        // 绘制横轴线和文本
        let path = CGMutablePath()
        var renders = [UTextRender]()
        for (index, text) in leftValues.enumerated() {
            let start = CGPoint(x: meas.majorChartFrame.minX, y: originY + spacing * CGFloat(index))
            path.addLine(horizontal: start, length: meas.majorChartFrame.width)
            
            var leftRender = UTextRender()
            leftRender.text = text
            leftRender.font = NSFont.systemFont(ofSize: 22)
            leftRender.color = floatedColor(by: start.y)
//            leftRender.backgroundColor = .orange
            leftRender.position = start
            leftRender.positionOffset = CGPoint(x: 0, y: index > 0 ? 1 : 0)
            renders.append(leftRender)
            
            var rightRender = UTextRender()
            let s = rightValues[index]
            let doubleValue = Double(s)
            rightRender.text = "\(String(describing: doubleValue))"
            rightRender.font = NSFont.systemFont(ofSize: 22)
            rightRender.color = floatedColor(by: start.y)
//            rightRender.backgroundColor = .orange
            rightRender.position = CGPoint(x: start.x + meas.majorChartFrame.width, y: start.y)
            rightRender.positionOffset = CGPoint(x: 1, y: index > 0 ? 1 : 0)
            renders.append(rightRender)
        }
        
        majorXaxisLineLayer.path = path
        majorXaxisTextLayer.renders = renders
    }
    
    func updateMajorTrendChart() {
        let yaxis = yaxisMake(calculated.pricePeakValue, meas.majorChartFrame)
        let firstObj = dataList!.first!
        var priceY = yaxis(calculated.pricePeakValue.limited(calculated.referenceValue))
        let averageY = yaxis(calculated.pricePeakValue.limited(firstObj._averagePrice))

        let fromPath = CGMutablePath()
        let path1 = CGMutablePath()
        let path2 = CGMutablePath()
        /// 路径动画：fromPath必须和toPath绘线点数量一致，动画才能平滑显示
        fromPath.move(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
        path1.move(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
        path2.move(to: CGPoint(x: meas.majorChartFrame.minX, y: averageY))
    
        for (index, element) in dataList!.enumerated() {
            let centerX = meas.midxaixs(by: index)
            let latestValue = calculated.pricePeakValue.limited(element._latestPrice)
            let averageValue = calculated.pricePeakValue.limited(element._averagePrice)
            let latestY = yaxis(latestValue)
            if index < 2 {
                priceY = latestY
            }
            let averageY = yaxis(averageValue)
            path1.addLine(to: CGPoint(x: centerX, y: latestY))
            fromPath.addLine(to: CGPoint(x: centerX, y: meas.majorChartFrame.maxY))
            path2.addLine(to: CGPoint(x: centerX, y: averageY))
        }
        
        trendLineLayer.path = path1
        trendAverageLineLayer.path = path2
        
        let endX = meas.midxaixs(by: dataList!.count - 1)
        /// 绘制走势渐变填充
        let fillPath = CGMutablePath.init()
        fillPath.addPath(path1)
        fillPath.addLine(to: CGPoint(x: endX, y: meas.majorChartFrame.maxY))
        fillPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
        fillPath.closeSubpath()
        
        /// 绘制走势渐变填充
        let fromPath22 = CGMutablePath.init()
        fromPath22.addPath(fromPath)
        fromPath22.addLine(to: CGPoint(x: endX, y: meas.majorChartFrame.maxY))
        fromPath22.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
        fromPath22.closeSubpath()
        
//        let testL = CAShapeLayer()
//        testL.strokeColor = NSColor.blue.cgColor
//        testL.fillColor = NSColor.clear.cgColor
//        testL.lineWidth = 5
//        testL.path = fillPath
//        chartContainerLayer.addSublayer(testL)
        
        
        
//        return
        trendFillLayer.isDisablePathActions = false
        let colors = NSColor.init(red: 62/255.0, green: 141/255.0, blue: 247/255.0, alpha: 1)
        trendFillLayer.gradientClolors = [colors.withAlphaComponent(0.3), colors.withAlphaComponent(0.1)]
        trendFillLayer.gradientDirection = .topToBottom
        
//        UToolTipView
//        UCrosslineView
        
//        let fromPath = CGMutablePath.init()
//        fromPath.move(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
//        fromPath.closeSubpath()
//        fillPath.addLine(to: CGPoint(x: 15, y: priceY))
//        fromPath.addLine(to: CGPoint(x: 50, y: meas.majorChartFrame.maxY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
//        fromPath.closeSubpath()
        
//        trendFillLayer._oldPath = fromPath
//        trendFillLayer.gradientPath = fromPath22
        
        let toPath = CGMutablePath.init()
        toPath.move(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
        toPath.addLine(to: CGPoint(x: 100, y: priceY+20))
        toPath.addLine(to: CGPoint(x: 200, y: priceY-50))
        toPath.addLine(to: CGPoint(x: 200, y: meas.majorChartFrame.maxY))
        toPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
        toPath.closeSubpath()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.trendFillLayer.gradientPath = fillPath
//        })
    }
    
    func updateMinorCharts() {
        let yaxis = yaxisMake(calculated.volumePeakValue, meas.minorChartFrame)
        let referenceValue = calculated.referenceValue
        
        let risePath = CGMutablePath()
        let fallPath = CGMutablePath()
        let flatPath = CGMutablePath()
        
        for (index, element) in dataList!.enumerated() {
            let x = meas.minxaixs(by: index)
            let y = yaxis(element._volume)
            let r = CGRect(x: x, y: y,
                           width: meas.shapeWidth,
                           height: meas.minorChartFrame.maxY - y)
            
            if element._latestPrice > referenceValue {
                risePath.addRect(r)
            } else if element._averagePrice < referenceValue {
                fallPath.addRect(r)
            } else {
                flatPath.addRect(r)
            }
        }
        
        VOLRiseLayer.path = risePath
        VOLFallLayer.path = fallPath
        VOLFlatLayer.path = flatPath
        
        drawTimelines()
    }
    
    func drawTimelines() {
        
        if
            let allValues = preference.timelineAllMinutes,
            let visibleValues = preference.timelineVisibleMinutes {
            
            guard visibleValues.count != preference.timelineVisibleTexts.count else {
                return
            }
        
            print("allValues is: \(allValues)")
        } else {
            
        }
        
        let alist1 = [570, 630, 650, 660, 900]
        
        var mudIndexset = IndexSet.init()
        for (index, element) in dataList!.enumerated() {
            if alist1.contains(element._date.minuteUnit()) {
                mudIndexset.insert(index)
            }
        }
        
        let path = CGMutablePath()
        for idx in mudIndexset {
            let x = meas.midxaixs(by: idx)
            path.move(to: CGPoint(x: x, y: meas.majorChartFrame.minY))
            path.addLine(to: CGPoint(x: x, y: meas.majorChartFrame.maxY))
            path.move(to: CGPoint(x: x, y: meas.minorChartFrame.minY))
            path.addLine(to: CGPoint(x: x, y: meas.minorChartFrame.maxY))
        }
        
        dateLineLayer.path = path
        
//        let ress = dataList!.filter({ (elem) -> Bool in
//            return alist1.contains(elem._date.minuteUnit())
//        })
//
//        for element in ress {
//
//            dataList!.firstIndex { (ss) -> Bool in
//                element._date.toNumberOfMinutes() == ss._date.toNumberOfMinutes()
//            }
//        }
        
        
        
        for ele in dataList! {
            
        }
        dataList!.forEach { (ds) in
            ds._date.pk.dateComponents().hour
        }
        
        
        let array: [Any] = ["d", "a", "u", NSNull(), "K"]

        for index in 0..<array.count {
            let value = array[index]
            print("value is: \(value)")
            
            if value is String {
                print("string value is: \(value)")
            }
        }
    }
}


// MARK: - UTimeBase

open class UTimeBase: UBaseView {
    
    private(set) var chartContainerLayer: UBaseLayer!
    private(set) var textContainerLayer: UBaseLayer!
    private(set) var containerView: UBaseView!
    
    override func initialization() {
        super.initialization()
        
        containerView = UBaseView()
        addSubview(containerView)
        
        chartContainerLayer = UBaseLayer()
        containerView.layer?.addSublayer(chartContainerLayer)
        
        textContainerLayer = UBaseLayer()
        containerView.layer?.addSublayer(textContainerLayer)
        
        defaultInitialization()
        sublayerInitialization()
        gestureInitialization()
    }
    
    open override func layout() {
        super.layout()
        containerView.frame = bounds
        chartContainerLayer.sublayers?.forEach({ $0.frame = bounds })
        textContainerLayer.sublayers?.forEach({ $0.frame = bounds })
    }

    fileprivate func defaultInitialization() {}

    fileprivate func sublayerInitialization() {}

    fileprivate func gestureInitialization() {}
}












//open class UTimeLayer: UBaseLayer {
//
//    /// 主图区横轴网格线
//    private var majorXaxisLineLayer: CAShapeLayer!
//    /// 主图区x轴文本
//    private var majorXaxisTextLayer: UTextLayer!
//
//    override func initialization() {
//        super.initialization()
//
//        majorXaxisLineLayer = CAShapeLayer.init()
//        majorXaxisLineLayer.fillColor = NSUIColor.cyan.cgColor
//        majorXaxisLineLayer.strokeColor = NSUIColor.red.cgColor
//        majorXaxisLineLayer.lineWidth = 2
//        addSublayer(majorXaxisLineLayer)
//
//
//        let path = CGMutablePath.init()
//        path.move(to: CGPoint(x: 10, y: 100))
//        path.addLine(to: CGPoint(x: 100, y: 10))
//        path.addLine(to: CGPoint(x: 200, y: 150))
//        path.closeSubpath()
//
//        majorXaxisLineLayer.path = path
//
//        majorXaxisTextLayer = UTextLayer()
//        addSublayer(majorXaxisTextLayer)
//    }
//
//
//    open override func layoutSublayers() {
//        super.layoutSublayers()
//        majorXaxisTextLayer.frame = bounds
//    }
//
//    public func drawChart() {
//
//        let leftValues = ["256.9", "25.990万元", "AOP指标"]
//        var renders = [UTextRender]()
//        for (index, text) in leftValues.enumerated() {
//            let start = CGPoint(x: 10, y: 20 + 100 * CGFloat(index))
//
//            var leftRender = UTextRender()
//            leftRender.text = text
//            leftRender.font = NSFont.systemFont(ofSize: 22)
//            leftRender.color = .yellow
//            leftRender.backgroundColor = .orange
//            leftRender.position = start
//            leftRender.positionOffset = CGPoint(x: 0, y: index > 0 ? 1 : 0)
//            renders.append(leftRender)
//        }
//
//        majorXaxisTextLayer.renders = renders
//    }
//}
//
