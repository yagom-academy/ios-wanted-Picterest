# 👨‍👩‍👦‍👦 팀원 소개

| <center>UY</center>   |
| -------------------------------------------------------- |
| [<img src="https://github.com/ScutiUY.png" width="200">](https://github.com/ScutiUY) |


<br>

* * *

# 🖥 프로젝트 소개
### **애플리케이션 설명**

- 서버 API를 이용하여 이미지를 받아와, 가변 세로 길이의 레이아웃으로 나타냅니다.
- 원하는 사진을 선택해 저장하는 기능을 갖습니다.
- 아이폰, 세로 모드만 지원하는 앱입니다.

<br>

* * *

# ⏱️ 개발 기간 및 사용 기술

- 개발 기간: 2022.07.25 ~ 2022.07.28 (4일)
- 사용 기술:  `UIKit`, `MVVM`, `URLSession`, `Coredata`, `NSCache`, `FileManager`, `UICollectionViewLayout`

<br>

* * *


# 🖼 디자인 패턴과 설계
### MVVM

![무제 drawio](https://user-images.githubusercontent.com/36326157/181514071-df0786e9-dfd1-43ac-a8ad-82c72e092785.png)


<br>

* * *

# ⚠️ 트러블 슈팅

- ## Repository collectionView에서 셀 삭제시 문제

	- collectionView.deleteItem(at:)의 실행 플로우   
    		
		- 우선 셀을 삭제한다(실제 보여지는 셀에서 삭제를 한다)
    	- 그후 다시 reload를 실행하여 변화된 데이터를 지워진 자리에 집어넣는다
    	- 이때 셀의 사이지의 변화가 있으면 변화 시켜서 집어 넣는다.
	
	- 문제점
		- collectoinView를 reload 할 때 viewModel의 count를 가져와 쓴다.
   		- 삭제시 viewModel의 imageList를 갱신 시켜주지 않았다. (CoreData와 FileManager만 처리해 주었다.)
    	- 때문에 모든 정보가 삭제 되어도 imageList의 count는 삭제 되기 전 그대로이기 때문에 문제가 발생

```Swift
// ImageRepository VC
// 기존 코드
{ 
	picturesCollectionView.deleteItems(at: [indexPath])
	let item = viewModel.image(at: indexPath.row)
	CoreDataManager.shared.delete(entity: item)
	PicterestFileManager.shared.deletePicture(fileName: item.id!)
 }

//----------- 개선 ------------
{
	picturesCollectionView.deleteItems(at: [indexPath])
	viewModel.deleteImage(at: indexPath)
}   

// ViewModel
func deleteImage(at indexPath: IndexPath) {
        let item = imageList[indexPath.item]
        CoreDataManager.shared.delete(entity: item)
        PicterestFileManager.shared.deletePicture(fileName: item.id!)
        imageList.remove(at: indexPath.row)
    }

```
<br>

* * *

- ## CollectionView Cell의 ContextMenu와의 싸움

cell의 삭제시 contextMenu를 사용했다. 이 과정에서 내가 지정해준 cornerRadius와 시스템에서 제공되는 UITargetPreview의 cornerRadius가 맞지 않았다.   
아래와 같이 preview의 cornerRadius 흰 부분이 cell의 크기보다 커서 매우 거슬리는 손톱 거스러미 같은 UI가 완성 되었다.  

![스크린샷 2022-07-27 오후 5 18 22](https://user-images.githubusercontent.com/36326157/181450670-ebd7f908-75b1-4153-a3a5-0f04d98868f8.png)       
     

분명 preView를 건드려줄 수 있을거라 생각하여

**collectionView(_:previewForHighlightingContextMenuWithConfiguration:)** 를 사용하였다.

preview에 접근하여 UIPreviewParameters의 backgroundColor을 clear로 바꿔주거나 visiblePath를 통해 preview 자체를 cell이 아닌 cell의 contentView로 깎아버렸다.   

```Swift
func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: cell.contentView.bounds, cornerRadius: cell.contentView.layer.cornerRadius)

        return UITargetedPreview(view: cell, parameters: parameters)
    }
```

![image](https://user-images.githubusercontent.com/36326157/181451645-2f07dc28-66cb-4445-bb94-1de4cfc423aa.png)     

<br>

* * *

- ## Picture list에서의 삭제 기능

이미지들의 리스트에서 별표 모양의 저장 버튼을 눌렀다 다시 한번 누르면 삭제 되는 기능을 추가하려 했다.

기존 Picture List에선 저장 기능 외에 coredata를 사용하는 일이 없었다. 당연히 fetch를 해야 할 일이 없기에 저장 부분에서만 코어데이터에 접근한다.

하지만 삭제를 하기 위해선 coredata의 entity가 필요하다. Repository Scene에선 보여주는 정보가 coredata에서 fetch한 데이터기 때문에 쉽게 접근 가능했다.

또한 cell의 재사용 문제 때문에 Picture List에선 CoreData에 저장여부가 중요하였다.

- ### 저장한 코어데이터를 따로 가지고 있기?
    
    저장 시점에서 코어데이터 entity를 따로 가지고 있으면 어떨까? 그렇다면 저장이 될 때 마다 coredata fetch를 하지 않아도 되서 효율적일 것 같다.
    
    ⇒ Reposity Scene에서 삭제가 되면 데이터의 업데이트를 알기 위해 어처피 fetch를 해와야 한다. 따라서 폐기.
    
- ### 결국 fetch all
    
    fetch all의 시간 복잡도는 O(n)이다. 배열을 전부 받아온다.
    
    문제는 배열을 탐색하거나 삭제할 때이다.
    
    이를 위해 해쉬를 사용하여 저장된 데이터를 삭제하거나 찾도록 해보자.
    
    해쉬의 탐색은 최악의 경우 O(n)이기 때문에 오래 걸려봤자 O(2n)이다.
    
- ### 비지니스 로직 변경
    
    ListVM과 RepoVM이 있다.
    
    ListVC에서 cell이 reuse 될 때, 버튼의 select 여부를 false로 바꿔준다.
    
    즉, 모델은 cell의 저장 여부를 알아야 한다는 것이다.
    
    따라서 이미지가 저장되고 삭제 되는 모든 과정에서 모델이 업데이트 되야 한다.
    
    VM은 저장과 삭제를 담당하고 가지고 있는 모델을 업데이트 시켜준다.
    
    여기까진 문제가 없다.
    
    RepoVM에서 삭제가 되었을 때, CoreData는 가지고 있던 entity를 삭제한다.
    
    ListVC에서 viewWillAppear를 통해 list를 다시 한번 업데이트 시켜준다.
    
- ### 새로운 데이터 구조 생성
    
    기존 ImageData와 CoreData의 저장 여부를 알수 있는 모델을 만들었다.
    
    ```swift
    struct SavableImageData {
        var imageData: ImageData
        var isSaved: Bool = false
        
        init(imageData: ImageData, isSaved: Bool = false) {
            self.imageData = imageData
            self.isSaved = isSaved
        }
    }
    ```
    
    이 데이터 모델은 ListVM을 통해 ListVC에 뿌려지고 cell에 data를 fetch하기 전에 coreData에 해당 id가 존재하는지 조회하여 저장 여부를 판단한다.   
    
    ```Swift
    // PictureListVM
    func image(at index: Int) -> SavableImageData {
        if CoreDataManager.shared.searchPicture(id: imageList[index].imageData.id) == nil {
            imageList[index].isSaved = false
            return imageList[index]
        }
        return imageList[index]
    }
    ```
<br>

* * *

## Invalid update 에러  

- 셀을 저장하고 삭제 할때 마다. 즉 collectionView를 reload 할 때마다 이와 같은 에러가 발생 했다.

```
[UICollectionView] Performing reloadData as a fallback

Invalid update: invalid number of items in section 0.
The number of items contained in an existing section after the update (8)
must be equal to the number of items contained in that section before the update (5) (...)
```

- 업데이트 이후 cell의 개수와 이전 cell의 개수가 다르다고 한다.
- 당연한거 아닌가?

### 핵심은 비동기

```swift
viewModel.imageListUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.picterestCollectionView.reloadData()
            }
        }

```

문제는 바로 저 main 쓰레드였다.

너무나 당연하게 뷰의 업데이트는 main 쓰레드에서 진행 해야 하는것이였다.

왜냐하면 우리가 보통 ImageList를 업데이트 하는 시점은 네트워크 통신이 끝나는 시점이다.

그 쓰레드 안에서 해당 모델을 업데이트 해주기 때문에 UI 업데이트를 위해서 main 쓰레드에서 작업을 한다.

하지만 coredata와 fileManager를 통해 데이터를 지워주는 행위와 collectoinView에 뿌려줄 데이터를 가지고 있는 ImageList를 지워주는 작업은 이미 메인 쓰레드에서 돌아가고 있다.

```swift
// ViewModel의 삭제
func deleteImage(at indexPath: IndexPath) {
        let item = imageList[indexPath.item]
        CoreDataManager.shared.delete(entity: item)
        PicterestFileManager.shared.deletePicture(fileName: item.id!)
        imageList.remove(at: indexPath.row)
        self.imageListUpdateAfterDelete()
    }

// View에서의 reloading
viewModel.imageListUpdateAfterDelete = { [weak self] in
            self?.picturesCollectionView.reloadData()
        }
```


<br>

* * *

# 📱실행 화면
| <center> 앱 진입과 사진 목록 </center> | <center> 사진 저장 </center> | <center> 리스트에서의 사진 삭제 </center> | <center> 저장소에서의 삭제 </center> | <center> 화면에서 사라진 사진 삭제 </center> |
| -------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------- |
| ![Simulator Screen Recording - iPhone 12 Pro - 2022-07-28 at 16 23 52](https://user-images.githubusercontent.com/36326157/181447565-463e58dd-8f4d-4b8f-b884-ef0cb34b3465.gif) | ![Simulator Screen Recording - iPhone 12 Pro - 2022-07-28 at 16 25 25](https://user-images.githubusercontent.com/36326157/181447585-c664be5a-7514-488b-befe-acbfc40eb242.gif) | ![Simulator Screen Recording - iPhone 12 Pro - 2022-07-28 at 16 37 33](https://user-images.githubusercontent.com/36326157/181448765-29801b54-1d2f-436d-a028-9ae4e1a4206c.gif) | ![Simulator Screen Recording - iPhone 12 Pro - 2022-07-28 at 16 26 06](https://user-images.githubusercontent.com/36326157/181447611-4f0e42eb-630e-4398-9938-269ea15eba2e.gif) | ![Simulator Screen Recording - iPhone 12 Pro - 2022-07-28 at 16 31 15](https://user-images.githubusercontent.com/36326157/181447629-ca3f5cd7-8258-4861-abef-c431755fff0c.gif)
<br>
