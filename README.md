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

## 사용한 기술
`MVVM Pattern` `Delegate Pattern` `Code-based UI` `NSCache` `CoreData` `FileManager` `UICollectionViewLayout`
  
# 사용한 기술
## MVVM Pattern
### 1. MVVM 패턴을 사용한 이유

- 이번 프로젝트는 이미지의 데이터를 최초로 네트워크통신을 이용해 가져옵니다. 그 후 추가 동작에 따라 `CoreData`를 이용하여 저장하고, 이미지파일을 `FileManager`를 이용하여 저장합니다.
이 모든 작업을 `View`에서 하기에는 무리가 있습니다. 그렇기 때문에 `ViewModel`을 만들어 데이터를 주고받는 역할을 하도록하고 추가로 이벤트를 처리하는 작업도 하도록 만들었습니다.

### 2. 이번 프로젝트에서 사용한 곳

## Delegate Pattern
  
### 1. 딜리게이트 패턴을 사용한 이유

### 2. 이번 프로젝트에서 사용한 곳

## 객체 역할 소개

### View 관련

| class / struct               | 역할                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `SceneDelegate`         | - 윈도우초기화 및 앱의 초기 권한 요청, 첫페이지 연결  |
| `ReviewListView`           | - 요청받아온 리뷰목록을 표시한다. <br />- 입력한 리뷰를 POST요청할 수 있다. |
| `ReviewWriteView`            | - 키보드로 입력된 값을 실시간으로 출력하여 보여준다. <br />- 키보드 return입력시 실시간내용을 ReviewListView로 보내준다. |
| `CustomKeyBoardStackView`            | - 한글쿼티키보드입력, shift, back, space, return 버튼기능을 한다. |

### Manger 관련

| class / struct               | 역할                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `NetworkManager`         | - 네트워크 통신을 하는 싱글턴 객체입니다. <br />- 제공된API로부터 리뷰목록을 GET요청하여 데이터를 받아온다. <br />- 제공된API로 리뷰를 POST요청하여 응답코드를 받을 수 있다. |
| `KeyboardEngine`      | - 문장의 끝글자와 입력글자의 조합역할을 하는 구조체입니다. <br />- 글자,space 입력시 아이폰의 입력과 동일한 규칙의 조합으로 출력해줍니다. <br />- back버튼 클릭시 글자,space의 입력과 동일한 규칙을 이용해 역방향으로 지워줍니다.<br />&nbsp;&nbsp;(단, ㅓ+ㅣ => ㅔ와 같은 아이폰에만 존재하는 규칙은 한번에 지워줌) |

# 고민한 부분

# 회고
