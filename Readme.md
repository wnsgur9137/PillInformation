# PillInformation

![graph](graph.png)

![graph_test](graph_test.png)

<br>

## 개발 현황

https://github.com/wnsgur9137/PillInformation/issues/67

<br>

## Design pattern

|Pattern|
|:--|
|Model-View-Intent(MVI)|
|Dependency Injection Pattern|
|Coordinator|
|Singleton|
|Builder|
|Adapter|

<br>

# Scheme

|Name||
|:--|--|
|DEV|개발 스키마|
|PROD|상용 스키마|
|TEST_DEV|개발 테스트 스키마|
|TEST_PROD|상용 테스트 스키마|

<br>

## InjectIII

UI 개발 속도를 올리기 위해 InjectIII를 활용
https://github.com/johnno1962/InjectionIII

<br>

## Demo App

각 Feature마다 데모앱이 존재해, 각 데모앱에서 앱을 개발

<br>

## 로그인

현재 앱은 로그인 기능이 필요가 없기에, 기능은 구현되어있지만 서버에서 로그인 flag를 false를 받은 경우 로그인 관련 기능 로드하지 않음.

<br>

## Commend LIne Tool (Generating Xcode project)

|Name|Version|
|:--:|--|
|Tuist|4.9.0|

```
brew tap tuist/tuist
brew install --formula tuist@4.9.0

# 만약 tuist가 설치되어 있는 경우
brew link --overwrite tuist@4.9.0
```

<br>

## Third-party libraries

|Name|Version|-|
|:--:|-------|---|
|RxSwift|6.6.0|ReactiveLibraries|
|ReactorKit|3.2.0|ReactiveLibraries|
|RxCocoa|(RxSwift)|UILibraries|
|RxGesture|4.0.4|UILibraries|
|RxDataSources|5.0.0|UILibraries|
|Alamofire|5.9.1|NetworkLibraries|
|Moya|15.0.0|NetworkLibraries|
|RealmSwift|10.49.1|DataLibraries|
|Quick|7.6.2|TestLibraries|
|RxTests|(RxSwift)|TestLibraries|
|RxBlocking|(RxSwift)|TestLibraries|
|RxNimble|6.3.1|TestLibraries|
|FlexLayout|2.0.07|LayoutLibraries|
|PinLayout|1.10.5|LayoutLibraries|
|SkeletonView|1.30.4|UILibraries|
|Kingfisher|7.11.0|UILibraries|
|DropDown|2.3.13|UILibraries|
|Tabman|3.2.0|UILibraries|
|Pageboy|4.2.0|UILibraries|
|lottie|4.4.1|UILibraries|
|AcknowList|3.2.0|UILibraries|
|kakaoSDK|master|KakaoLibraries|


