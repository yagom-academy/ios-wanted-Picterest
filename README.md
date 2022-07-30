
# Picterest (Pinterest Clone Project)

## 팀원
|미니(이경민)|
|--|
|[<img src="https://avatars.githubusercontent.com/u/52390923?v=4" width="200">](https://github.com/leegyoungmin)|

## 개발 환경
![개발1](https://img.shields.io/badge/iOS-13.0+-silver) ![개발2](https://img.shields.io/badge/FireStorage-9.2.0-yellow)

## 기능
|화면1|화면2|화면3|
|--|--|--|
|![기능1](https://github.com/leegyoungmin/ios-wanted-Picterest/blob/main/previews/firstPreviews.gif)|![기능2](https://github.com/leegyoungmin/ios-wanted-Picterest/blob/main/previews/secondPreview.gif))|![기능3](https://github.com/leegyoungmin/ios-wanted-Picterest/blob/main/previews/thirdPreview.gif)|
## 프로젝트 소개
- Collection View Custom Layout을 활용한 Water Fall 방식의 UI 구성
- Core Data를 활용한 로컬 데이터 저장 구현
- NSCache를 활용한 메모리 캐시 구현

## 진행 과정
- 공통
    - KeyChain을 활용하여 API 키를 보관.
    - UIAlertController 객체를 지속적으로 생성하는 방법 대신 공통의 Controller를 생성하여 활용.
- 화면 1
    - Custom Layout 객체를 통해서 Collection View의 데이터를 보여주는 UI를 구성.
    - 이미지 데이터 네트워크 담당 객체를 생성해서 데이터를 불러오는 과정을 생성.
    - 이미지 로드 담당 객체를 생성해서 Custom Layout 사이즈에 맞는 이미지를 네트워크 통신을 구현.
    - 이미지 캐싱을 구현하기 위해서 NSCache를 활용함.
    - File Manager를 활용하여 이미지를 로컬에 저장.
    - 싱글톤을 활용한 Core Data 객체를 생성하여 로컬에 데이터를 저장.
- 화면 2
    - 싱글톤으로 제작된 Core Data 객체를 활용하여 인메모리 상태의 데이터를 불러옴.
    - Core Data의 데이터를 불러와서 File Manager로 로컬에 존재하는 이미지를 불러옴.


## 기술적 고민
- Alert Controller의 반복적 생성
![code1](https://github.com/leegyoungmin/ios-wanted-Picterest/blob/main/previews/code1.png)
    화면 1과 화면 2에서 Alert Controller를 생성해야 하는 곳이 많다. 처음 구현 당시 이에 대해서 반복적으로 코드를 작성하게 되었다.
    하지만 이에 대해서 클린 코드적으로 좋지 않다고 생각했다. 이를 해결하기 위해서 Enum 타입을 정의하여 이에 대한 고통적 Alert Controller를 구현하였다.
- Pagenation 구현 시, Prefetching Data Source와 Scroll Delegate와의 충돌
    ![code2](https://github.com/leegyoungmin/ios-wanted-Picterest/blob/main/previews/code2.png)
    ![code3](https://github.com/leegyoungmin/ios-wanted-Picterest/blob/main/previews/code3.jpg)
    처음에는 Pagenation을 Prefetching Data에서 구현하기로 결정하였다. 하지만 이에 대해서 데이터를 불러오는 것과 이미지를 로드하는 과정이 충돌하였다.
    이를 해결하기 위해서 Pagenation으로 이미지와 관련된 데이터를 불러오는 작업을 Scroll Delegate에서 구현하고, 이미지를 로드하는 과정을 ImageLoader 객체를 통해서 Prefetching DataSource에서 구현하였다. 
- View Controller에서 ViewModel의 직접적인 데이터 접근 제한
    ![code4](https://github.com/leegyoungmin/ios-wanted-Picterest/blob/main/previews/code4.png)
    ![code5](https://github.com/leegyoungmin/ios-wanted-Picterest/blob/main/previews/code5.png)
    MVVM 아키텍쳐를 적용하기 위해서 ViewModel을 직접적으로 주입하기로 하였다. 하지만 이에 대해서 ViewModel의 데이터를 직접적으로 사용하는 것은 안전하지 않다고 생각하였다. 이를 해결하기 위해서 프로토콜을 구성하고 이를 채택하는 방법을 활용하여서 데이터에 간접적으로 접근하게 구성하였다. 이와 같은 POP 프로그래밍을 이용하여 Network객체와 Cache 및 FileManager 객체를 동일한 방식으로 구현하였다. 이를 통해서 반복적인 코드를 줄이고, 추상화를 통해서 변수에 간접적으로 접근하게 하였다.

## 회고
    이번 과제를 수행하면서 개인의 역량을 측정할 수 있었다고 생각합니다. 4주의 과정으로 팀원의 소중함을 알았고, 팀원의 힘을 알게 된 것 같습니다.
    팀 프로젝트를 통해서 누군가가 함께 한 것 자체가 힘이 되는 것이라고 생각이 들었습니다. 또한 저의 부족함을 굉장히 많이 알게 된 것 같습니다.
    개인 공부를 하면서 저의 능력에 대해서 '어느 정돈의 실력이 있다' 라고 생각하였지만, '나는 너무나 부족하구나','나의 생각이 달랐고, 누군가의 생각이 나에게 많은 지식을 줄 수 있구나' 라고 생각합니다. 이런 생각을 통해서 자신의 생각을 바꿀 수 있어서 너무나 좋았고, 이를 통해서 발전 할 수 있는 계기가 되어서 너무 좋았습니다.
