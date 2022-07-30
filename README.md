
# Picterest 
![iOS 15.0+](https://img.shields.io/badge/iOS-15.0%2B-orange) ![Xcode 13.3](https://img.shields.io/badge/Xcode-13.3-blue)

- API를 통해 전달받은 이미지의 크기 비율로 이미지를 나타내는 화면 구성
- 사진을 메모와 함께 이미지로 저장하고 불러올수 있는 기능
- 앱 종료 이후에도 저장된 이미지를 볼수 있도록 만든 어플리케이션

## 팀원 소개 
| [@호이](https://github.com/JangJuMyeong)| 
| ------------------------------------------------------------------------------------------ | 
| <img src="https://cphoto.asiae.co.kr/listimglink/6/2013051007205672589_1.jpg" width="100" height="100"/> |


## ⏱️ 개발 기간 및 사용 기술
- 개발 기간: 2022.07.25 ~ 2022.07.30 (1주)
- 사용 기술:  `UIKit`, `URLSession`, `NSCache`, `CoreData`, `FileManger`, `NotificationCenter`, `MVVM`

## 🛠 기능 구현 
### Images 화면
| **로드 완료 된 Images 화면**|**사진 및 메모 저장**|**사진 및 메모 저장 취소**|
|---|---|---|
|<img src="https://user-images.githubusercontent.com/66667091/181875407-7b8783c3-bcb2-4ef7-b664-f3a64aead6ab.gif" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/66667091/181875347-694d0916-0cbc-4835-956a-3659d0d6ecc3.gif" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/66667091/181875623-b961b95a-274e-427f-811e-cc05ad6c5a5f.gif" width="200" height="400"/>|

- [x] 서버 API에서 사진 리스트를 가져와 사진 비율에 맞게 화면에 표시합니다.
- [x] 내가 저장한 사진인지, 몇번째 사진인지를 표시합니다.
- [x] 별 버튼을 통하여 사진과 메모를 저장할수있으며 저장된 사진은 삭제할수 있습니다.

### Saved 화면
| **로컬에서 로드한 화면**|**사진 및 메모 삭제**|
|---|---|
|<img src="https://user-images.githubusercontent.com/66667091/181877132-3bda03a7-16ae-4554-ad59-317651505872.gif" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/66667091/181877112-ce80c54c-eb57-4cfa-99d6-3d8860c6cad1.gif" width="200" height="400"/>|



- [x] FileMager에 저장된 사진을 가져오고 Core Data에 저장된 이미지의 정보를 가져와 화면에 나타냅니다.
- [x] 내가 저장할때 작성한 메모를 화면에 표시합니다.
- [x] 별 버튼과 롱프레스를 통해 저장된 사진은 삭제할수 있습니다.

### 데이터 변화 전달
| **Imges 저장 → Saved 화면**|**Imges 삭제 → Saved 화면**| **Saved 삭제 → Imges 화면**|
|---|---|---|
|<img src="https://user-images.githubusercontent.com/66667091/181877594-374ae7bf-2f7f-4757-8ff8-20b900b17c6b.gif" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/66667091/181877580-52105df7-022c-4fb6-97ef-cde3ecaff847.gif" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/66667091/181877564-ec6118a5-fd63-4bfe-be95-a9acc31d161c.gif" width="200" height="400"/>|



- [x] Images화면에서 저장 / 삭제시 Save화면의 리스트를 최신화 합니다.
- [x] Saved화면에서 삭제시의 Images화면의 리스트를 최신화 합니다.


## 🧾 설계

### 네트워크

<img width="638" alt="스크린샷 2022-07-30 오후 5 11 39" src="https://user-images.githubusercontent.com/66667091/181891004-6be6b4d2-8929-44e7-be01-ac83a8310d98.png">

#### - 네트워크의 핵심 모듈
- [x] Endpoint: path, queryPramameters, bodyParameter등의 데이터 객체
- [x] Provider: URLSession, DataTask를 이용하여 network호출이 이루어 지는 곳

### 앱 설계
<img width="710" alt="스크린샷 2022-07-30 오후 6 21 36" src="https://user-images.githubusercontent.com/66667091/181904148-d294847d-0a35-48c1-aead-a406a1a1547c.png">


## 🔀 역할 분배

### View 관련

| class / struct               | 역할                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `ImagesViewController`         | - API에서 받아온 사진을 비율에 맞게 CollectionView에 보여준다.  |
| `ImagesViewModel`           | - API에서 받아온 정보들을 PhotoInfo로 MediaInfoRepository를 통한 이미지 파일을 저장 / 삭제 한다.|
| `SavedViewController`            | - 로컬에 저장된 이미지와 정보들을 비율에 맞게 CollectionViewdp 보여준다.|
| `SavedViewModel`            | - MediaInfoRepository를 통해 ImageData를 ImageInfo로 가공하고 이미지 파일을 삭제 한다.|
| `PhotoCollectionViewLayout`            | - PhotoCollectionView의 커스텀 레이아웃으로 사진들을 비율에 맞게 CollectionView에 보여주도록 한다.|
| `SavedCollectionViewLayout`            | - SavedCollectionView 커스텀 레이아웃으로 사진들을 비율에 맞게 CollectionView에 보여주도록 한다. |

### Manger 관련

| class / struct               | 역할                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `ProviderImpl`         | - 네트워크 통신을 하는 객체 <br />- 제공된API로부터 사진 리스트를 GET요청하여 데이터를 받아온다.|
| `ImageDataCoreDataStorage`      | - 사용자가 저장한 이미지의 정보와 메모를 저장, 불러오기, 삭제한다. |
| `ImageFileManger`         | - 사용자가 저장한 이미지를 로컬에 저장, 불러오기 ,삭제한다.|
| `MediaInfoRepository`      | - 네트워크, 로컬 데이터를 관리하는 객체입니다. <br />- 이 객체를 통해 ViewModel에서는 비지니스 로직에 집중하도록 합니다.|



