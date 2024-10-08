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

public enum SearchShapeItems: CaseIterable {
    case rectangle
    case oval
    case circular
    case semicircular
    case rhombus
    case triangle
    case square
    case pentagon
    case hexagon
    case octagon
    case other
    
    var string: String {
        switch self {
        case .rectangle: return Constants.Search.rectangle
        case .oval: return Constants.Search.oval
        case .circular: return Constants.Search.circular
        case .semicircular: return Constants.Search.semicircular
        case .rhombus: return Constants.Search.rhombus
        case .triangle: return Constants.Search.triangle
        case .square: return Constants.Search.square
        case .pentagon: return Constants.Search.pentagon
        case .hexagon: return Constants.Search.hexagon
        case .octagon: return Constants.Search.octagon
        case .other: return Constants.Search.other
        }
    }
}

public enum SearchColorItems: CaseIterable {
    case clear
    case white
    case pink
    case red
    case orange
    case yellow
    case lightGreen
    case green
    case turquoise
    case blue
    case darkBlue
    case purple
    case wine
    case brown
    case gray
    case black
    case null
    
    var string: String {
        switch self {
        case .clear: return Constants.Search.clear
        case .white: return Constants.Search.white
        case .pink: return Constants.Search.pink
        case .red: return Constants.Search.red
        case .orange: return Constants.Search.orange
        case .yellow: return Constants.Search.yellow
        case .lightGreen: return Constants.Search.lightGreen
        case .green: return Constants.Search.green
        case .turquoise: return Constants.Search.turquoise
        case .blue: return Constants.Search.blue
        case .darkBlue: return Constants.Search.darkBlue
        case .purple: return Constants.Search.purple
        case .wine: return Constants.Search.wine
        case .brown: return Constants.Search.brown
        case .gray: return Constants.Search.gray
        case .black: return Constants.Search.black
        case .null: return Constants.Search.null
        }
    }
}

public enum SearchLineItems: CaseIterable {
    case minuse
    case plus
    case other
    case null
    
    var string: String {
        switch self {
        case .minuse: return Constants.Search.minuse
        case .plus: return Constants.Search.plus
        case .other: return Constants.Search.other
        case .null: return Constants.Search.null
        }
    }
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
            return (title: Constants.alert,
                    message: Constants.Search.serverError)
        }
        switch error {
        case .emptyShape:
            return (title: Constants.Search.emptyErrorTitle, message: nil)
            
        case .default:
            return (title: Constants.alert,
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
        let isSelected = shapeInfo.colors.contains(item.string)
        return (item, isSelected)
    }
    
    public func shapeCellForItem(at item: Int) -> (item: SearchShapeItems, isSelected: Bool) {
        let item = SearchShapeItems.allCases[item]
        let isSelected = shapeInfo.shapes.contains(item.string)
        return (item, isSelected)
    }
    
    public func lineCellForItem(at item: Int) -> (item: SearchLineItems, isSelected: Bool) {
        let item = SearchLineItems.allCases[item]
        let isSelected = shapeInfo.shapes.contains(item.string)
        return (item, isSelected)
    }
}
