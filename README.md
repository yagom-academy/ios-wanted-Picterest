| JMin | 
| -- | 
| [<img src="https://github.com/jmindeveloper.png" width="200">](https://github.com/jmindeveloper)|

# 프로젝트 소개
### Picterest
- 서버에서 이미지를 받아와 가변레이아웃으로 나타냅니다.
- 원하는 이미지을 저장 혹은 삭제할 수 있습니다.

<br/>

# 개발 기간
- 2022.07.25 ~ 2022.07.28

<br>

# 사용 기술
- `UIKit`, `MVVM`, `FileManager`, `CoreData`, `NSCache`, `Combine`, `URLSession`, `UICollectionViewLayout`, `NoStoryboard`

<br>

# 실횅화면

| <center> 랜덤이미지뷰 </center> | <center> 이미지저장 </center> | <center> 이미지삭제 </center> |
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
| `StorageManager` | - 이미지를 로컬에서 불러오기, 저장 및 삭제하는 역할을 한다 <br> - 이미지를 불러오는 메서드는 TypeMethod 이다 |
| `CoreDataManager` | - 저장한 이미지의 정보를 내부저장소에서 불러오기, 저장 및 삭제하는 역할을 한다 |
| `ImageCacheManager` | - NetworkManager 및 StorageManager에서 받아온 이미지를 캐싱하는 역할을 한다 |

## Model 관련

| class / struct | 역할 |
| -- | -- |
| `RandomImageEntity` | - 네트워크 통신을 통해 받아온 이미지정보의 모델이다 <br> - Image 프로토콜을 채택하고 있다 |
| `RandomImage` | - RandomImageEntity에 필요한 정보를 추가한 모델이다 |
| `StarImageEntity` | - StarImage 인스턴스를 손쉽게 생성하기 위한 모델이다 |
| `StarImage` | - CoreData의 Entity이다 <br> - Image 프로토콜을 채택하고 있다 |

<br>

# 고민했던점
## 이미지의 저장 및 삭제가 view에 즉각적으로 반영되지 않는 문제
### 문제점
이미지의 저장 및 삭제가 이루어질때마다 각 뷰컨트롤러의 collectionView가 업데이트되도록 구현을 해주었다  
기대했던 동작은 RandomImageViewController에서 이미지를 저장 혹은 삭제하면 StarImageViewController의 collectionView에서 바로 반영되는거였다  
하지만 그렇지 않았다
### 해결법
각각의 ViewModel이 서로다른 CoreDataManager 객체를 가지고 있다  
RandomImageViewModel의 CoreData객체의 저장메서드는 호출이 돼었으나 StarImageViewModel의 CoreData객체의 저장메서드는 호출이 안됐기 때문에 StarImageViewController는 이미지가 저장됐다는걸 몰랐다는게 문제였다  
<br>
따라서 두개의 ViewModel이 같은 CoreDataManager를 가지고 있으면 문제가 해결될거라 생각했다
CoreDataManager 객체를 미리 생성해서 ViewModel 객체를 생성할때 주입해주었더니 문제가 해결되었다

## 이미지의 삭제가 한번에 두번씩 되는 문제
### 문제점
위 문제를 해결하기 위헤 ViewModel에서 하나의 CoreData를 공유하면서 생긴 문제로 이미지가 한번에 두개씩 삭제되는 문제가 생겼다
### 해결법
위 문제를 해결하면서 StorageManager도 하나의 객체를 공유하게 해줬다  
StorageManager에서 이미지의 삭제가 완료되면 CoreData에서 삭제를 하고있는데 두게의 ViewModel이 각각 StorageManager에서 이미지 삭제가 됐을때 CoreDataManager에서 삭제하는 메서드를 호출하기때문에 두번삭제되는 문제였다  
<br>
따라서 현재 탭의 뷰컨트롤러에 따라서 호출할 CoreDataManager의 삭제메서드를 구분지어줘서 해결했다

## 뷰모델에서 이미지 모델을 분리하면서 생긴 문제
### 문제점
RandomImageVM 및 StarImageVM가 각각 가지고 있는 이미지 모델의 배열을 DefaultImageVM으로 분리를 시도했다  
하지만 RandomImageVM 및 StarImageVM이 가지고 있는 이미지 모델이 달랐기 때문에 DefaultImageVM에서 이미지 모델 배열을 두개를 만들어줘야 하는 문제가 생겼다
StarImageViewModel에선 RandomImageEntity 모델을 사용하지 않기때문에 인터페이스 분리 원칙에 어긋난다고 생각했다

### 해결법
Image Protocol을 만들어 RandomImageEntity 및 StarImage에 채택해주었다  
그리고 DefaultImageViewModel의 이미지 모델의 배열을 Image 타입으로 만들어주었다  
따라서 이미지 모델의 배열에 각각 다른 타입의 이미지 모델을 저장할수 있었다  
<br>
나중에 또다른 이미지 모델을 저장할 일이 생기더라도 Image Protocol만 채택해주면 저장이 가능하기에 코드가 유연해졌다고도 생각한다

## 타입 메서드 사용이유

NetworkManager 및 StorageManager에서 이미지를 받아오는 함수는 타입메서드로 구현이 되어있다  
<br>
이미지는 collectionView의 cell이 재사용할때 불러오고 있는데 cell을 재사용할때마다 NetworkManager 및 StorageManager의 인스턴스를 생성해주는게 성능면에서 좋지 않을거라 생각했다  
또한 이미지를 받아오는 작업은 앱 전반적으로 계속해서 사용하기 때문에 해당 메서드가 메모리에 계속 올라와있어도 괜찮을거라 판단하여 타입메서드로 작성했다

