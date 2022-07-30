# 👨‍👩‍👦‍👦 팀원 소개
| <center>우지</center> |
| --------------------------------------------------------- |
|  [<img src="https://github.com/wooooozin.png" width="200">](https://github.com/wooooozin)| 
<br>

# 🖥 프로젝트 소개
### **애플리케이션 설명**
- 서버 API를 이용하여 이미지를 받아와, 가변 세로 길이의 레이아웃으로 나타냅니다.
- 원하는 사진을 선택해 저장하는 기능을 갖습니다.
- 첫번째 Image List Page에서 별 버튼을 누르면 메모 작성과 함께 사진 저장 및 다시 별을 누르면 삭제됩니다.
- 두번째 Saved Imaged Page에서 저장된 사진을 확인하고 Long PressGeture로 삭제할 수 있습니다.
<br>

### 실행 화면
| <center> 앱 진입과 사진 리스트 </center> | <center> 사진 및 메모 저장 </center> | <center> 사진 저장 취소 </center> | <center> 저장된 사진 삭제 </center> |
| ----------------------------------- | ---------------------------------| ------------------------------ | ------------------------------- | 
|![사진리스트](https://user-images.githubusercontent.com/95316662/181875841-a0b5a0e5-8360-426f-ad80-6dfdb87326fe.gif)|![사진저장](https://user-images.githubusercontent.com/95316662/181875842-82b40289-0f7a-44fe-96d5-34c5c610b58f.gif)|![저장취소](https://user-images.githubusercontent.com/95316662/181875844-c700b579-f9d9-4933-88f6-84ed194d93f1.gif)|![사진삭제](https://user-images.githubusercontent.com/95316662/181875845-8fc2edb8-e915-4c0b-a032-3e836a2f4062.gif)|
<br>


# ⏱️ 개발 기간 및 사용 기술
- 개발 기간: 2022.07.25 ~ 2022.07.30 (1주)
- 사용 기술:  `UIKit`, `URLSession`, `TabBarController`, `NSCache`,  `MVC`, `CoreData`, `FileManager`,  `UICollectionViewCustomLayout`
<br>

# 🦊 이슈 & 리팩토링
- ### 첫번째 화면에서 버튼으로 사진 저장 후 두번째 화면에서 업데이트 안되는 문제
```Text
- Saved Image View에서 coreData를 사용해 Cell 업데이트
- coreData를 업데이트 해주지 않아 저장은 되지만 리스트 업데이트는 안됨
- Saved Image View viewWillAppear에서 coreData fetch 및 collectioView reloaData 하는 것으로 해결 
- 마찬가지로 List Image View에서는 coreData와 PhotoModel을 비교해 저장버튼 상태를 업데이트하고 있어
  List Image View에서도 viewWillAppear에서 coreData fetch 및 collectioView reloaData 적용
```
<br>

- ### 첫번째 화면과 두번째 화면 너비 안맞는 문제
```Text
- List Image View에서는 CustomLayout에서 지정해준 cellPadding이 있어 더 좁게 보임
- Saved Image View CollectionViewFlowLayout cellPadding만큼 더해 Size 수정
```
<br>

- ### 어떻게 String 데이터를 효과적으로 관리할 수 있을까?
```Swift
// 변경 전 - 처음에는 구조체로 String값을 저장 후 사용하는 것으로 사용
struct CellName {
    static let photoListCell = "PhotoListCollectionViewCell"
    static let saveListCell = "PhotoSaveCollectionViewCell"
}

// 변경 후 - Protocol을 사용해 String 데이터를 사용하지 않도록 변경
protocol CellNamable {
    static var identifier: String { get }
}

extension CellNamable {
    static var identifier: String { String(describing: self) }
}
```
<br>

