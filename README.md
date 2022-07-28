# 프로젝트 소개
### Picterest
- 서버에서 이미지를 받아와 가변레이아웃으로 나타냅니다.
- 원하는 사진을 저장 혹은 삭제할 수 있습니다.

<br/>

# 개발 기간
- 2022.07.25 ~ 2022.07.28

<br>

# 사용 기술
- `UIKit`, `MVVM`, `FileManager`, `CoreData`, `NSCache`, `Combine`, `URLSession`, `UICollectionViewLayout`, `NoStoryboard`

<br>

# 실횅화면

| <center> 랜덤사진뷰 </center> | <center> 사진저장 </center> | <center> 사진삭제 </center> |
 | -- | -- | -- |
| <p float="none"> <img src= "./docs/appgif/randomImage.gif"/> </p> | <p float="none"> <img src= "./docs/appgif/save.gif"/> </p> | <p float="none"> <img src= "./docs/appgif/delete.gif"/> </p> | 

<br>

# 객체 역할 소개

## View 관련

| class / struct | 역할 |
| -- | -- |
| `MainTabBarController` | - 앱의 ViewController 생성 및 전환 <br> - business객체 및 ViewModel 생성 |
| `DefaultImageViewModel` | - Image Model을 가지고있는 ViewModel <br> - CoreDataManager 및 StorageManager를 가지고있다 |
| `RandomImageViewModel` | - DefaultImageViewModel을 상속 <br> - RandomImageViewController에서 이루어지는 fetchImage, saveImage, deleteImage를 수행한다 |
| `StarImageViewModel` | - DefaultImageViewModel을 상속 <br> - StarImageViewController에서 이루어지는 deleteImage를 수행한다 |
| `CollectionViewManager` | - CollectionView를 그리기 위해 필요한 DataSource, Delegate 프로토콜을 채택하고 구현하고 있다 |

## business 관련

| class / struct | 역할 |
| -- | -- |
| `NetworkManager` | - 네트워크 통신을 통해 RandomImageEntity 및 이미지를 받아온다 <br> - 이미지를 받아오는 메서드는 TypeMethod 이다 |
| `StorageManager` | - 사진을 로컬에서 불러오기, 저장 및 삭제하는 역할을 한다 <br> - 사진을 불러오는 메서드는 TypeMethod 이다 |
| `CoreDataManager` | - 저장한 사진의 정보를 내부저장소에서 불러오기, 저장 및 삭제하는 역할을 한다 |
| `ImageCacheManager` | - NetworkManager 및 StorageManager에서 받아온 사진을 캐싱하는 역할을 한다 |

## Model 관련

| class / struct | 역할 |
| -- | -- |
| `RandomImageEntity` | - 네트워크 통신을 통해 받아온 이미지정보의 모델이다 <br> - Image 프로토콜을 채택하고 있다 |
| `RandomImage` | - RandomImageEntity에 필요한 정보를 추가한 모델이다 |
| `StarImageEntity` | - StarImage 인스턴스를 손쉽게 생성하기 위한 모델이다 |
| `StarImage` | - CoreData의 Entity이다 |