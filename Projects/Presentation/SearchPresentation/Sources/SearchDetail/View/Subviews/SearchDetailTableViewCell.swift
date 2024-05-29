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
    case medicineSeq, medicineName, entpSeq, entpName, chart, medicineImage, printFront, printBack, medicineShape, colorClass1, colorClass2, lineFront, lineBack, lengLong, lengShort, thick, imgRegistTs, classNo, className, etcOtcName, medicinePermitDate, formCodeName, markCodeFrontAnal, markCodeBackAnal, markCodeFrontImg, markCodeBackImg, changeDate, markCodeFront, markCodeBack, medicineEngName, ediCode
}

enum PillDescriptionName: String {
    case medicineSeq, medicineName, entpName, efcyQestim, useMethodQesitm, atpnWarnQesitm, intrcQesitm, seQesitm, depositMethodQesitm
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    private func localizePillInfoName(name: String) -> String? {
        guard let name = PillInfoModelName(rawValue: name) else { return nil }
        switch name {
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
    
    private func localizePillDescriptionName(name: String) -> String? {
        guard let name = PillDescriptionName(rawValue: name) else { return nil }
        switch name {
        case .medicineSeq: return Constants.SearchDetail.medicineSeq
        case .medicineName: return Constants.SearchDetail.medicineName
        case .entpName: return Constants.SearchDetail.entpName
        case .efcyQestim: return Constants.SearchDetail.efcyQestim
        case .useMethodQesitm: return Constants.SearchDetail.useMethodQesitm
        case .atpnWarnQesitm: return Constants.SearchDetail.atpnWarnQesitm
        case .intrcQesitm: return Constants.SearchDetail.intrcQesitm
        case .seQesitm: return Constants.SearchDetail.seQesitm
        case .depositMethodQesitm: return Constants.SearchDetail.depositMethodQesitm
        }
    }
    
    func configure(_ pillInfoType: PillInfoType, name: String, value: String?) {
        if pillInfoType == .pillDescription {
            nameLabel.text = localizePillDescriptionName(name: name)
        } else {
            nameLabel.text = localizePillInfoName(name: name)
        }
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
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 16.0).isActive = true
        valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
    }
}
