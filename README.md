# 🌦오늘뭐입지?🩳

## 개요
<img src = "https://user-images.githubusercontent.com/76479760/166158724-d2b8b4f6-2c07-440a-8609-9a34f0a01ce9.png" width="30%" height="30%">

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
- ~~RxDataSource~~

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


