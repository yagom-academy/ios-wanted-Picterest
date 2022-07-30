## 팀원 소개
- Kei
&nbsp;

<img src="https://i.pinimg.com/564x/ab/77/b6/ab77b685812966df28f059748d354ec2.jpg" width="150px" height="150px" title="Github_Logo"></img>
## 프로젝트 소개
![iOS 15.0+](https://img.shields.io/badge/iOS-15.0%2B-orange) ![Xcode 13.3](https://img.shields.io/badge/Xcode-13.3-blue)
- 서버 API를 이용하여 이미지를 받아와, 가변 세로 길이의 레이아웃으로 나타냅니다.
- 원하는 사진을 선택해 저장하는 기능을 갖습니다.

&nbsp;
## 개발 기간 및 사용 기술
- 개발 기간: 2022.07.25 ~ 2022.07.30
- 사용 기술 : `UIKit`, `URLSession`, `NSCahce`, `CoreData`, `FileManager`, `MVVM`

&nbsp;
## 기능 설명
- 첫번째 화면
  - 서버 API에서 이미지를 받아와 2개의 열로 나누어 가변형 높이의 cell에 이미지를 표시합니다
  - 두 열중 길이가 짧은 열의 아래쪽으로 새로운 사진을 배치합니다
  - 한 페이지에는 15개의 사진을 배치하고 스크롤하면 다음 페이지 이미지를 가져옵니다
  - 우상단 라벨에는 사진의 index를 표시합니다
  - 좌상단의 별 모양 버튼을 누르면 alert이 표시되고 텍스트를 입력하여 메모와 함께 저장합니다
  - FileManager를 통해 사진을 저장하고 CoreData에 사진과 관련된 정보를 저장합니다

- 두번째 화면
  - 좌상단에 별 모양 아이콘이 표시되고 우상단에는 메모를 배치합니다
  - 사진을 길게 누르면 삭제할 것인지 묻는 alert이 표시됩니다
  - 삭제 시 관련 정보와 사진 파일 모두를 지웁니다

&nbsp;
  
| 화면 설명 |
| :---------------------------: |
| <img src="https://user-images.githubusercontent.com/95616104/181917793-da4c91ed-15b0-41e8-99fe-6741c7ee578d.gif" height="400px"> |

&nbsp;


## 학습 내용
1. CoreData
- UserDefault와 FileManager를 자주 사용했었고 CoreData는 한 번 정도 진행해 본 경험이 있었습니다. 그 당시에는 UserDefault의 경우 app setting 같은 간단한 정보를 저장하기에 적합하고 CoreData는 복잡하고 큰 정보를 저장하는 데이터 베이스라고 생각하고 넘어갔는데 학습활동 시간을 통해서 CoreData는 DB도 아니고 데이터를 유지하기 위한 API도 아닌 객체 그래프를 관리하는 프레임워크인 것을 알게 되었습니다. 이 객체 그래프를 디스크에 저장해서 Persistence 기능을 사용할 수 있게 되는 것이었습니다. 프로젝트에 CoreData를 적용하면서 추가된 파일에 @nonobjc, @NSManaged 키워드는 무엇을 의미하는 것인지 등에 대해서도 계속 공부할예정입니다 
<img height="300px" alt="image" src="https://user-images.githubusercontent.com/95616104/181918537-8e92f58f-9559-4fb1-8893-863e6a69615e.png">

2. UICollectionViewCustomLayout
- 그동안 UICollectionView의 기본 layout 설정만 변경해서 사용해보았는데 이번에 raywenderich의 pinterest layout으로 custom으로 layout을 사용해볼 수 있는 기회가 되었습니다 
```swift
class PicterestLayout: UICollectionViewFlowLayout {
    
    // delegate로 ViewController 를 나타냅니다.
    weak var delegate: PinterestLayoutDelegate?
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // 1. 콜렉션 뷰의 콘텐츠 사이즈를 지정합니다.
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // 다시 레이아웃을 계산할 필요가 없도록 메모리에 저장합니다.
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // 2. 콜렉션 뷰가 처음 초기화되거나 뷰가 변경될 떄 실행됩니다. 이 메서드에서 레이아웃을
    //    미리 계산하여 메모리에 적재하고, 필요할 때마다 효율적으로 접근할 수 있도록 구현해야 합니다.
    override func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else { return }
        
        let numberOfColumns: Int = 2 // 한 행의 아이템 갯수
        let cellPadding: CGFloat = 5
        let cellWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        
        let xOffSet: [CGFloat] = [0, cellWidth] // cell 의 x 위치를 나타내는 배열
        var yOffSet: [CGFloat] = .init(repeating: 0, count: numberOfColumns) // // cell 의 y 위치를 나타내는 배열
        
        var column: Int = 0 // 현재 행의 위치
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            // IndexPath 에 맞는 셀의 크기, 위치를 계산합니다.
            let indexPath = IndexPath(item: item, section: 0)
            let imageHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + imageHeight
            
            let frame = CGRect(x: xOffSet[column],
                               y: yOffSet[column],
                               width: cellWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 위에서 계산한 Frame 을 기반으로 cache 에 들어갈 레이아웃 정보를 추가합니다.
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 콜렉션 뷰의 contentHeight 를 다시 지정합니다.
            contentHeight = max(contentHeight, frame.maxY)
            yOffSet[column] = yOffSet[column] + height
            
            // 다른 이미지 크기로 인해서, 한쪽 열에만 이미지가 추가되는 것을 방지합니다.
            column = yOffSet[0] > yOffSet[1] ? 1 : 0
        }
    }
    
    // 3. 모든 셀과 보충 뷰의 레이아웃 정보를 리턴합니다. 화면 표시 영역 기반(Rect)의 요청이 들어올 때 사용합니다.
        override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
            
            for attributes in cache {
                if attributes.frame.intersects(rect) { // 셀 frame 과 요청 Rect 가 교차한다면, 리턴 값에 추가합니다.
                    visibleLayoutAttributes.append(attributes)
                }
            }
            
            return visibleLayoutAttributes
        }
        
        // 4. 모든 셀의 레이아웃 정보를 리턴합니다. IndexPath 로 요청이 들어올 때 이 메서드를 사용합니다.
        override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            return cache[indexPath.item]
        }
}
```
