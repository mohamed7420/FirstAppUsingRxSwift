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
    
    static let shared = FilterServices()
    
    private var context: CIContext
    
    private init(){
        self.context = CIContext()
    }
    
    
    func applyFilter(with inputImage: UIImage , completion: @escaping (UIImage) -> ()){
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage){
            filter.setValue(sourceImage, forKey: kCIInputWidthKey)
            
            if let cgImg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent){
                
                let processedImage = UIImage(cgImage: cgImg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
        
    }
}
