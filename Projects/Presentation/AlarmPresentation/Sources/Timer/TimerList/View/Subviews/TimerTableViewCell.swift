//
//  TimerTableViewCell.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

final class TimerTableViewCell: UITableViewCell {
    
    private let rootContainerView = UIView()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(32.0)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OOOOOO"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(18.0)
        return label
    }()
    
    private let setTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "15:00"
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(16.0)
        return label
    }()
    
    private var timer: Timer?
    private var remainingSeconds: TimeInterval?
    private(set) var disposeBag = DisposeBag()
    let completedRelay: PublishRelay<TimerModel> = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.bounds.size.width = size.width
        self.contentView.flex.layout(mode: .adjustHeight)
        return self.contentView.frame.size
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func startTimer(timerModel: TimerModel) {
        let duration = timerModel.duration
        remainingSeconds = duration
        timer?.invalidate()
        let startDate = timerModel.startedDate ?? Date()
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                let remainingSeconds = duration - round(abs(startDate.timeIntervalSinceNow))
                guard remainingSeconds > 0 else {
                    self?.remainingTimeLabel.text = Double(0).toStringFormat()
                    self?.stop()
                    return
                }
                UIView.animate(withDuration: 0.1) {
                    self?.remainingTimeLabel.text = remainingSeconds.toStringFormat()
                }
                guard remainingSeconds > 0 else {
                    DispatchQueue.main.async {
                        self?.stop()
                        let timerModel = TimerModel(id: timerModel.id,
                                                    title: timerModel.title,
                                                    duration: timerModel.duration,
                                                    startedDate: startDate,
                                                    isStarted: false)
                        self?.completedRelay.accept(timerModel)
                    }
                    return
                }
                self?.remainingSeconds = remainingSeconds
            })
    }
    
    private func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func configure(_ timerModel: TimerModel) {
        self.titleLabel.text = timerModel.title
        self.remainingTimeLabel.text = timerModel.duration.toStringFormat()
        self.setTimeLabel.text = timerModel.duration.toStringFormat()
        
        guard let startedDate = timerModel.startedDate else { return }
        let currentDate = Date().timeIntervalSince(startedDate)
        let remainingTime = timerModel.duration - currentDate
        
        guard remainingTime > 0 else {
            remainingTimeLabel.text = Double(0).toStringFormat()
            stop()
            return
        }
        self.remainingTimeLabel.text = "\(remainingTime.toStringFormat())"
        
        guard timerModel.isStarted else {
            stop()
            return
        }
        startTimer(timerModel: timerModel)
    }
}

// MARK: - Layout
extension TimerTableViewCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        
        rootContainerView.flex
            .direction(.row)
            .alignItems(.center)
            .define { rootView in
                rootView.addItem()
                    .width(100%)
                    .marginLeft(24.0)
                    .define { timeStack in
                        timeStack.addItem(remainingTimeLabel)
                        timeStack.addItem(titleLabel)
                        timeStack.addItem(setTimeLabel)
                }
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}
