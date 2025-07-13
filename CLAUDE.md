# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PillInformation is an iOS app for pill/medication information and management, built using Tuist for project generation and following Clean Architecture patterns. The app supports alarm functionality, bookmark management, search capabilities, and user onboarding.

## Build System and Commands

### Prerequisites
- Tuist 4.9.0 required for project generation
- Install with: `brew tap tuist/tuist && brew install --formula tuist@4.9.0`
- If already installed: `brew link --overwrite tuist@4.9.0`

### Core Development Commands
```bash
# Generate Xcode workspace and projects
tuist generate

# Install dependencies (run before first build)
tuist install

# Run individual feature demo apps (faster development)
tuist run [FeatureName]DemoApp

# Test specific modules
tuist test [ModuleName]

# Build entire project
tuist build

# Clean generated files
tuist clean

# View dependency graph
tuist graph
```

### Available Schemes
- **DEV**: Development scheme with dev server configuration
- **PROD**: Production/release scheme 
- **TEST_DEV**: Development testing scheme
- **TEST_PROD**: Production testing scheme

## Architecture

### Modular Clean Architecture
The project follows Clean Architecture with strict module separation:

**Data Layer:**
- `*Data` modules (AlarmData, BookmarkData, SearchData, etc.)
- Contains repositories, network managers, persistent storage
- Implements domain interfaces

**Domain Layer:**
- `*Domain` modules (AlarmDomain, BookmarkDomain, SearchDomain, etc.)
- Contains entities, use cases, and repository interfaces
- Pure business logic with no framework dependencies

**Presentation Layer:**
- `*Presentation` modules with UI logic
- BasePresentation contains shared UI components and utilities

**Feature Layer:**
- Feature modules (Alarm, Bookmark, Search, Home, MyPage, Onboarding, Splash)
- Contains coordinators and dependency injection containers
- Each feature has its own demo app for isolated development

**Infrastructure:**
- NetworkInfra: Network layer with Moya/Alamofire
- NotificationInfra: Local notification services

**Library Management:**
- Grouped external dependencies: ReactiveLibraries, UILibraries, NetworkLibraries, DataLibraries, LayoutLibraries, KakaoLibraries

### Key Patterns
- **MVI (Model-View-Intent)** with ReactorKit
- **Coordinator Pattern** for navigation
- **Dependency Injection** with custom DI containers
- **Repository Pattern** for data access

### Technology Stack
- **Reactive**: RxSwift, ReactorKit, RxCocoa, RxDataSources
- **Networking**: Alamofire, Moya
- **Database**: RealmSwift
- **Layout**: FlexLayout, PinLayout
- **UI**: SkeletonView, Kingfisher, Lottie, Tabman
- **Testing**: Quick, RxTest, RxNimble

## Development Workflow

### Feature Development
1. Work in individual feature demo apps for faster iteration
2. Use `tuist run [Feature]DemoApp` to launch specific features
3. Main app coordinates all features through TabBarCoordinator

### Adding Dependencies
- Modify `Tuist/Package.swift` for external dependencies
- Update corresponding library managers in `Projects/LibraryManager/`
- Dependencies are grouped by type (UI, Network, Data, etc.)

### Configuration Management
- Environment-specific configurations in `XCConfig/` directory
- API keys and URLs configured per scheme (DEV/PROD)
- SecretKey.swift contains configuration mappings

### Testing
- Each module has its own test target
- Use Quick/Nimble for BDD-style testing
- RxTest for reactive code testing
- TestNetworkManager for mocking network responses

## Important Files
- `Workspace.swift`: Defines the main workspace structure
- `Projects/**/Project.swift`: Individual module configurations
- `Tuist/ProjectDescriptionHelpers/`: Shared build configuration helpers
- `Projects/Application/`: Main app target and entry point