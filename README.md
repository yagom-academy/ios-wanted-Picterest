# 원티드 iOS 프리온보딩(with 야곰아카데미) -  ⌨ CustomKeyboard App <br />[2022.07.25 &#126; 2022.07.30]

# Team
## 팀원 소개 

| 커킴                              | 
| -------------------------------- |
|[<img src="https://github.com/kirkim.png" width="200">](https://github.com/kirkim)|
| 개발 |

# 프로젝트 소개

## 목표
> 서버 API를 이용하여 이미지를 받아와, 가변 세로 길이의 레이아웃으로 나타냅니다. 
> 원하는 사진을 선택해 저장하는 기능을 갖습니다.
> 아이폰, 세로 모드만 지원하는 앱입니다.
  
# 사용한 기술
`MVVM Pattern` `Delegate Pattern` `Code-based UI` `NSCache` `CoreData` `FileManager` `UICollectionViewLayout`
<details>
    <summary> <h1>🚥 MVVM Pattern</h1></summary>
    <h3> 1. MVVM 패턴을 사용한 이유</h3>
    <ul>
      <li> 이번 프로젝트는 이미지의 데이터를 최초로 네트워크통신을 이용해 가져옵니다. 그 후 추가 동작에 따라 `CoreData`를 이용하여 저장하고, 이미지파일을 `FileManager`를 이용하여 저장합니다.
이 모든 작업을 `View`에서 하기에는 무리가 있습니다. 그렇기 때문에 `ViewModel`을 만들어 데이터를 주고받는 역할을 하도록하고 추가로 이벤트를 처리하는 작업도 하도록 만들었습니다.</li>
    </ul>
    <h3> 2. 이번 프로젝트에서 사용한 곳</h3>
    <ul>
      <li>이번 프로젝트는 크게 화면이 `2개`입니다. 이 2개의 화면에만 ViewModel을 만들어주었습니다.</li>
      <ol>
        <li>ImageListViewController (첫번째 화면)</li>
        <li>SavedImageListViewController (두번째 화면)</li>
      </ol>
      <li>Alert와 같은 다소 작은 뷰들은 `delegate`를 이용하여 이벤트를 처리하도록 하였습니다.</li>
</details>

<details>
    <summary> <h1>🕹 Delegate Pattern</h1></summary>
    <h3> 1.딜리게이트 패턴을 사용한 이유</h3>
    <ul>
      <li>이번 프로젝트에서는 `RxSwift`를 사용하지 않고 만든 프로젝트입니다. 그래서 이벤트전달을 하기위해 떠오른 방법이 `노티피케이션`과 `델리게이트패턴`입니다. 노티피케이션은 이벤트의 전달과정을 파악하기가 쉽지않고 실수를 할 가능성이 큽니다. 반면에 델리게이트패턴을 뷰와 1대1 대응이 되도록 구현한다면 가독성과 유지보수가 좋아지게 됩니다.</li>
  </ul>
    <h3>2. 이번 프로젝트에서 사용한 곳</h3>
    <ol>
      <li>이미지저장버튼클릭이벤트</li>
  <li>셀추가버튼클릭이벤트</li>
  <li>커스텀레이아웃의 데이터소스(이미지 aspactRatiom, footer높이, 행갯수)</li> 
  <li>콜렉션뷰의 데이터소스(셀, 셀갯수, 섹션갯수, footer)</li>
  <li>CollectionDelegateFlowLayout(셀사이즈)</li>
  <li>셀삭제이벤트(UILongPressGestureRecognizer전달)</li>
  </ol>
</details>
