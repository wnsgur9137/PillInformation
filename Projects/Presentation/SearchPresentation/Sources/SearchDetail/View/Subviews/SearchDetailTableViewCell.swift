//
//  SearchDetailTableViewCell.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/13/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

import BasePresentation

enum PillInfoModelName: String {
    case medicineSeq
    case medicineName
    case entpSeq
    case entpName
    case chart
    case medicineImage
    case printFront
    case printBack
    case medicineShape
    case colorClass1
    case colorClass2
    case lineFront
    case lineBack
    case lengLong
    case lengShort
    case thick
    case imgRegistTs
    case classNo
    case className
    case etcOtcName
    case medicinePermitDate
    case formCodeName
    case markCodeFrontAnal
    case markCodeBackAnal
    case markCodeFrontImg
    case markCodeBackImg
    case changeDate
    case markCodeFront
    case markCodeBack
    case medicineEngName
    case ediCode
}

final class SearchDetailTableViewCell: UITableViewCell {
    
    private let rootContainerView = UIView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteMedium(18.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Color.systemLabel
        label.font = Constants.Font.suiteRegular(18.0)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Constants.Color.background
        selectionStyle = .none
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func localizeName(name: String) -> String? {
        guard let test = PillInfoModelName(rawValue: name) else { return nil }
        switch test {
        case .medicineSeq: return Constants.SearchDetail.medicineSeq
        case .medicineName: return Constants.SearchDetail.medicineName
        case .entpSeq: return Constants.SearchDetail.entpSeq
        case .entpName: return Constants.SearchDetail.entpName
        case .chart: return Constants.SearchDetail.chart
        case .medicineImage: return Constants.SearchDetail.medicineImage
        case .printFront: return Constants.SearchDetail.printFront
        case .printBack: return Constants.SearchDetail.printBack
        case .medicineShape: return Constants.SearchDetail.medicineShape
        case .colorClass1: return Constants.SearchDetail.colorClass1
        case .colorClass2: return Constants.SearchDetail.colorClass2
        case .lineFront: return Constants.SearchDetail.lineFront
        case .lineBack: return Constants.SearchDetail.lineBack
        case .lengLong: return Constants.SearchDetail.lengLong
        case .lengShort: return Constants.SearchDetail.lengShort
        case .thick: return Constants.SearchDetail.thick
        case .imgRegistTs: return Constants.SearchDetail.imgRegistTs
        case .classNo: return Constants.SearchDetail.classNo
        case .className: return Constants.SearchDetail.className
        case .etcOtcName: return Constants.SearchDetail.etcOtcName
        case .medicinePermitDate: return Constants.SearchDetail.medicinePermitDate
        case .formCodeName: return Constants.SearchDetail.formCodeName
        case .markCodeFrontAnal: return Constants.SearchDetail.markCodeFrontAnal
        case .markCodeBackAnal: return Constants.SearchDetail.markCodeBackAnal
        case .markCodeFrontImg: return Constants.SearchDetail.markCodeFrontImg
        case .markCodeBackImg: return Constants.SearchDetail.markCodeBackImg
        case .changeDate: return Constants.SearchDetail.changeDate
        case .markCodeFront: return Constants.SearchDetail.markCodeFront
        case .markCodeBack: return Constants.SearchDetail.markCodeBack
        case .medicineEngName: return Constants.SearchDetail.medicineEngName
        case .ediCode: return Constants.SearchDetail.ediCode
        }
    }
    
    func configure(name: String, value: String?) {
        nameLabel.text = localizeName(name: name)
        valueLabel.text = value
    }
}

// MARK: - Layout
extension SearchDetailTableViewCell {
    private func addSubviews() {
        addSubview(nameLabel)
        addSubview(valueLabel)
    }
    
    private func setupLayoutConstraints() {
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 16.0).isActive = true
        valueLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
