# 📸 Picterest

## 👨‍👩‍👦‍👦 팀원 소개

| <center>**에리얼**</center>   |
| -------------------------------------------------------- |
|  [<img src="https://github.com/BAEKYUJEONG.png" width="200">](https://github.com/BAEKYUJEONG)| 

<br>

## 🖥 프로젝트 소개
### **메인 화면에서 사진을 확인하고, 메모와 함께 사진을 저장하는 APP** 

- Tab Bar를 이용해 메인 페이지와 저장 페이지를 이동할 수 있습니다.
- 서버 API를 이용하여 이미지를 받아와, 가변 세로 길이의 레이아웃으로 나타냅니다.
- 원하는 사진을 선택해 메모와 함께 저장하는 기능을 갖습니다.
- 별 버튼을 누르면 저장이 되고, 다시 메인에서 채워져 있는 별을 누르면 삭제됩니다.
- 저장된 사진은 Long Press를 이용해 사진을 삭제할 수 있습니다.

<br>

## ⏱️ 개발 기간 및 사용 기술

- 개발 기간: 2022.07.25 ~ 2022.07.29 (1주)
- 사용 기술:  `UIKit`, `URLSession`, `TabBarController`, `NSCache`, `CoreData`, `FileManager`, `UICollectionViewFlowLayout`, `MVVM`

<br>

## ✏️ 주요 로직

### FileManager

- 사진 저장 시 image data를 File Path에 FileManager를 이용해 저장

- 사진 삭제 시 관련 데이터 삭제

```swift
class PhotoFileManager {
  // ...
    func createPhotoFile(_ image: UIImage, _ fileName: String) -> URL {
        let path = directoryPath.appendingPathComponent(fileName)

        if let data = image.jpegData(compressionQuality: 1) ?? image.pngData() {
            do {
                try data.write(to: path)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return path
    }
  // ...
}
```

```swift
class PhotoFileManager {
  // ...
    func deletePhotoFile(_ filePath: String) {
        guard let url = URL(string: filePath) else { return }
        
        do {
            try fileManager.removeItem(at: url)
        } catch let error {
            delegate?.fileManager(fileManager, error: FileError.canNotCreateDic, desc: error)
        }
    }
  // ...
}
```

<br>

### CoreData

CoreData를 이용한 사진 정보 저장 및 삭제 로직

```swift
class CoreDataManager {
  // ...
    func createSavePhoto(_ id: String, _ memo: String, _ originUrl: String, _ location: String, _ ratio: Double) {
        let entity = NSEntityDescription.entity(forEntityName: "SavePhoto", in: context)

        if let entity = entity {
            let savePhoto = NSManagedObject(entity: entity, insertInto: context)
            savePhoto.setValue(id, forKey: "id")
            savePhoto.setValue(memo, forKey: "memo")
            savePhoto.setValue(originUrl, forKey: "originUrl")
            savePhoto.setValue(location, forKey: "location")
            savePhoto.setValue(ratio, forKey: "ratio")

            saveContext()
        }
    }

  // ...
}
```

```swift
class CoreDataManager {
  // ...
    func deleteSavePhoto(_ entity: SavePhoto) {
        context.delete(entity)
        
        saveContext()
    }
  // ...
}
```

<br>

- 메인에서의 사진 저장, 삭제

```swift
    func savePhoto(_ photoData: Photo, _ memo: String) {
        let id = photoData.id
        let originUrl = photoData.urls.small
        let location = PhotoFileManager.shared.createPhotoFile(loadImage(originUrl), id).absoluteString
        let ratio = photoData.height / photoData.width
        
        CoreDataManager.shared.createSavePhoto(id, memo, originUrl, location, ratio)
    }
```

```swift
    func deletePhoto(_ photoData: Photo) {
        PhotoFileManager.shared.deletePhotoFile(photoData.urls.small)
        guard let entity = CoreDataManager.shared.searchSavePhoto(photoData.id) else { return }
        CoreDataManager.shared.deleteSavePhoto(entity)
    }
```

- 저장 페이지에서의 사진 삭제

```swift
    func deleteSavePhoto(_ savePhotoData: SavePhoto) {
        guard let location = savePhotoData.location else { return }
        PhotoFileManager.shared.deletePhotoFile(location)
        CoreDataManager.shared.deleteSavePhoto(savePhotoData)
    }
```

<br>

- searchSavePhoto 이용

  - Key Value를 이용한 Dictionary 형식으로 photoSet 구성

  - 사진 저장 유무에 따른 별 버튼 isSelected 유무 처리
  - 저장된 사진일 경우, 찾아서 delete 처리

```swift
     func searchSavePhoto(_ id: String) -> SavePhoto? {
        var photoSet: [String: SavePhoto] = [String: SavePhoto]()
        let request: NSFetchRequest<SavePhoto> = SavePhoto.fetchRequest()
        do {
            let photos = try context.fetch(request)
            photos.forEach { savePhoto in
                if let id = savePhoto.id {
                    photoSet[id] = savePhoto
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return photoSet[id]
    }
```

<br>

```swift
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(cellType: ImageCollectionViewCell.self, indexPath: indexPath)
        
        var isStarButtonSelected: Bool = false
        if CoreDataManager.shared.searchSavePhoto(photoList[indexPath.row].id) != nil {
            isStarButtonSelected = true
        }
      // ...
    }
```

```swift
    func deletePhoto(_ photoData: Photo) {
        PhotoFileManager.shared.deletePhotoFile(photoData.urls.small)
        guard let entity = CoreDataManager.shared.searchSavePhoto(photoData.id) else { return }
        CoreDataManager.shared.deleteSavePhoto(entity)
    }
```

<br>

## 📱 UI

| 사진 리스트 | 사진 저장 및 메모 입력 | 사진 삭제 | 메인에서의 사진 삭제 |
| :----: | :----: | :----: | :----: |
| ![Simulator Screen Recording - iPhone 11 - 2022-07-29 at 16 51 22](https://user-images.githubusercontent.com/48586081/181712487-a078a9ef-fe79-4da4-b08e-d95bc3a25e4f.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-07-29 at 17 12 59](https://user-images.githubusercontent.com/48586081/181715237-063761fd-b593-4966-ae90-10334bae98aa.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-07-29 at 17 08 27](https://user-images.githubusercontent.com/48586081/181714437-c8b463c5-1050-4e2f-a1aa-01a2cff49888.gif) | ![Simulator Screen Recording - iPhone 11 - 2022-07-29 at 17 28 19](https://user-images.githubusercontent.com/48586081/181717986-0d500882-418a-4008-9326-364e29798241.gif) |
