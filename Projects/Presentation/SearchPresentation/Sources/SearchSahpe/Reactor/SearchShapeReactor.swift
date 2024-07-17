//
//  SearchShapeReactor.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import BasePresentation

enum SearchShapeError: String, Error {
    case emptyShape
    case `default`
}

public enum SearchShapeCollectionViewSecton: Int, CaseIterable {
    case shape
    case color
    case line
    case code
    case searchView
}

public enum SearchShapeItems: String, CaseIterable {
    case rectangle = "장방형"
    case oval = "타원형"
    case circular = "원형"
    case semicircular = "반원형"
    case rhombus = "마름모형"
    case triangle = "삼각형"
    case square = "사각형"
    case pentagon = "오각형"
    case hexagon = "육각형"
    case octagon = "팔각형"
    case other = "기타"
}

public enum SearchColorItems: String, CaseIterable {
    case clear = "투명"
    case white = "하양"
    case pink = "분홍"
    case red = "빨강"
    case orange = "주황"
    case yellow = "노랑"
    case lightGreen = "연두"
    case green = "초록"
    case turquoise = "청록"
    case blue = "파랑"
    case darkBlue = "남색"
    case purple = "보라"
    case wine = "자주"
    case brown = "갈색"
    case gray = "회색"
    case black = "검정"
    case null = "NULL"
}

public enum SearchLineItems: String, CaseIterable {
    case minuse = "-"
    case plus = "+"
    case other = "기타"
    case null = "NULL"
}

public struct SearchShapeFlowAction {
    let showSearchResultViewControler: (PillShapeModel) -> Void
    
    public init(showSearchResultViewControler: @escaping (PillShapeModel) -> Void) {
        self.showSearchResultViewControler = showSearchResultViewControler
    }
}

public final class SearchShapeReactor: Reactor {
    public typealias ShapeButtonAction = (section: SearchShapeCollectionViewSecton, isSelected: Bool, value: String?)
    typealias AlertContents = (title: String, message: String?)
    
    public enum Action {
        case didSelectShapeButton(ShapeButtonAction)
        case search
    }
    
    public enum Mutation {
        case error(Error)
        case updateShapeInfo(PillShapeModel)
        case showSearchResultViewController(PillShapeModel)
    }
    
    public struct State {
        @Pulse var errorAlertContents: AlertContents?
        var selectedOptions: [String]?
    }
    
    public var initialState = State()
    public var flowAction: SearchShapeFlowAction
    private let disposeBag = DisposeBag()
    private var shapeInfo: PillShapeModel = .init()
    
    public init(flowAction: SearchShapeFlowAction) {
        self.flowAction = flowAction
    }
    
    private func handle(_ error: Error) -> AlertContents {
        guard let error = error as? SearchShapeError else {
            return (title: Constants.Search.alert,
                    message: Constants.Search.serverError)
        }
        switch error {
        case .emptyShape:
            return (title: Constants.SearchShape.emptyErrorTitle, message: nil)
            
        case .default:
            return (title: Constants.Search.alert,
                    message: Constants.Search.serverError)
        }
    }
    
    private func editShapeInfo(_ section: SearchShapeCollectionViewSecton,
                               isSelected: Bool,
                               value: String?) -> Observable<Mutation> {
        guard let value = value else {
            return .just(.error(SearchShapeError.default))
        }
        var shapeInfo = shapeInfo
        switch section {
        case .shape:
            if isSelected {
                shapeInfo.shapes.append(value)
            } else if let index = shapeInfo.shapes.firstIndex(of: value) {
                shapeInfo.shapes.remove(at: index)
            }
            
        case .color:
            if isSelected {
                shapeInfo.colors.append(value)
            } else if let index = shapeInfo.colors.firstIndex(of: value) {
                shapeInfo.colors.remove(at: index)
            }
            
        case .line:
            if isSelected {
                shapeInfo.lines.append(value)
            } else if let index = shapeInfo.lines.firstIndex(of: value) {
                shapeInfo.lines.remove(at: index)
            }
            
        case .code:
            if isSelected {
                shapeInfo.codes.append(value)
            } else if let index = shapeInfo.codes.firstIndex(of: value) {
                shapeInfo.codes.remove(at: index)
            }
        default: break
        }
        
        return .just(.updateShapeInfo(shapeInfo))
    }
}

// MARK: - Reactor
extension SearchShapeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectShapeButton((section, isSelected, shape)):
            return editShapeInfo(section, isSelected: isSelected, value: shape)
            
        case .search:
            if shapeInfo.shapes.count == 0 &&
                shapeInfo.colors.count == 0 &&
                shapeInfo.lines.count == 0 &&
                shapeInfo.codes.count == 0 {
                return .just(.error(SearchShapeError.emptyShape))
            }
            return .just(.showSearchResultViewController(shapeInfo))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .error(error):
            state.errorAlertContents = handle(error)
            
        case let .updateShapeInfo(shapeInfo):
            self.shapeInfo = shapeInfo
            state.selectedOptions = shapeInfo.shapes + shapeInfo.colors + shapeInfo.lines + shapeInfo.codes
            
        case let .showSearchResultViewController(shapeInfo):
            showSearchResultViewController(shapeInfo: shapeInfo)
        }
        return state
    }
    
}

 // MARK: - Flow Action
extension SearchShapeReactor {
    private func showSearchResultViewController(shapeInfo: PillShapeModel) {
        flowAction.showSearchResultViewControler(shapeInfo)
    }
}

// MARK: - SearchShapeAdapter DataSource
extension SearchShapeReactor: SearchShapeAdapterDataSource {
    public func numberOfSections() -> Int {
        return SearchShapeCollectionViewSecton.allCases.count
    }
    
    public func numberOfItems(in section: Int) -> Int {
        guard let section = SearchShapeCollectionViewSecton(rawValue: section) else { return 0 }
        switch section {
        case .shape: return SearchShapeItems.allCases.count
        case .color: return SearchColorItems.allCases.count
        case .line: return SearchLineItems.allCases.count
        case .code: return 1
        case .searchView: return 1
        }
    }
    
    public func colorCellForItem(at item: Int) -> (item: SearchColorItems, isSelected: Bool) {
        let item = SearchColorItems.allCases[item]
        let isSelected = shapeInfo.colors.contains(item.rawValue)
        return (item, isSelected)
    }
    
    public func shapeCellForItem(at item: Int) -> (item: SearchShapeItems, isSelected: Bool) {
        let item = SearchShapeItems.allCases[item]
        let isSelected = shapeInfo.shapes.contains(item.rawValue)
        return (item, isSelected)
    }
    
    public func lineCellForItem(at item: Int) -> (item: SearchLineItems, isSelected: Bool) {
        let item = SearchLineItems.allCases[item]
        let isSelected = shapeInfo.shapes.contains(item.rawValue)
        return (item, isSelected)
    }
}
