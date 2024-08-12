//
//  SearchDetailTableViewCell.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

public enum PillInfoModelName: String {
    case medicineSeq, medicineName, entpSeq, entpName, chart, medicineImage, printFront, printBack, medicineShape, colorClass1, colorClass2, lineFront, lineBack, lengLong, lengShort, thick, imgRegistTs, classNo, className, etcOtcName, medicinePermitDate, formCodeName, markCodeFrontAnal, markCodeBackAnal, markCodeFrontImg, markCodeBackImg, changeDate, markCodeFront, markCodeBack, medicineEngName, ediCode, hits
}

public enum PillDescriptionName: String {
    case medicineSeq, medicineName, entpName, efcyQestim, useMethodQesitm, atpnWarnQesitm, intrcQesitm, seQesitm, depositMethodQesitm
}

public final class SearchDetailTableViewCell: UITableViewCell {
    
    private let rootContainerView = UIView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteMedium(18.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Color.label
        label.font = Constants.Font.suiteRegular(18.0)
        label.numberOfLines = 0
        return label
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Constants.Color.background
        selectionStyle = .none
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    private func localizePillInfoName(name: String) -> String? {
        guard let name = PillInfoModelName(rawValue: name) else { return nil }
        switch name {
        case .medicineSeq: return Constants.Search.medicineSeq
        case .medicineName: return Constants.Search.medicineName
        case .entpSeq: return Constants.Search.entpSeq
        case .entpName: return Constants.Search.entpName
        case .chart: return Constants.Search.chart
        case .medicineImage: return Constants.Search.medicineImage
        case .printFront: return Constants.Search.printFront
        case .printBack: return Constants.Search.printBack
        case .medicineShape: return Constants.Search.medicineShape
        case .colorClass1: return Constants.Search.colorClass1
        case .colorClass2: return Constants.Search.colorClass2
        case .lineFront: return Constants.Search.lineFront
        case .lineBack: return Constants.Search.lineBack
        case .lengLong: return Constants.Search.lengLong
        case .lengShort: return Constants.Search.lengShort
        case .thick: return Constants.Search.thick
        case .imgRegistTs: return Constants.Search.imgRegistTs
        case .classNo: return Constants.Search.classNo
        case .className: return Constants.Search.className
        case .etcOtcName: return Constants.Search.etcOtcName
        case .medicinePermitDate: return Constants.Search.medicinePermitDate
        case .formCodeName: return Constants.Search.formCodeName
        case .markCodeFrontAnal: return Constants.Search.markCodeFrontAnal
        case .markCodeBackAnal: return Constants.Search.markCodeBackAnal
        case .markCodeFrontImg: return Constants.Search.markCodeFrontImg
        case .markCodeBackImg: return Constants.Search.markCodeBackImg
        case .changeDate: return Constants.Search.changeDate
        case .markCodeFront: return Constants.Search.markCodeFront
        case .markCodeBack: return Constants.Search.markCodeBack
        case .medicineEngName: return Constants.Search.medicineEngName
        case .ediCode: return Constants.Search.ediCode
        case .hits: return Constants.Search.hits
        }
    }
    
    private func localizePillDescriptionName(name: String) -> String? {
        guard let name = PillDescriptionName(rawValue: name) else { return nil }
        switch name {
        case .medicineSeq: return Constants.Search.medicineSeq
        case .medicineName: return Constants.Search.medicineName
        case .entpName: return Constants.Search.entpName
        case .efcyQestim: return Constants.Search.efcyQestim
        case .useMethodQesitm: return Constants.Search.useMethodQesitm
        case .atpnWarnQesitm: return Constants.Search.atpnWarnQesitm
        case .intrcQesitm: return Constants.Search.intrcQesitm
        case .seQesitm: return Constants.Search.seQesitm
        case .depositMethodQesitm: return Constants.Search.depositMethodQesitm
        }
    }
    
    public func configure(_ pillInfoType: PillInfoType, name: String, value: String?) {
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
