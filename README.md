# 오늘뭐입지? - 날씨와 옷차림
<img width="150" alt="스크린샷 2022-05-10 오후 12 20 39" src="https://user-images.githubusercontent.com/76479760/174017588-d857442b-d1ad-47cc-a722-c5448518bb96.png">

`22.6. 16. 출시` - [앱스토어 바로가기](https://apps.apple.com/kr/app/%EC%98%A4%EB%8A%98%EB%AD%90%EC%9E%85%EC%A7%80-%EB%82%A0%EC%94%A8%EC%99%80-%EC%98%B7%EC%B0%A8%EB%A6%BC/id1629432583)

## ℹ️ 프로젝트 개요
- 개인 프로젝트
- 개발일정: 22. 4. 5. ~ 6. 15. 
- 날씨를 기반으로 한 옷차림을 추천해드려요! 매일 달라지는 외출, 복귀시간에 맞춘 맞춤형 추천 기능까지!
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

## Ground Rule
- [StyleShare Swift Guide](https://github.com/StyleShare/swift-style-guide) 준수

## 설계

### 1. **MVVM-C with Clean Architecture**

![image](https://user-images.githubusercontent.com/76479760/174220286-dc9bbe4c-bcc9-4504-8a57-780087d66ff3.png)

### 2. 화면전환을 위한 Coordinator 패턴의 사용
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
Coordinator를 프로토콜이 아닌 추상클래스로 구현한 이유는, 프로토콜일 경우 AssociatedType을 사용하여 제네릭을 구현해야하는데 이렇게 구현한 프로토콜은 오직 Type Constriant로만 사용가능하고 반환값이나 파라미터의 타입으로 사용할 수 없기 때문입니다.
- 이 클래스를 직접 사용할 경우를 방지하기 위해 직접 사용할 시 fatal error를 발생시키도록 구현하였습니다.
- start메서드의 반환값을 제네릭 Observable로 구현하여 해당 코디네이션 종료 시 발생하는 이벤트나 데이터를 쉽게 Rx Stream에 편입 시킬 수 있도록 도모하였습니다.

## 구현

### 1.날씨정보 
- 기상청 단기예보 및 중기예보 API 사용
- 날씨 Entity
- ViewModel에서 Input/ Output 구조체를 정의하여 사용하였습니다.

### 2. RxSwift를 활용한 데이터, 이벤트 바인딩 및 비동기 처리

### 3. 기상청 API를 활용한 Weather Service 구현
<img width="1425" alt="스크린샷 2022-05-10 오후 12 25 09" src="https://user-images.githubusercontent.com/76479760/167536572-7d9cdc9f-7764-4533-a7a1-0e7f2877700c.png">

WeatherService에서 반환한 DataEntity를 Repository단에서 Model로 변환하여 전달합니다.
- 기상청 API는 위경도 좌표값을 사용하지 않고, 위경도 좌표를 격자형태로 변환한 정보를 사용하기 때문에 GridConverting 객체를 만들어 사용하였습니다.

### 4. RealmSwift를 사용한 영구저장소 구현
즐겨찾기 위치를 저장하기 위하여 Relam을 사용했습니다.

### 5. KaKao Local API 사용
- 현재위치 좌표에서 주소정보를 얻기 위해 KaKao Local Geocode 서비스를 사용하였습니다.
- 주소 검색을 위해 KaKao Local Search 서비스를 사용하였습니다.

### 6. Location Manager
현재 위치정보와 위치권한을 활용하기 위해 Location Manager를 구현하였습니다.
- Singleton 디자인 패턴을 적용하였습니다.
- 현 위치정보와 위치권한을 PublishSubejct 프로퍼티로 가지고 있으며, 인터널 메서드를 사용해 외부에서 해당 프로퍼티의 stream을 활용할 수 있도록 구현하였습니다. 

### 7. 앱 사용 도중 위치정보 권한이 변경되었을 시 처리

### 8. 캐싱
기상청 API가 불안정하고 속도가 느린 이유로, Weather Cache Serivce를 구현하여 같은 날씨 정보를 재 요청 시 Cache에서 응답할 수 있도록 구현하였습니다.
- NSCache를 사용하여 구현하였습니다.
- Key는 "주소정보 + basetime" 의 NSString으로 설정하였습니다.
- 구조체를 Value값으로 직접 넣을 수 없기에 별도의 Wrapping Class를 구현하여 사용했습니다.

## 트러블 슈팅

### 1. CollectionView Footer 뷰 내부의 Button이 이벤트를 여러번 방출하는 문제 

## 조금 더 공부가 필요한 점

### 1. Input / Output 외에 별도의 Observable 프로퍼티가 생기는 문제
Coordinator를 Rx 흐름에 편입시켜서 사용하고 있는데 ViewModel의 Input/Ouput 외에 별도로 정의 해 줘야할 Observable 프로퍼티가 생기게 되었습니다. 
- Location View에서 셀을 터치했을 때 Location Coordinator로의 이벤트 전달

### 2. 여러 Data Entity와 Model이 복잡하게 얽혀있을 때의 문제
WeatherService 그림에서 볼 수 있듯이, 3개의 Model Entity를 만들어 내기 위해 여러 DataEntity가 사용됩니다. 이 과정에서 초단기예보의 요청이 중복해서 발생하는 문제가 생깁니다. 이를 해결하려면 어떻게 해야할지 궁금합니다.

## 향후 업데이트 계획

### 1. API 업데이트 주기에 따른 Data Stream의 자동 업데이트
초단기예보와 단기예보는 최초 요청가능 시점 이후로 1시간동안 10분간격으로 5번동안 업데이트가 진행됩니다. 현재 생각하고 있는 방법은 별도의 Rx Scheduler를 만들어 타이머를 활용하는 것입니다. 


