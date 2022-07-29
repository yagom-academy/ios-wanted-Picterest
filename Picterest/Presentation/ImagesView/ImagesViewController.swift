//
//  ViewController.swift
//  Picterest
//

import UIKit
import CoreData

class ImagesViewController: UIViewController {
    
    // MARK: - Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Data for the table
    var items:[ImageInfoEntity]?
    
    private let viewModel = ImagesViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let picterestLayout = PicterestLayout()
        picterestLayout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: picterestLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreData 테스트
        fetchImageInfoEntity()
        
        fetchData()
        configureUI()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods
extension ImagesViewController {
    
    private func fetchImageInfoEntity() {
        //CoreData로 부터 패치해서 collectionView에 display -> 추후 SavedView에
        do {
            self.items = try context.fetch(ImageInfoEntity.fetchRequest())
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch {
            
        }
    }
    
    private func fetchData() {
        viewModel.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func configureUI() {
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension ImagesViewController: PicterstLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return viewModel.imageSize(indexPath)
    }
}

extension ImagesViewController: CollectionViewCellDelegate {
    
    func showAlert(image: UIImage, imageID: String, index: IndexPath){
        let downAlert = UIAlertController(title: "사진 다운로드", message: "메모를 작성하고 OK를 누르면 다운됩니다.", preferredStyle: .alert)
        downAlert.addTextField { textField in
            textField.placeholder = "사진에 남길 메모를 적어주세요!"
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { ok in
            self.viewModel.saveImage(index: index) { [weak self] result in
                switch result {
                case.success():
                    self?.collectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            guard let memo = downAlert.textFields?.first?.text else {
                return
            }
            print("Down, 메모:", memo)
            
            //create ImageInfoEntity Object
            let newImageInfoEntity = ImageInfoEntity(context: self.context)
            newImageInfoEntity.id = imageID
            newImageInfoEntity.memo = memo
//            newImageInfoEntity.savePath = 로컬 파일 저장 위치
//            newImageInfoEntity.originUrl = 원본 오리지날 path
            
            //Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            //Re-fetch the Data
            self.fetchImageInfoEntity()
            
            //지우는 건  SavedView에서 test
            //사진을 길게 눌러 삭제할 수 있습니다.
            //Alert을 통해 삭제 여부를 재확인합니다.
            //삭제 시, 관련 정보와 사진 파일 모두를 지웁니다.
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { cancel in
            //TODO cancel 누르면 토글 해제
            
            print("다운 취소 및 토글 해제")
            
        }
        
        downAlert.addAction(cancel)
        downAlert.addAction(ok)
        self.present(downAlert, animated: true, completion: nil)
    }
}

// MARK: - CollectionView DataSoucrce
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else { return  ImageCell()
        }
        
        cell.configure(index: indexPath, data: viewModel.imageData(indexPath: indexPath))
        cell.delegate = self
        
//        CoreData-> 나중에 SavedImage Tab에서 적용해보기
//        let imageInfoEntity = self.items[indexPath.row]
//        cell에 세팅 cell.memo.text = imageInfoEntity.memo
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagedDataCount
    }
}

