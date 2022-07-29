//
//  ViewController.swift
//  Picterest
//

import UIKit

class ImagesViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = ImagesViewModel()
    private let fileManager = FileManager.default
    private let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var picDownURL = documentURL.appendingPathComponent("PicDownFolder")
    
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
        initFolder()
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
    
    func showAlert(image: UIImage, imageID: String){
        let downAlert = UIAlertController(title: "사진 다운로드", message: "메모를 작성하고 OK를 누르면 다운됩니다.", preferredStyle: .alert)
        downAlert.addTextField { textField in
            textField.placeholder = "사진에 남길 메모를 적어주세요!"
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { ok in
            self.createFile(image, imageID)
            guard let memo = downAlert.textFields?.first?.text else {
                return
            }
            print("Down, 메모:", memo)
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

// MARK: - 이미지파일매니저 관련
extension ImagesViewController {
    func initFolder() {
        
        //사진다운받을 파일 "picDownFolder"가 없으면 가드문 그냥 통과후 createFolder 함수 실행
        guard !fileManager.fileExists(atPath: picDownURL.path) else { return }
        
        //없으면 picDownFolder 생성
        createFolder()
    }
    
    func createFolder() {
        print("사진 다운받은 폴더", picDownURL)
        do {
            try fileManager.createDirectory(at: picDownURL, withIntermediateDirectories: false)
        } catch {
            print(error)
        }
    }
    
    func createFile(_ image: UIImage, _ imageID: String) {
        print(image)
        let imageName = "\(imageID).png"
        
        //저장경로 -> picDownURL
        var folderPath = URL(fileURLWithPath: picDownURL.path)
        folderPath.appendPathComponent((imageName as NSString).lastPathComponent)
        
        if !fileManager.fileExists(atPath: folderPath.path) {
            fileManager.createFile(atPath: folderPath.path, contents: image.pngData(), attributes: nil)
        }
    }

}

// MARK: - CollectionView DataSoucrce
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else { return  ImageCell() }
        
        cell.configure(index: indexPath, data: viewModel.imageData(indexPath: indexPath))
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagedDataCount
    }
}

