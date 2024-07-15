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

enum SearchShapeCollectionViewSecton: Int, CaseIterable {
    case line
    case color
    case shape
    case print
}

public enum SearchColorItems: String, CaseIterable {
    case brown = "갈색"
    case orange = "주황"
    case white = "하양"
    case yellow = "노랑"
    case blue = "파랑"
    case pink = "분홍"
    case black = "검정"
    case lightGreen = "연두"
    case green = "초록"
    case red = "빨강"
    case wine = "자주"
    case purple = "보라"
    case turquoise = "청록"
    case darkBlue = "남색"
    case clear = "투명"
    case gray = "회색"
    case null = "NULL"
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

public enum SearchLineItems: String, CaseIterable {
    case minuse = "-"
    case plus = "+"
    case other = "기타"
    case null = "NULL"
}

public struct SearchShapeFlowAction {
    
    public init() {
        
    }
}

public final class SearchShapeReactor: Reactor {
    
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    public var flowAction: SearchShapeFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: SearchShapeFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - Reactor
extension SearchShapeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            
        }
        return state
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
        case .color: return SearchColorItems.allCases.count
        case .shape: return SearchShapeItems.allCases.count
        case .line: return SearchLineItems.allCases.count
        case .print: return 1
        }
    }
    
    public func colorCellForItem(at item: Int) -> SearchColorItems {
        return SearchColorItems.allCases[item]
    }
    
    public func shapeCellForItem(at item: Int) -> SearchShapeItems {
        return SearchShapeItems.allCases[item]
    }
    
    public func lineCellForItem(at item: Int) -> SearchLineItems {
        return SearchLineItems.allCases[item]
    }
}
