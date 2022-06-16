# 오늘뭐입지? - 날씨와 옷차림
<img width="150" alt="스크린샷 2022-05-10 오후 12 20 39" src="https://user-images.githubusercontent.com/76479760/174017588-d857442b-d1ad-47cc-a722-c5448518bb96.png">


`22.6. 16. 출시` - [앱스토어 바로가기](https://apps.apple.com/kr/app/%EC%98%A4%EB%8A%98%EB%AD%90%EC%9E%85%EC%A7%80-%EB%82%A0%EC%94%A8%EC%99%80-%EC%98%B7%EC%B0%A8%EB%A6%BC/id1629432583)

## 개요
<img width="230" alt="스크린샷 2022-05-10 오후 12 20 39" src="https://user-images.githubusercontent.com/76479760/169713045-2735c86e-3a5f-425c-a9f3-b798a54dfee0.gif">
- iOS 날씨앱
- 개인프로젝트
- 핵심기능: 체감온도를 기반으로 옷차림을 추천
- 일정: 22. 4. 5. ~ 개발 중

### 개발의도
- 기존 앱 대비 차별점
 
   기존 날씨 앱을 쓰면서 느낀 불편함 → 온도와 날씨정보를 바탕으로 내가 어떤 옷을 입어야하는지 결정하기가 어려웠다.
   
- 타겟 유저
 
   모든 사람(특히, 추위나 더위를 잘 타는사람)

### 아키텍쳐

- **MVVM + C with Clean Architecture**

### 사용 라이브러리

- **RxSwift**
- RealmSwift
- Lottie
- SnapKit

### Ground Rule
- StyleShare Swift Guide 준수

### 단계

STEP1. 날씨 기능 구현 **완료**
STEP2. 옷차림 추천 기능 구현 
STEP3. TestFlight
-> 출시

## 상세 설계 및 구현 내용

### 날씨정보 API
- 기상청 단기예보 및 중기예보 API 사용
- 날씨 Entity

# STEP1 날씨정보 파트 구현
## 구현내용
### 1. MVVM + Coordinator with CleanArichitecture
<img width="1464" alt="스크린샷 2022-05-10 오후 12 20 39" src="https://user-images.githubusercontent.com/76479760/167536151-875517d5-c520-46e0-9eec-c240c717277a.png">
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

## 고민한 점

### 1. 화면전환을 위한 Coordinator 패턴의 사용
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

### 2. 캐싱
기상청 API가 불안정하고 속도가 느린 이유로, Weather Cache Serivce를 구현하여 같은 날씨 정보를 재 요청 시 Cache에서 응답할 수 있도록 구현하였습니다.
- NSCache를 사용하여 구현하였습니다.
- Key는 "주소정보 + basetime" 의 NSString으로 설정하였습니다.
- 구조체를 Value값으로 직접 넣을 수 없기에 별도의 Wrapping Class를 구현하여 사용했습니다.

### 3. Location Manager
현재 위치정보와 위치권한을 활용하기 위해 Location Manager를 구현하였습니다.
- Singleton 디자인 패턴을 적용하였습니다.
- 현 위치정보와 위치권한을 PublishSubejct 프로퍼티로 가지고 있으며, 인터널 메서드를 사용해 외부에서 해당 프로퍼티의 stream을 활용할 수 있도록 구현하였습니다. 

## 궁금한 점

### 1. 여러 Data Entity와 Model이 복잡하게 얽혀있을 때의 문제
WeatherService 그림에서 볼 수 있듯이, 3개의 Model Entity를 만들어 내기 위해 여러 DataEntity가 사용됩니다. 이 과정에서 초단기예보의 요청이 중복해서 발생하는 문제가 생깁니다. 이를 해결하려면 어떻게 해야할지 궁금합니다.

### 2. API 업데이트 주기에 따른 Data Stream의 자동 업데이트
초단기예보와 단기예보는 최초 요청가능 시점 이후로 1시간동안 10분간격으로 5번동안 업데이트가 진행됩니다. 이를 구현하려면 어떻게 해야 할까요? 현재 생각하고 있는 방법은 별도의 Rx Scheduler를 만들어 타이머를 활용하는 것입니다. 그렇다면 이 로직은 WeatherService객체에서 사용되어야 할 것 같은데 어떻게 생각하시나요? 리뷰어 분들의 생각이 궁금합니다.

## 해결하지 못한 점
### 1. Input / Output 외에 별도의 Observable 프로퍼티가 생기는 문제
Coordinator를 Rx 흐름에 편입시켜서 사용하고 있는데 ViewModel의 Input/Ouput 외에 별도로 정의 해 줘야할 Observable 프로퍼티가 생기게 되었습니다. 
- Location View에서 셀을 터치했을 때 Location Coordinator로의 이벤트 전달

다른 구현방법이 있을까요?

### 2. 메모리 누수
<img width="331" alt="스크린샷 2022-05-10 오후 12 31 29" src="https://user-images.githubusercontent.com/76479760/167537273-11f4b40d-f50f-406d-a7d5-b125a7d2fe90.png">
Xcode에서 메모리 디버깅을 진행해 본 결과, 메모리 누수가 발생하는 것을 확인했습니다. Malloc Blocks에서 발생하는 메모리 누수도 유의미하게 살펴야 할까요? 그렇다면 저 누수가 어느 파일이나 인스턴스에서 일어나는지 확인이 가능할까요?

### 3. 파싱을 깔끔하게
중기 기상예보와 중기기온예보 API의 경우 아래와 같은 형태로 응답이 들어옵니다.
<img width="300" alt="스크린샷 2022-05-10 오후 12 38 11" src="https://user-images.githubusercontent.com/76479760/167537890-2b9bf95a-16d3-4dad-b5f0-192695754915.png">
현재는 각각의 정보에 해당하는 일일이 프로퍼티를 만들어 파싱을 해주고 있는데요,  좀 더 깔끔하게 처리할 수 있는 방법이 있을까요?

### 4. CollectionView에서 Swipe Action 발동 후 Search Bar 터치 시 애니메이션이 원상복귀 되지 않는 문제
<img width="312" alt="스크린샷 2022-05-10 오후 12 41 36" src="https://user-images.githubusercontent.com/76479760/167538184-477df337-5e07-4aeb-abd5-9f04f452d338.png">
위와 같은 상황이 발생하고 있으나, 현재 해결하지 못한 상태입니다.
- 시도해본 방법 : isEditing, resignFirstResponser

### 5. 앱 사용 도중 위치정보 권한이 변경되었을 시 처리


