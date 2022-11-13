# 오늘뭐입지? - 날씨와 옷차림
<img width="150" alt="스크린샷 2022-05-10 오후 12 20 39" src="https://user-images.githubusercontent.com/76479760/174017588-d857442b-d1ad-47cc-a722-c5448518bb96.png">

`22.6. 16. 출시` - [앱스토어 바로가기](https://apps.apple.com/kr/app/%EC%98%A4%EB%8A%98%EB%AD%90%EC%9E%85%EC%A7%80-%EB%82%A0%EC%94%A8%EC%99%80-%EC%98%B7%EC%B0%A8%EB%A6%BC/id1629432583)

<br>

## ℹ️ 프로젝트 개요
- 개인 프로젝트
- 개발일정: 22. 4. 5. ~ 6. 15. 
- 날씨를 기반으로 한 옷차림을 추천해드려요! 매일 달라지는 외출, 복귀시간에 맞춘 맞춤형 추천 기능까지!.

<br>

## ⚙️ 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.0-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.2-blue)]()
[![rxswift](https://img.shields.io/badge/RxSwift-6.5.0-green)]()
[![realmswift](https://img.shields.io/badge/RealmSwift-10.23.0-red)]()
[![snapkit](https://img.shields.io/badge/SnapKit-5.0.1-yellow)]()
[![lottie](https://img.shields.io/badge/Lottie-3.3-white)]()

<br>
<br>

## 🤖 주요기능
> 현재 위치 기반으로 한 날씨 정보와 옷차림을 추천해드려요! 그날 그날 다른 외출시간에도 맞춤 추천 OK!!

<img src="https://user-images.githubusercontent.com/76479760/174220481-2d2abfdf-8d1a-4f70-9009-cb006d020368.png" width=25%>

> 주소 검색을 통해 다른 지역의 위치도 즐겨찾기 할 수 있어요!

<img src="https://user-images.githubusercontent.com/76479760/174224663-f09dc618-a2b9-463b-8e70-4daa96940602.png" width=25%><img src="https://user-images.githubusercontent.com/76479760/174224594-71710238-0b60-449f-aa39-b2f3264b5a7b.png" width=25%><img src="https://user-images.githubusercontent.com/76479760/174225078-17adce1f-07ea-4091-bb6f-91dfe98b1dce.png" width=25%>

> 성별과 온도 민감도에 따라 차별화된 추천을 제공해요!
<img src="https://user-images.githubusercontent.com/76479760/174225242-231b48a9-d41b-465f-a872-a88252d4f78e.png" width=25%>

<br>

## Ground Rule
- [StyleShare Swift Guide](https://github.com/StyleShare/swift-style-guide) 준수
- Karma Commit Convension

<br>

## ⛰ 설계

### 1. MVVM + Coordinator with CleanArichitecture

![image](https://user-images.githubusercontent.com/76479760/174220286-dc9bbe4c-bcc9-4504-8a57-780087d66ff3.png)

> **MVVM**
> 
- View는 자기 UIEvent의 발행과 UI요소의 디자인 정보를 담당합니다.
- ViewModel은 Presentation Logic을 갖고 있으며, UseCase를 사용해 받아온 Model을 View가 표현할 수 있는 형태로 전달하는 역할을 담당합니다.

> **Clean Architecture**
> 
- UseCase는 Buisness Logic을 담당하며 Repository를 사용하여 Model을 받아오는 역할을 담당합니다.
- Repository는 Service 객체를 사용하여 iOS 외부의 데이터(통신, 영구저장소)를 가져옵니다. DataSource(캐시/통신)에 대한 판단도 이곳에서 이루어집니다.
- Domain Layer는 Prentation Layer와 Data Layer에 의존하지 않아야 합니다. Repository 프로토콜을 사용하여 의존성을 역전을 도모합니다.

> **Input/Output Modeling**
> 
- ViewModel에서 Input / Output 구조체를 정의하여 사용하였습니다.

### 2. 화면전환을 위한 Coordinator 패턴의 사용


> **RxSwift**
> 
- start 메서드의 반환값을 제네릭 Observable로 구현하여 **해당 코디네이션 종료 시 발생하는 이벤트나 데이터를 쉽게 Rx Stream에 편입** 시킬 수 있도록 도모하였습니다.
- Coodinator가 담당하는 화면이 사라지는 이벤트가 발생하는 시점에 상위 Coodinator에서 하위 Coodinator를 해제시킵니다.

> **Abstract Class**
> 
- Coordinator를 프로토콜이 아닌 추상클래스로 구현한 이유는, 프로토콜일 경우 AssociatedType을 사용하여 제네릭을 구현해야하는데 이렇게 구현한 프로토콜은 오직 Type Constriant로만 사용가능하고 반환값이나 파라미터의 타입으로 사용할 수 없기 때문입니다.
- 이 클래스를 직접 사용할 경우를 방지하기 위해 직접 사용할 시 fatal error를 발생시키도록 구현하였습니다.
```swift
class Coordinator<CoordinationResult>: NSObject {

    let disposeBag = DisposeBag()
    let identifer = UUID()
    var childCoordinators = [UUID: Any]()

    private func store<T>(coordinator: Coordinator<T>) {
        self.childCoordinators[coordinator.identifer] = coordinator
    }

    private func release<T>(coordinator: Coordinator<T>) {
        self.childCoordinators[coordinator.identifer] = nil
    }

    func coordinate<T>(to coordinator: Coordinator<T>) -> Observable<T> {
        self.store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: {[weak self] _ in
                self?.release(coordinator: coordinator)
            })
    }

    func start() -> Observable<CoordinationResult> {
        fatalError("not implemented")
    }
}
```

<br>

## 🌳 구현

### 1. `RxSwift`를 활용한 데이터, 이벤트 바인딩 및 비동기 처리

- Data Layer부터 시작되어 Presentation Layer로 도달하는 일련의 Stream으로 데이터 바인딩하였습니다.
- 부득이한 경우 외에는 Data의 최종 도착지인 View에서만 구독이 이루어 질 수 있도록 구현하였습니다.
- 강한 순환 참조와 지연 해제를 방지하기 위해 `withUnretained` 오퍼레이터와 캡쳐리스트의 weak을 적극 활용하였으며, 최대한 클로저 형태의 바인딩을 지양하고 오퍼레이터의 파라미터를 사용하려 노력했습니다.

### 2. 기상청 API를 활용한 Weather Service 구현
<img width="1425" alt="스크린샷 2022-05-10 오후 12 25 09" src="https://user-images.githubusercontent.com/76479760/167536572-7d9cdc9f-7764-4533-a7a1-0e7f2877700c.png">

- WeatherService에서 반환한 DataEntity를 Repository단에서 Model로 변환하여 전달합니다.
- 기상청 API는 위경도 좌표값을 사용하지 않고, 위경도 좌표를 격자형태로 변환한 정보를 사용하기 때문에 GridConverting 객체를 만들어 사용하였습니다.

### 3. RealmSwift를 사용한 영구저장소 구현
- 즐겨찾기 위치를 저장하기 위하여 영구저장소 라이브러리인 `RelamSwift`를 사용했습니다.
- RealmService 객체를 별도로 구현하여 Location Repository가 나중에 다른 영구저장소로 확장될 수 있도록 설계하였습니다.

### 4. 좌표 ↔️ 주소 변환을 위한 KaKao Local API 사용
- 현재위치 좌표에서 주소정보를 얻기 위해 `KaKao Local Geocode` 서비스를 사용하였습니다.
- 주소 검색을 위해 `KaKao Local Search` 서비스를 사용하였습니다.

### 5. `CoreLocation`를 사용한 Location Manager 구현
- 현재 위치정보와 위치권한을 활용하기 위해 CoreLocation Location Manager를 구현하였습니다.
- Singleton 디자인 패턴을 적용하였습니다.
- 현 위치정보와 위치권한을 PublishSubejct 프로퍼티로 가지고 있으며, 인터널 메서드를 사용해 외부에서 해당 프로퍼티의 stream을 활용할 수 있도록 구현하였습니다.

### 6. 일기예보 정보 캐싱을 위한 `NSCache`의 사용

- 기상청 API가 불안정하고 속도가 느린 이유로, Weather Cache Serivce를 구현하여 같은 날씨 정보를 재 요청 시 Cache에서 응답할 수 있도록 구현하였습니다.
- NSCache를 사용하여 구현하였습니다.
- Key는 "주소정보 + basetime" 의 NSString으로 설정하였습니다.
- 구조체를 Value값으로 직접 넣을 수 없기에 별도의 Wrapping Class를 구현하여 사용했습니다.

### 7. 사용자 설정 값 저장을 위한 `UserDefaults` 사용

- 사용자의 성별, 온도 민감도, 외출시간 등을 저장하기 위해 UserDefaults를 사용하였습니다.

### 8. `UIPageViewController`를 사용한 페이징 효과 구현

- [사용자의 현재위치 + 즐겨찾기 위치] 를 Paging 하기 위해서 UIPageViewController를 사용하였습니다.
- MainViewController가 PageViewController와 OrderedViewControllers 프로퍼티를 소유하면서 Main Coordinator가 여러 이벤트에 대응해 적절하게 PageVC의 DataSource를 컨트롤합니다.
<br>

## 🔥 트러블 슈팅

### 1. 앱 사용 도중 위치정보 권한이 변경되었을 시 처리****

> 문제상황 : 앱 실행 중 사용자가 아이폰 설정에서 권한을 변경할 시 PageVC가 제대로 대응하지 못하는 문제
> 
- 앱 사용 중 위치정보 권한 사용안함 ↔️ 허용 간 변경에 대응하기 위해 MainViewModel에서 `isCurrentAvailable` 프로퍼티와 `favoriteLocations` 프로퍼티를 활용하여 MainCoodinator에서 권한에 따라 페이징 되는 PageVC의 ChildViewController들을 컨트롤 하도록 구현하여 해결

### 2. CollectionView Footer 뷰 내부의 Button이 이벤트를 여러번 방출하는 문제

> 문제상황 : 옷 추천 CollectionView의 FooterView뷰 내부의 RefreshButton이 터치되면 이벤트를 3번 방출하는 문제. Subscribe가 3번 되는 상황
> 
- UICollectionView DiffableDataSource의 `supplementaryViewProvider` 내부에서 바인딩을 진행해 주고있으나, 해당 클로저가 3번 반복해서 불리는 현상 확인
- FooterView가 재사용 큐로 들어갈 때 Disposed되도록 구현하여 해결함
- FooterView에 DisposeBag 프로퍼티 추가하여 구현
    
    ```swift
    class RecommendationCollectionFooterView: UICollectionReusableView {
        var disposeBag = DisposeBag()
    		... 
    		override func prepareForReuse() {
    		        self.disposeBag = DisposeBag()
    		    }
    }
    ```
    

### 3. 기상청 API의 불안정함을 최적화 하기위한 노력

> 문제상황 : 기상청 API에 Get 요청을 할때 간헐적으로 오랫동안(1분 이상) 응답이 오지 않는 현상 발생. 서버에서 타임아웃 에러도 발생시키지 않는 상황
> 
- 기상청 API에서 제공하는 응답 평균 요청시간을 기반으로 자체적으로 타임아웃을 판단하여 에러를 방출하도록 설정 및 재시도 하도록 구현하여 해결
- `timeout` , `retry` Operator의 사용으로 구현
```swift
func fetchUltraShortNowcast(for location: LocationInfo, at date: Date) 
-> Single<UltraShortNowcastWeatherItem> {
	...
}.timeout(.milliseconds(3000), scheduler: MainScheduler.instance)

func fetchCurrentWeather(from location: LocationInfo) -> Observable<CurrentWeather> {
        return self.repository.fetchCurrentWeather(for: location, at: Date())
            .retry { error in
                error.flatMap { _ in
                     Observable<Int>
                       .timer(.seconds(3), period: nil, scheduler: MainScheduler.asyncInstance)
                   }
            }
    }
```
<br>

## ❓ 조금 더 공부가 필요한 점

### 1. 여러 Data Entity와 Model이 복잡하게 얽혀있을 때의 문제

위의 WeatherService 그림에서 볼 수 있듯이, 3개의 Model Entity를 만들어 내기 위해 여러 DataEntity가 사용됩니다. 이 과정에서 초단기예보의 요청이 중복해서 발생하는 문제가 발생한다.

### 2. Input / Output 외에 별도의 Observable 프로퍼티가 생기는 문제

Coordinator를 Rx 흐름에 편입시켜서 사용하고 있는데 ViewModel의 Input/Ouput 외에 별도로 정의 해 줘야할 Observable 프로퍼티가 생기게 됨.

- Location View에서 셀을 터치했을 때 Location Coordinator로의 이벤트 전달

### 3. Diffable DataSource / Compositional Layout with RxSwift

Diffable DataSource / Compositional Layout 을 사용하여 Collection View를 구현하였는데, Cell외의 Collection View 내부 요소들을 Binding할때 현재의 Input/Output 모델링에 맞추기 위해 VC내부에 별도의 `Subject` 타입의 프로퍼티들이 생기게 되었다. 이게 구조적으로 옳은 걸까?

<br>

## 🎯 향후 업데이트 계획
### 1. API 업데이트 주기에 따른 Data Stream의 자동 업데이트

- 초단기예보와 단기예보는 최초 요청가능 시점 이후로 1시간동안 10분간격으로 5번동안 업데이트가 진행됨
- 앱을 켜놨을 때 자동으로 업데이트 주기를 Date정보와 타이머로 감지하여 반환하는 별도의 객체 생성 예정

### 2. 추상클래스로 구현된 Coordinator를 Generic Protocol로 변경

- WWDC 22에서 발표된 Swift 5.7 버전부터 사용가능한 Generic Protocol으로 구현 변경하기

<br>

## Reference
- RangeSlider 구현에 김종권님의 글을 참고했습니다. - [[iOS - SwiftUI] Slider 사용 방법](https://ios-development.tistory.com/1090)
