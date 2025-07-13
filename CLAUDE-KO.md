# CLAUDE-KO.md

이 파일은 Claude Code (claude.ai/code)가 이 저장소에서 작업할 때 참고할 가이드를 제공합니다.

## 프로젝트 개요

PillInformation은 의약품 정보 및 관리를 위한 iOS 앱으로, Tuist를 사용한 프로젝트 생성과 Clean Architecture 패턴을 따라 구축되었습니다. 앱은 알람 기능, 북마크 관리, 검색 기능, 사용자 온보딩을 지원합니다.

## 빌드 시스템 및 명령어

### 사전 요구사항
- 프로젝트 생성을 위해 Tuist 4.9.0 필요
- 설치: `brew tap tuist/tuist && brew install --formula tuist@4.9.0`
- 이미 설치된 경우: `brew link --overwrite tuist@4.9.0`

### 핵심 개발 명령어
```bash
# Xcode 워크스페이스 및 프로젝트 생성
tuist generate

# 종속성 설치 (첫 빌드 전 실행)
tuist install

# 개별 기능 데모 앱 실행 (빠른 개발)
tuist run [FeatureName]DemoApp

# 특정 모듈 테스트
tuist test [ModuleName]

# 전체 프로젝트 빌드
tuist build

# 생성된 파일 정리
tuist clean

# 종속성 그래프 보기
tuist graph
```

### 사용 가능한 스키마
- **DEV**: 개발 서버 구성이 포함된 개발 스키마
- **PROD**: 프로덕션/릴리스 스키마
- **TEST_DEV**: 개발 테스트 스키마
- **TEST_PROD**: 프로덕션 테스트 스키마

## 아키텍처

### 모듈형 Clean Architecture
프로젝트는 엄격한 모듈 분리를 통한 Clean Architecture를 따릅니다:

**데이터 레이어:**
- `*Data` 모듈들 (AlarmData, BookmarkData, SearchData 등)
- 리포지토리, 네트워크 매니저, 영구 저장소 포함
- 도메인 인터페이스 구현

**도메인 레이어:**
- `*Domain` 모듈들 (AlarmDomain, BookmarkDomain, SearchDomain 등)
- 엔티티, 유스케이스, 리포지토리 인터페이스 포함
- 프레임워크 종속성이 없는 순수 비즈니스 로직

**프레젠테이션 레이어:**
- UI 로직을 포함한 `*Presentation` 모듈들
- BasePresentation은 공유 UI 컴포넌트와 유틸리티 포함

**기능 레이어:**
- 기능 모듈들 (Alarm, Bookmark, Search, Home, MyPage, Onboarding, Splash)
- 코디네이터와 의존성 주입 컨테이너 포함
- 각 기능은 독립적인 개발을 위한 자체 데모 앱 보유

**인프라스트럭처:**
- NetworkInfra: Moya/Alamofire를 사용한 네트워크 레이어
- NotificationInfra: 로컬 알림 서비스

**라이브러리 관리:**
- 외부 종속성 그룹화: ReactiveLibraries, UILibraries, NetworkLibraries, DataLibraries, LayoutLibraries, KakaoLibraries

### 주요 패턴
- **MVI (Model-View-Intent)** 와 ReactorKit
- **코디네이터 패턴** 네비게이션용
- **의존성 주입** 커스텀 DI 컨테이너 사용
- **리포지토리 패턴** 데이터 접근용

### 기술 스택
- **리액티브**: RxSwift, ReactorKit, RxCocoa, RxDataSources
- **네트워킹**: Alamofire, Moya
- **데이터베이스**: RealmSwift
- **레이아웃**: FlexLayout, PinLayout
- **UI**: SkeletonView, Kingfisher, Lottie, Tabman
- **테스팅**: Quick, RxTest, RxNimble

## 개발 워크플로우

### 기능 개발
1. 빠른 반복을 위해 개별 기능 데모 앱에서 작업
2. 특정 기능 실행을 위해 `tuist run [Feature]DemoApp` 사용
3. 메인 앱은 TabBarCoordinator를 통해 모든 기능 조율

### 종속성 추가
- 외부 종속성은 `Tuist/Package.swift` 수정
- `Projects/LibraryManager/`의 해당 라이브러리 매니저 업데이트
- 종속성은 타입별로 그룹화됨 (UI, Network, Data 등)

### 구성 관리
- `XCConfig/` 디렉토리에 환경별 구성
- 스키마별로 API 키와 URL 구성 (DEV/PROD)
- SecretKey.swift에 구성 매핑 포함

### 테스팅
- 각 모듈은 자체 테스트 타겟 보유
- BDD 스타일 테스팅을 위해 Quick/Nimble 사용
- 리액티브 코드 테스팅을 위해 RxTest 사용
- 네트워크 응답 모킹을 위해 TestNetworkManager 사용

## 중요 파일들
- `Workspace.swift`: 메인 워크스페이스 구조 정의
- `Projects/**/Project.swift`: 개별 모듈 구성
- `Tuist/ProjectDescriptionHelpers/`: 공유 빌드 구성 헬퍼
- `Projects/Application/`: 메인 앱 타겟 및 진입점

## 개발 팁
- InjectIII를 활용한 UI 개발 속도 향상 지원
- 각 기능별 데모 앱을 통한 독립적인 개발 가능
- 로그인 기능은 구현되어 있지만 서버 플래그에 따라 비활성화 가능