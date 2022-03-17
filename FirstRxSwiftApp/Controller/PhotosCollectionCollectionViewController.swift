//
//  PhotosCollectionCollectionViewController.swift
//  FirstRxSwiftApp
//
//  Created by Mohamed osama on 17/03/2022.
//

import UIKit
import Photos
import RxSwift



class PhotosCollectionCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout{
 

    private var assets = [PHAsset]()
    
    private var selectedSubject = PublishSubject<UIImage>()
    
    var selectedPhotoAsObservable: Observable<UIImage>{
        
        return selectedSubject.asObservable()
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        populatePhoto()
    }


    private func populatePhoto(){
        
        PHPhotoLibrary.requestAuthorization {[weak self] status in
            if status == .authorized{
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                    
                assets.enumerateObjects{ (object , count , stop) in
                    
                    self?.assets.append(object)
                }
                self?.assets.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
        
        let asset = assets[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, error in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        return cell
    }
   
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width / 4.0
        
        let height: CGFloat = 100
        
        return CGSize(width: width, height: height)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let asset = assets[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil) {[weak self] image, info in
            
            guard let info = info else {return}
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Int
            
            if isDegradedImage != 0{
                if let image = image{
                    self?.selectedSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
 
    
}
