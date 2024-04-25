//
//  CircularProgressView.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

final class CircularProgressView: UIView {
    
    private let rootContainerView = UIView()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let animationName = "progressAnimation"
    
    private lazy var circularPath: UIBezierPath = {
        return UIBezierPath(
            arcCenter: CGPoint(x: self.frame.size.width / 2.0,
                               y: self.frame.size.height / 2.0),
            radius: self.frame.size.width / 2.0,
            startAngle: CGFloat(-Double.pi / 2),
            endAngle: CGFloat(3 * Double.pi / 2),
            clockwise: true)
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UIBezierPath는 런타임마다 바뀌는 Frame 값을 참조하여 원의 윤곽 레이아웃을 알아야 한다.
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        backgroundLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
        setupBackgroundLayer()
        setupProgressLayer()
    }
    
    private func setupBackgroundLayer() {
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.fillColor = Constants.Color.clear.cgColor
        backgroundLayer.lineCap = .round
        backgroundLayer.lineWidth = 15.0
        backgroundLayer.strokeEnd = 1.0
        backgroundLayer.strokeColor = Constants.Color.systemLightGray.cgColor
        layer.addSublayer(backgroundLayer)
    }
    
    private func setupProgressLayer() {
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = Constants.Color.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 15.0
        progressLayer.strokeEnd = 1.0
        progressLayer.strokeColor = Constants.Color.systemBlue.cgColor
        layer.addSublayer(progressLayer)
    }
    
    func start(duration: TimeInterval) {
        datePicker.isEnabled = false
        progressLayer.removeAnimation(forKey: animationName)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: animationName)
    }
    
    func stop() {
        datePicker.isEnabled = true
        progressLayer.removeAnimation(forKey: animationName)
    }
}

// MARK: - Layout
extension CircularProgressView {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(datePicker)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
