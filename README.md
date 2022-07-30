# iOS-Picterest
- 원티드 iOS 프리온보딩 세 번째 과제
- 서버 API를 통해 받아온 랜덤 이미지를 가변 세로 길이의 레이아웃을 가진 `CollectionView`로 표현
- 무한 스크롤 `pagination` 구현
- 원하는 사진을 선택해 `CoreData`와 기기에 저장/삭제하는 기능 구현



# Developer
|monica|
|--|
|[<img src="https://user-images.githubusercontent.com/66169740/177245353-2c07bcd1-ffee-4d2d-923b-f1867aba606d.png" width="200">](https://github.com/3dots3craters)|




# 개발환경
![개발1](https://img.shields.io/badge/iOS-13.0+-silver)


# 기능
## 첫 번째 화면
|가변 세로 길이 레이아웃,<br>무한 스크롤 pagination|사진 저장|
|--|--|
|<img src="https://github.com/3dots3craters/ios-wanted-Picterest/blob/main/screenshot/%EC%82%AC%EC%A7%84%EB%AA%A9%EB%A1%9D%EA%B3%BC%ED%8E%98%EC%9D%B4%EC%A7%80%EB%84%A4%EC%9D%B4%EC%85%98.gif" width="220">|<img src="https://github.com/3dots3craters/ios-wanted-Picterest/blob/main/screenshot/%EC%82%AC%EC%A7%84%EC%A0%80%EC%9E%A5.gif" width="220">|
## 두 번째 화면
|저장한 사진 목록|사진 삭제|
|--|--|
|<img src="https://github.com/3dots3craters/ios-wanted-Picterest/blob/main/screenshot/%EC%A0%80%EC%9E%A5%ED%95%9C%EC%82%AC%EC%A7%84%ED%91%9C%EC%8B%9C.gif" width="220">|<img src="https://github.com/3dots3craters/ios-wanted-Picterest/blob/main/screenshot/%EC%82%AC%EC%A7%84%EC%82%AD%EC%A0%9C.gif" width="220">|

# 회고
## 커스텀뷰를 CollectionView 셀의 하위뷰로 설정했을 때 셀이 제대로 보이지 않는 문제
### 과정
- `view hierarchy`를 확인한 결과, 셀의 하위뷰로 커스텀뷰가 아예 들어가 있지 않은 것을 볼 수 있었다.
- 커스텀뷰를 셀에 더해주는 역할을 하는 `addSubView` 메서드가 호출되고 있는지를 확인해보았다.
### 원인
- 확인 결과, `addSubView`를 호출하는 셀의 `override init` 메서드부터 호출되지 않고 있었다.
- 검색을 통해 `override init` 메서드는 코드만 가지고 뷰를 만들어 낼 때 사용되고, `required init` 메서드는 `storyboard`를 가지고 뷰를 만들어 낼 때 사용된다는 걸 알게 되었다.
- 이 셀은 `storyboard`에서 만들어졌기 때문에 `required init` 메서드를 호출했다.
### 해결
- `required init`에서 `addSubView` 등 필요 메서드를 호출하는 것으로 바꾸니 셀의 내용이 잘 나타났다. 

## pagination에서 추가로 받아온 사진들이 CollectionView에 뜨지 않는 문제
### 과정
- `API`로부터 새로운 사진을 잘 받아오고 있고, `collectionview`가 reload되는 것 또한 확인했다. 
- 그렇다면 남은 건 `layout` 쪽뿐이어서 `layout` 메서드들도 잘 호출되고 있나 print문을 찍어 확인해보았다. 
- 확인 결과, 새로 사진을 받아왔을 때 커스텀 레이아웃의 `layoutAttributesForElements`만 호출되고 `prepare`는 앱이 처음 켜졌을 때, 그리고 첫번째 다운로드를 마친 후에만 호출되는 것을 볼 수 있었다. 
- `prepare`는 셀의 위치와 크기를 계산하는 중요한 역할을 수행하기 때문에 반드시 호출되어야 하는 메서드였다. 
- 그런데 `prepare`는 초반에 `cache`가 있는 경우 메서드를 마치도록 하는 guard문이 있었기 때문에, 혹 그것때문에 호출되지 않은 것처럼 보였을 수도 있겠다는 생각이 들었다. 그래서 guard문 앞에 print문을 넣고 확인한 결과, `prepare`가 잘 호출되고 있음을 알 수 있었다. 


### 원인

- `prepare` 메서드 앞 쪽에서 `cache` 배열에 `layoutAttributes`가 들어있는 경우 탈출하게끔 했기 때문이었다. 
- 새로 데이터를 받아오더라도 기존 `cache` 배열엔 여전히 레이아웃 값이 있으므로 탈출하게 되어, `prepare`를 통해 새로운 셀들의 위치를 계산하지 못했다. 

### 해결

- `collectionView`의 아이템 갯수와 현재 `cache`에 들어있는 `layoutAttributes`의 갯수를 비교해서 `collectionView`의 아이템 갯수가 더 많을 경우엔 새로 들어온 아이템의 레이아웃 계산을 진행하도록 하였다.

## delegateflowlayout의 메서드에서 셀의 사이즈를 구하지 못하는 문제
### 과정
- 처음에는 해당 메서드에서 파라미터로 받아오는 `collectionview`와 `indexpath`를 이용해 `collectionview.cellForItem(at: indexPath)`로 `cell`을 가져오고 그 `cell`의 `imageview`에 있는 `image`의 사이즈를 구해서 적절한 셀의 크기를 계산하는 것이 목표였다.
- 하지만 그렇게 가져온 `cell`을 custom cell type으로 캐스팅하는 데서 계속 에러가 발생했다. 
- 그래서 확인해보니 `cell`부터가 `nil`이었다. 
### 원인
- 공식 문서에 따르면, `cellForItem`은 ios 15 이전 버전에서는 셀이 화면에 표시되지 않거나 indexPath가 범위를 벗어나면 nil을 반환한다.
- `delegateflowlayout`의 메서드가 셀의 사이즈를 반환해야 그걸 토대로 셀이 화면에 표시될 테니 이 상황에서 nil이 나오는 게 맞았다.
- 가급적이면 메서드에서 받아온 매개변수만 가지고 사이즈를 계산하는 작업을 하고 싶었지만, ios 13 버전으로 작업하는 지금은 그게 불가능하게 보였다.
### 해결
- `CoreData`에 `image`의 높이와 너비까지 저장하고, `delegateflowlayout`에선 `CoreData`의 정보를 가져와서 셀 사이즈를 계산하도록 처리하여 문제를 해결했다.

# 개발 과정
- [노션 주소](https://broken-redcurrant-2ce.notion.site/0a1d9cca36ed4e98a4c264105feb208d)
