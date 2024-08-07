//
//  SearchShapeCollectionViewCell.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout

import BasePresentation

final class SearchShapeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteSemiBold(18.0)
        label.textAlignment = .center
        label.textColor = Constants.Color.label
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.suiteMedium(16.0)
        label.textAlignment = .center
        label.textColor = Constants.Color.label
        return label
    }()
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = Constants.Color.label
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Properties
    
    
    /// override var isSelected를 쓰면 cell이 다시 그려질 때 초기화된다..! (default: false)
    var isSelectedCell: Bool = false {
        didSet {
            showSelectedImageView(isSelectedCell)
        }
    }
    
    private var titleLabelColor: UIColor = Constants.Color.label {
        didSet {
            selectedImageView.tintColor = titleLabelColor
        }
    }
    
    private(set) var disposeBag = DisposeBag()
    private(set) var content: String?
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rootContainerView.backgroundColor = Constants.Color.systemBackground
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        content = nil
    }
    
    private func showSelectedImageView(_ isSelected: Bool) {
        selectedImageView.isHidden = !isSelected
        titleLabel.isHidden = isSelected
    }
    
    // MARK: - Methods
    
    /// 모양(이미지)
    private func setupImageAttributedString(_ shape: SearchShapeItems) {
        guard shape != .other else { return }
        var image: UIImage?
        switch shape {
        case .rectangle: image = Constants.SearchShape.Image.rectangle
        case .oval: image = Constants.SearchShape.Image.oval
        case .circular: image = Constants.SearchShape.Image.circle
        case .semicircular: image = Constants.SearchShape.Image.semiCircle
        case .rhombus: image = Constants.SearchShape.Image.rhombus
        case .triangle: image = Constants.SearchShape.Image.triangle
        case .square: image = Constants.SearchShape.Image.square
        case .pentagon: image = Constants.SearchShape.Image.pentagon
        case .hexagon: image = Constants.SearchShape.Image.hexagon
        case .octagon: image = Constants.SearchShape.Image.octagon
        case .other: return
        }
        let attributedString = NSMutableAttributedString(string: "")
        let imageSize = CGSize(width: 40.0, height: 40.0)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        let imageAttributedString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageAttributedString)
        titleLabel.attributedText = attributedString
    }
    
    /// 모양(텍스트)
    private func setupTextAttributedString(_ shape: SearchShapeItems) {
        guard shape == .other else { return }
        titleLabel.text = Constants.SearchShape.other
    }
    
    /// 구분선(이미지)
    private func setupImageAttributedString(_ line: SearchLineItems) {
        guard line == .minuse || line == .plus else { return }
        let image = line == .minuse ? Constants.SearchShape.Image.minus : Constants.SearchShape.Image.plus
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageAttributedString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageAttributedString)
        titleLabel.attributedText = attributedString
    }
    
    /// 구분선(텍스트)
    private func setupTextAttributedString(_ line: SearchLineItems) {
        guard line == .other || line == .null else { return }
        let text = line == .other ? Constants.SearchShape.other : Constants.SearchShape.null
        titleLabel.text = text
    }
}

// MARK: - Configure
extension SearchShapeCollectionViewCell {
    
    /// 모양
    func configure(_ shape: SearchShapeItems, isSelected: Bool = false) {
        content = shape.rawValue
        self.isSelectedCell = isSelected
        if shape == .other {
            titleLabel.font = Constants.Font.suiteSemiBold(24.0)
            setupTextAttributedString(shape)
        } else {
            setupImageAttributedString(shape)
            subTitleLabel.text = shape.rawValue
            subTitleLabel.flex.markDirty()
        }
        rootContainerView.flex.layout()
    }
    
    /// 색상
    func configure(_ color: SearchColorItems, isSelected: Bool = false) {
        content = color.rawValue
        self.isSelectedCell = isSelected
        var backgroundColor: UIColor? = Constants.Color.background
        switch color {
        case .clear:
            backgroundColor = Constants.Color.systemWhite.withAlphaComponent(0.8)
            titleLabelColor = Constants.Color.systemBlack
        case .white:
            backgroundColor = Constants.Color.systemWhite
            titleLabelColor = Constants.Color.systemBlack
        case .pink:
            backgroundColor = Constants.Color.pink
            titleLabelColor = Constants.Color.systemWhite
        case .red:
            backgroundColor = Constants.Color.systemRed
            titleLabelColor = Constants.Color.systemWhite
        case .orange:
            backgroundColor = Constants.Color.systemOrange
            titleLabelColor = Constants.Color.systemWhite
        case .yellow:
            backgroundColor = Constants.Color.systemYellow
            titleLabelColor = Constants.Color.systemBlack
        case .lightGreen:
            backgroundColor = Constants.Color.lightGreen
            titleLabelColor = Constants.Color.systemBlack
        case .green:
            backgroundColor = Constants.Color.systemGreen
            titleLabelColor = Constants.Color.systemWhite
        case .turquoise:
            backgroundColor = Constants.Color.turquoise
            titleLabelColor = Constants.Color.systemBlack
        case .blue:
            backgroundColor = Constants.Color.systemBlue
            titleLabelColor = Constants.Color.systemWhite
        case .darkBlue:
            backgroundColor = Constants.Color.deepBlue
            titleLabelColor = Constants.Color.systemWhite
        case .purple:
            backgroundColor = Constants.Color.systemPurple
            titleLabelColor = Constants.Color.systemWhite
        case .wine:
            backgroundColor = Constants.Color.wine
            titleLabelColor = Constants.Color.systemWhite
        case .brown:
            backgroundColor = Constants.Color.systemBrown
            titleLabelColor = Constants.Color.systemWhite
        case .gray:
            backgroundColor = Constants.Color.systemGray
            titleLabelColor = Constants.Color.systemBlack
        case .black:
            backgroundColor = Constants.Color.systemBlack
            titleLabelColor = Constants.Color.systemWhite
        case .null:
            backgroundColor = Constants.Color.systemBackground
            titleLabelColor = Constants.Color.label
        }
        
        rootContainerView.backgroundColor = backgroundColor
        titleLabel.textColor = titleLabelColor
        titleLabel.text = color != .null ? color.rawValue : Constants.SearchShape.null
    }
    
    
    /// 구분선
    func configure(_ line: SearchLineItems, isSelected: Bool = false) {
        content = line.rawValue
        self.isSelectedCell = isSelected
        switch line {
        case .minuse: fallthrough
        case .plus: setupImageAttributedString(line)
        case .other: fallthrough
        case .null: setupTextAttributedString(line)
        }
    }
}

// MARK: - Layout
extension SearchShapeCollectionViewCell {
    private func setupLayout() {
        addSubview(rootContainerView)
        rootContainerView.addSubview(selectedImageView)
        rootContainerView.flex
            .border(0.5, Constants.Color.label)
            .cornerRadius(24.0)
            .alignItems(.center)
            .justifyContent(.center)
            .define { rootView in
                rootView.addItem(titleLabel)
                    .marginTop(5%)
                    .width(100%)
                    .grow(1)
                rootView.addItem(subTitleLabel)
                    .marginBottom(5%)
            }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
        selectedImageView.pin.center()
            .width(32.0)
            .height(32.0)
    }
}
