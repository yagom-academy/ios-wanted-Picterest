# Picterest - iOS
프리온보딩 세 번째 과제 📱

> Picterest는 Unsplash API를 통해 받아온 사진 Data들을 Custom Collection View에 나타내고, 사진을 저장했을 시 FileManager, CoreData에 각각의 데이터를 저장해서 관리하는 App입니다.

<br>

## 🧑‍💻 Developers
|Seocho(조성빈)|
|---|
|<img width = "200" alt= "서초(조성빈)" src = "https://user-images.githubusercontent.com/64088377/177668277-f9db3eb2-b252-4795-9eec-4f8cc5e10304.jpeg">|
<br>

## 👀 미리보기
|Basic function|
|---|
|<img width = "250" alt="page1-VoiceRecorder" src = "https://user-images.githubusercontent.com/73249915/181870210-c81a4277-78ab-4ff2-885f-54f47bb0274a.gif">|

<br>

## 🛠 개발환경
<img width="90" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/iOS-13.0+-silver"> <img width="90" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/Xcode-13.4-blue">

<br>

## 구현

<br>

|First Page|Second Page|
|-----|---|
|<br> 1. Unsplash API를 통해 사진 Data들을 가져옴 <br><br> 2. Custom Collection View에 각각의 사진의 해상도에 맞게 height값을 가변적으로 설정 <br><br> 3. 한 Row에 두 개의 cell의 yOffset 값을 비교해서 짧은 쪽에 다음 cell이 생성되도록 구현 <br><br> 4. 별 버튼을 클릭했을 때 사진을 FileManager, 그 외 데이터들을 CoreData에 저장 및 삭제 <br><br> 5. Infinite Scroll을 통해 Pagenation 구현 <br><br>|1. 저장되어있는 사진 데이터들을 Custom Collection View에 표현 (사진, 메모)  <br><br> 2. Long Press Gesture Recognizer를 이용해서 사진 삭제 구현 <br><br>|

<br>

## 🔀  Git Branch

개별 브랜치 관리 및 병합의 안정성을 위해 `Git Forking WorkFlow`를 적용했습니다.

Branch를 생성하기 전 Git Issues에 구현내용을 작성하고,

`<Prefix>/ <구현내용>` 의 양식에 따라 브랜치 명을 작성합니다.

#### 1️⃣ prefix

- `develop` : feature 브랜치에서 구현된 기능들이 merge될 브랜치. **default 브랜치이다.**
- `feature` : 기능을 개발하는 브랜치, 이슈별/작업별로 브랜치를 생성하여 기능을 개발한다
- `main` : 개발이 완료된 산출물이 저장될 공간
- `release` : 릴리즈를 준비하는 브랜치, 릴리즈 직전 QA 기간에 사용한다
- `bug` : 버그를 수정하는 브랜치
- `hotfix` : 정말 급하게, 제출 직전에 에러가 난 경우 사용하는 브렌치

#### 2️⃣ Git forking workflow 적용

1. 팀 프로젝트 repo를 포크한다.(이하 팀 repo)
2. 포크한 개인 repo(이하 개인 repo)를 clone한다.
3. 개인 repo에서 작업하고 개인 repo의 원격저장소로 push한다.
4. pull request를 한다
5. reviewer가 코드리뷰를 진행하고 이상 없을시 팀 repo로 merge 혹은 피드백을 준다.
5. pull 받아야 할 때에는 팀 repo에서 pull 받는다.

</br>

## ⚠️  Issue Naming Rule
#### 1️⃣ 기본 형식
`[<PREFIX>]: <Description>` 의 양식을 준수하되, Prefix는 협업하며 맞춰가기로 한다.

#### 2️⃣ 예시
```
[Feat]: 기능 구현
[Fix]: 원격/로컬 파일 동기화 안되던 버그 수정
```

#### 3️⃣ Prefix의 의미

```bash
[Feat] : 새로운 기능 구현
[Design] : just 화면. 레이아웃 조정
[Fix] : 버그, 오류 해결, 코드 수정
[Add] : Feat 이외의 부수적인 코드 추가, 라이브러리 추가, 새로운 View 생성
[Del] : 쓸모없는 코드, 주석 삭제
[Refactor] : 전면 수정이 있을 때 사용합니다
[Remove] : 파일 삭제
[Chore] : 그 이외의 잡일/ 버전 코드 수정, 패키지 구조 변경, 파일 이동, 파일이름 변경
[Docs] : README나 WIKI 등의 문서 개정
[Comment] : 필요한 주석 추가 및 변경
[Merge] : 머지
```

</br>

##  Commit Message Convention

#### 1️⃣ 기본 형식
prefix는 Issue에 있는 Prefix와 동일하게 사용한다.
```swift
[prefix]: 이슈제목
1. 이슈내용
2. 이슈내용
```

#### 2️⃣ 예시 : 아래와 같이 작성하도록 한다.

```swift
// 새로운 기능(Feat)을 구현한 경우
[Feat]: 기능 구현
1. TableView CRUD 구현
// 레이아웃(Design)을 구현한 경우
[Design]: 레이아웃 구현
1. page1 레이아웃 완료
```

</br>

