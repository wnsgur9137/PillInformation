//
//  AlarmDetailViewController.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

import BasePresentation

public final class AlarmDetailViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private let weekSelectionView = WeekSelectionView()
    
    private let saveButton: FilledButton = {
        let button = FilledButton()
        button.title = Constants.AlarmViewController.save
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.AlarmViewController.title
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteSemiBold(28.0)
        return label
    }()
    
    private let titleTextField = UITextField()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    public static func create(with reactor: AlarmDetailReactor) -> AlarmDetailViewController {
        let viewController = AlarmDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alarm"
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
    
    public func bind(reactor: AlarmDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Methods
extension AlarmDetailViewController {
    private func configureAlarm(_ alarm: AlarmModel) {
        datePicker.date = alarm.alarmTime
        titleTextField.text = alarm.title
        configureWeek(alarm.week)
    }
    
    private func configureWeek(_ week: WeekModel) {
        weekSelectionView.sundayButton.isSelected = week.sunday
        weekSelectionView.mondayButton.isSelected = week.monday
        weekSelectionView.tuesdayButton.isSelected = week.tuesday
        weekSelectionView.wednesdayButton.isSelected = week.wednesday
        weekSelectionView.thursdayButton.isSelected = week.thursday
        weekSelectionView.fridayButton.isSelected = week.friday
        weekSelectionView.saturdayButton.isSelected = week.saturday
    }
    
    private func showErrorAlert(_ error: Error?) {
        let title = AlertText(text: Constants.AlarmViewController.saveErrorTitle)
        let message = AlertText(text: Constants.AlarmViewController.tryAgain)
        let confirmButtonInfo = AlertButtonInfo(title: Constants.confirm)
        AlertViewer()
            .showSingleButtonAlert(
                self,
                title: title,
                message: message,
                confirmButtonInfo: confirmButtonInfo)
    }
    
    private func getTitle() -> String? {
        guard let text = titleTextField.text else { return nil }
        return text.count > 0 ? text : nil
    }
}

// MARK: - Binding
extension AlarmDetailViewController {
    private func bindAction(_ reactor: AlarmDetailReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        weekSelectionView.sundayButton.rx.tap
            .map { Reactor.Action.didTapSundayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        weekSelectionView.mondayButton.rx.tap
            .map { Reactor.Action.didTapMondayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        weekSelectionView.tuesdayButton.rx.tap
            .map { Reactor.Action.didTapTuesdayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        weekSelectionView.wednesdayButton.rx.tap
            .map { Reactor.Action.didTapWednesdayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        weekSelectionView.thursdayButton.rx.tap
            .map { Reactor.Action.didTapThurdayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        weekSelectionView.fridayButton.rx.tap
            .map { Reactor.Action.didTapFridayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        weekSelectionView.saturdayButton.rx.tap
            .map { Reactor.Action.didTapSaturdayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map { Reactor.Action.didTapSaveButton((
                time: self.datePicker.date,
                title: self.getTitle(),
                isSelectedDays: (
                    sunday: self.weekSelectionView.sundayButton.isSelected,
                    monday: self.weekSelectionView.mondayButton.isSelected,
                    tuesday: self.weekSelectionView.tuesdayButton.isSelected,
                    wednesday: self.weekSelectionView.wednesdayButton.isSelected,
                    thursday: self.weekSelectionView.thursdayButton.isSelected,
                    friday: self.weekSelectionView.fridayButton.isSelected,
                    saturday: self.weekSelectionView.saturdayButton.isSelected
                )
            ))}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AlarmDetailReactor) {
        reactor.state
            .map { $0.alarmData }
            .subscribe(onNext: { [weak self] alarm in
                guard let alarm = alarm else { return }
                self?.configureAlarm(alarm)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.week }
            .subscribe(onNext: { [weak self] week in
                guard let week = week else { return }
                self?.configureWeek(week)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .skip(1)
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension AlarmDetailViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        
        rootContainerView.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { rootView in
                
                rootView.addItem()
                    .width(100%)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .define { pickerStack in
                        pickerStack.addItem(datePicker)
                            .width(80%)
                            .height(200)
                        
                        pickerStack.addItem(weekSelectionView)
                            .marginTop(8.0)
                            .width(85%)
                            .height(60.0)
                    }
                
                rootView.addItem()
                    .margin(UIEdgeInsets(top: 80.0, left: 0, bottom: 80.0, right: 0))
                    .width(80%)
                    .define { titleStack in
                        titleStack.addItem(titleLabel)
                        
                        titleStack.addItem(titleTextField)
                            .marginTop(8.0)
                            .cornerRadius(12.0)
                            .height(40.0)
                            .backgroundColor(Constants.Color.textFieldBackground)
                    }
                
                rootView.addItem(saveButton)
                    .marginTop(80.0)
                    .width(20%)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
    }
}
