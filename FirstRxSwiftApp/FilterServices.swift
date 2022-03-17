//
//  FilterServices.swift
//  FirstRxSwiftApp
//
//  Created by Mohamed osama on 18/03/2022.
//

import Foundation
import CoreImage
import UIKit

class FilterServices{
    
    private var context: CIContext
    
    init(){
        self.context = CIContext()
    }
    
    
    func applyFilter(with inputImage: UIImage , completion: @escaping (UIImage) -> ()){
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage){
            filter.setValue(sourceImage, forKey: kCIInputWidthKey)
            
            if let ciImg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent){
                let processedImage = UIImage(ciImage: ciImg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
        
    }
}
