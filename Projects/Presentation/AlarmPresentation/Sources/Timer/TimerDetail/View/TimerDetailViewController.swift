//
//  TimerDetailViewController.swift
//  AlarmPresentation
//
//  Created by JUNHYEOK LEE on 4/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class TimerDetailViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let circularProgressView = CircularProgressView()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    private var timer: Timer?
    private var remainingSeconds: TimeInterval?
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: TimerDetailReactor) -> TimerDetailViewController {
        let viewController = TimerDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    public func bind(reactor: TimerDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Methods
extension TimerDetailViewController {
    private func start(duration: TimeInterval) {
        remainingSeconds = duration
        timer?.invalidate()
        let startDate = Date()
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                let remainingSeconds = duration - round(abs(startDate.timeIntervalSinceNow))
                guard remainingSeconds > 0 else {
                    self?.complte()
                    self?.stop()
                    return
                }
                self?.remainingSeconds = remainingSeconds
            }
        )
        
        circularProgressView.start(duration: duration)
    }
    
    private func stop() {
        timer?.invalidate()
        circularProgressView.stop()
    }
    
    private func complte() {
        let title = AlertText(text: "123")
        let message = AlertText(text: "456")
        let confirmButtonInfo = AlertButtonInfo(title: "확인")
        AlertViewer()
            .showSingleButtonAlert(
                self,
                title: title,
                message: message,
                confirmButtonInfo: confirmButtonInfo
            )
    }
}

// MARK: - Bind
extension TimerDetailViewController {
    private func bindAction(_ reactor: TimerDetailReactor) {
        playButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let remainingTime = circularProgressView.datePicker.countDownDuration
                self.start(duration: remainingTime)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: TimerDetailReactor) {
        
    }
}

// MARK: - Layout
extension TimerDetailViewController {
    private func setupLayout() {
        let deviceSize = CGSize.deviceSize
        view.addSubview(rootContainerView)
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(circularProgressView)
                .alignSelf(.center)
                .marginTop(150.0)
                .width(deviceSize.width / 1.5)
                .height(deviceSize.width / 1.5)
            
            rootView.addItem(playButton)
                .marginTop(50.0)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
