//
//  ViewController.swift
//  FirstRxSwiftApp
//
//  Created by Mohamed osama on 17/03/2022.
//

import UIKit
import RxSwift


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController , let photoVC  = navVC.viewControllers.first as? PhotosCollectionCollectionViewController{
            
            photoVC.selectedPhotoAsObservable.subscribe { photo in
                DispatchQueue.main.async {
                    self.imageView.image = photo
                }
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Dispose")
            }.disposed(by: disposeBag)
            
        }
    }
    
    @IBAction func didFilterAction(_ sender: UIButton){
        
    }

}

