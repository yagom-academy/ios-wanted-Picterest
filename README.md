# Picterest


# 목차
  1. [Developer](#Developer)
  2. [프로젝트 소개](#프로젝트-소개)
     1. [목표](#목표)
     2. [기능 소개](#기능-소개)
        - Demo gif
  3. [고민한 부분](#고민한-부분)
  4. [회고](회고)
  5. [이슈관리](#이슈관리)
  
---

# 👨‍💻 Developer
|Peppo|
|:--:|
|[<img src = "https://user-images.githubusercontent.com/78457093/180595896-1ae6c1a5-4ebe-48da-9d7d-8246046ec12e.jpg" width = "250" height = "300">](https://github.com/Bhoon-coding)|

---

<br>

# 프로젝트 소개
- 오픈 API ([Unsplash](https://unsplash.com/documentation))를 이용하여 이미지를 받아와, 가변 세로 길이의 레이아웃으로 나타냄.
- 원하는 사진을 선택해 저장하는 기능.
<br>


## 목표
- `infinite scroll` (무한스크롤) 구현
- 가변 세로 길이에 따른 `Custom CollectionView` 레이아웃 구현 및 index 변경
- 이미지 캐싱
- 상황에 따른 Alert 보여주기
- FileManager, CoreData를 응용하여 `CRUD` 구현
<br>


## 기능 소개


### PhotoListPage
|무한스크롤, <br> 오픈API (GET)|저장된 사진 삭제|
|:--:|:--:|
|<img src = "https://user-images.githubusercontent.com/64088377/181904342-9c235cb7-061c-4dfe-b8d8-c7147b03d498.gif" width = "200">|<img src = "https://user-images.githubusercontent.com/64088377/181916033-e4925cc9-e0c1-46df-bd0c-10363bdbafbc.gif" width = "200">|

<br>

### SavedPhotoPage
|사진 저장 (Local)|저장된 사진 삭제|
|:--:|:--:|
|<img src = "https://user-images.githubusercontent.com/64088377/181904386-c391d8cd-ef59-4030-bd3a-2a68537bfb83.gif" width = "200"> | <img src = "https://i.imgur.com/0QJ7GqC.gif" width = "200">|


---
<br>

# 고민한 부분

### 문제1

별표 버튼을 누를때마다 전체 컬렉션뷰 내부 전체 cell에 입력이 되는 상황
cell에 있는 별표 버튼을 index에 맞게 각각 눌리게 구현해야 했었음.

### 해결

cell 내부에서 `CellActionDelegate` 를 만들어준 후,
PhotoListVC에서 채택하여 `starButtonTapped` 메서드의 파라미터로`PhotoListCollectionViewCell`을 적용 -> collectionView.indexPath(for: cell)로 눌려지는 Index 파악

```swift
// PhotoListCollectionViewCell
protocol CellActionDelegate: AnyObject {
    
    func starButtonTapped(cell: PhotoListCollectionViewCell) { }
    
    
}

class PhotoListCollectionViewCell: UICollectionViewCell { 
    
    weak var cellDelegate: CellActionDelegate?

    //...
    
    @objc func starTapped() {
        cellDelegate?.starButtonTapped(cell: self)
    }
    
}
```

```swift
// PhotoListViewController
func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell { 
    // ... 
    
    cell.cellDelegate = self
    
}

extension PhotoListViewController: CellActionDelegate {
    
    func starButtonTapped(cell: PhotoListCollectionViewCell) {
     guard let indexPath = collectionView.indexPath(for: cell) else { return }       
    // ...
    }
}
```

### 문제2
CollectionViewCell에서 cornerRadius를 지정해도 반응이 없음.

### 해결

`clipsToBounds = true` 를 이용해 해결

```swift
clipsToBounds = true // subView가 view의 경계를 넘어갈 시 잘림.
clipsToBounds = false // 경계를 넘어가도 잘리지 않음
```

### 배운점

subView에 아무리 cornerRadius를 줘봤자 상위 view에서 설정이 되어있지 않으면 반응이없다.



<br>

---
# 회고


## Peppo
- 드디어 프리온보딩 코스의 마지막 프로젝트가 끝이났다. 
이번 프로젝트에서는 그동안 여러 조원들을 만나면서 써보고자 했던건 거의 써본것 같다. API도 GET 하나만 사용해도 됐었는데 네트워크 레이어를 만들었고, 최대한 컨벤션도 맞춰보려고 노력했던것 같다. 혼자하는 프로젝트였던 만큼 직접구현 해보려고 애썼던게 좋았고, 지금까지 진행해왔던 프로젝트들을 리팩토링 해보면서 복습하는 시간을 가져봐야겠다.


----

<br>

[이슈관리](https://github.com/Bhoon-coding/ios-wanted-Picterest/issues?q=is%3Aissue+is%3Aclosed)
