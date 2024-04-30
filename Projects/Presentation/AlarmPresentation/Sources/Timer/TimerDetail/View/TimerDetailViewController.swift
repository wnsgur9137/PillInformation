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
    
    private let operationButton: FilledButton = {
        let button = FilledButton(style: .large)
        button.title = "start"
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.TimerDetailViewController.title
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(28.0)
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        return textField
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
        title = "Timer"
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
    private func start(timerModel: TimerModel) {
        let duration = timerModel.duration
        operationButton.title = "Stop"
        remainingSeconds = duration
        timer?.invalidate()
        let startDate = timerModel.startedDate ?? Date()
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                let remainingSeconds = duration - round(abs(startDate.timeIntervalSinceNow))
                UIView.animate(withDuration: 0.5) {
                    self?.circularProgressView.datePicker.countDownDuration = remainingSeconds + 60
                }
                guard remainingSeconds > 0 else {
                    DispatchQueue.main.async {
                        self?.complte()
                        self?.stop()
                    }
                    return
                }
                self?.remainingSeconds = remainingSeconds
            }
        )
        circularProgressView.start(duration: duration, fromValue: duration-round(abs(startDate.timeIntervalSinceNow)))
    }
    
    private func stop() {
        operationButton.title = "Start"
        timer?.invalidate()
        circularProgressView.stop()
    }
    
    private func complte() {
        // TODO: - Make Push notification
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
    
    private func showErrorAlert(_ error: Error) {
        print("SAVE ERROR")
    }
}

// MARK: - Bind
extension TimerDetailViewController {
    private func bindAction(_ reactor: TimerDetailReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear
            .map { Reactor.Action.viewWillDisappear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        operationButton.rx.tap
            .map {
                Reactor.Action.didTapOperationButton((
                    title: self.titleTextField.text,
                    duration: self.circularProgressView.datePicker.countDownDuration
                ))
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: TimerDetailReactor) {
        reactor.pulse(\.$timerData)
            .bind { [weak self] timerModel in
                guard let timerModel = timerModel else { return }
                timerModel.isStarted ? self?.start(timerModel: timerModel) : self?.stop()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isStarted)
            .bind { [weak self] isStarted in
                guard isStarted else { return }
                self?.stop()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isError)
            .bind { [weak self] error in
                guard let error = error else { return }
                self?.showErrorAlert(error)
            }
            .disposed(by: disposeBag)
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
                .marginTop(50.0)
                .width(deviceSize.width / 1.5)
                .height(deviceSize.width / 1.5)
            
            rootView.addItem()
                .margin(60.0)
                .define { titleStack in
                    titleStack.addItem(titleLabel)
                    titleStack.addItem(titleTextField)
                        .marginTop(8.0)
                        .cornerRadius(12.0)
                        .height(40.0)
                        .backgroundColor(Constants.Color.textFieldBackground)
                }
            
            rootView.addItem(operationButton)
                .alignSelf(.center)
                .margin(24.0, 12.0, 24.0, 12.0)
                .width(25%)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin
            .top(view.safeAreaInsets.top)
            .left().right().bottom()
        rootContainerView.flex.layout()
    }
}
