# 원티드 iOS 프리온보딩(with 야곰아카데미) - ⌨ CustomKeyboard App <br />[2022.07.25 &#126; 2022.07.30]

# Team

## 팀원 소개

| 커킴                                                                               |
| ---------------------------------------------------------------------------------- |
| [<img src="https://github.com/kirkim.png" width="200">](https://github.com/kirkim) |
| 개발                                                                               |

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
<details>
		<summary> <h1>NSCache</h1></summary>
    <h3> NSCache를 사용한 이유</h3>
    <ul>
      <li>앱의 동작중 가장 비용이 드는 동작은 아마도 네트워크통신일 것입니다. 그중에서도 이미지파일의 경우 JSON데이터에 비해 용량이 매우 큰편입니다. 그렇기 때문에 이미 한번 네트워크요청을 해서 받아온 이미지파일이라면 `NSCache`를 이용하여 임시로 저장하는 것이 효율적일 것 입니다.</li>
  </ul>
</details>
<details>
		<summary> <h1>CoreData</h1></summary>
    <h3> CoreData을 사용한 이유</h3>
    <ul>
      <li>이번에 다음과 같은 데이터를 사용하기 위해 사용했습니다.
				<ul>
					<li>ID</li>
					<li>메모</li>
					<li>사진의 원본 url</li>
					<li>사진저장위치(파일명)</li>
					<li>사진의 가로/세로 비율</li>
				</ul>
			</li>
			<li>UserDefault를 이용하여 저장할 수 도있지만 키충돌, 데이터량(약 4096개), 복잡한데이터타입을 저장하기에는 불편(단일데이터 저장적합)의 이유로 위의 데이터를 저장하기에는 적합하지가 않았습니다. 비교적 성능이빠르고 복잡한구조의 데이터를 저장할 수 있는 CoreData를 이용했습니다.</li>
  	</ul>
</details>
<details>
		<summary> <h1>FileManager</h1></summary>
    <h3> FileManager을 사용한 이유</h3>
    <ul>
      <li>이번 프로젝트는 이미지파일도 따로 저장합니다. 이미지파일은 용량이 크기 때문에 coreData에 같이 보관하기에는 무리가 있습니다. 그렇기 때문에 FileManager를 이용하여 앱에서 제공해주는 저장공간에 따로 저장하도록 구현했습니다.</li>
  	</ul>
</details>
<details>
		<summary> <h1>UICollectionViewLayout</h1></summary>
    <h3> UICollectionViewLayout을 사용한 이유</h3>
    <ul>
      <li>단순하게 콜렉션뷰라면 UICollectionViewFlowLayout을 이용하여 간단하게 구현할 수 있습니다.</li>
			<li>하지만 이번에 첫번째화면의 콜렉션뷰 같은 경우 사진의 비율에 따라 셀높이가 달라지게 됩니다.</li>
			<li>또한 각각의 행의 누적높이가 짧은쪽을 우선순위로 셀이 순차적으로 쌓이도록 구현해야 합니다. 이런식의 구현은 UICollectionViewFlowLayout만으로는 무리가 있습니다. 그렇기 때문에 커스텀레이아웃을 구현하게 되었습니다.</li>
  	</ul>
</details>

# 이번프로젝트의 특별한 컨셉

<details>
		<summary> <h1>코드의 Style수치값들을 하드코딩하지않고 Style파일에서 관리</h1></summary>
    <ul>
      <li>뷰의 frame, font, 각종사이즈, UIColor등등을 하드코딩하여 관리하게 되면 가독성이 떨어질 뿐만 아니라 코드수정이 힘들어 집니다.</li>
			<li>그래서 다음과 같이
    			```swift
    			enum CellStyle {
    					enum Math {
    							static let cornerRadius:CGFloat = Style.Math.windowWidth < 340 ? 10.0 : 15.0
    							static let topBarHeight:CGFloat = Style.Math.windowWidth < 340 ? 40.0 : 60.0
    							static let smallCellTopBarSidePadding:CGFloat = Style.Math.windowWidth < 340 ? 8.0 : 10.0
    							static let largeCellTopBarSidePadding:CGFloat = Style.Math.windowWidth < 340 ? 15.0 : 20.0
    							static let starButtonSize:CGFloat = topBarHeight/2
    							static let cellPadding:CGFloat = 10.0
    							static let cellWidth:CGFloat = Style.Math.windowWidth - 2*cellPadding
    					}
    					enum Font {
    							static let starButton:CGFloat = Style.Math.windowWidth < 340 ? 20.0 : 25.0
    					}
    					enum Color {
    							static let text:UIColor = Style.Color.text
    							static let topBarBackground:UIColor = .black.withAlphaComponent(0.6)
    					}
    				}
    				```
    		</li>

  	</ul>
</details>
