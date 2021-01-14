//
//  CoreImageView.swift
//  Instafilter
//
//  Created by Dave Spina on 1/12/21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CoreImageView: View {
    @State private var image: Image?
   
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }.onAppear(perform: loadImage)
    }
    
    func loadImage() {
        // start with the UIImage (a powerful image type)
        guard let inputImage = UIImage(named: "banff") else {
            return
        }
        // conver the image to CI Image
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let sepiaFilter = CIFilter.sepiaTone()
        sepiaFilter.inputImage = beginImage
        sepiaFilter.intensity = 1
        
        let pixelateFilter = CIFilter.pixellate()
        pixelateFilter.inputImage = beginImage
        pixelateFilter.scale = 100
        
        let zoomBlurFilter = CIFilter.zoomBlur()
        zoomBlurFilter.amount = 10
        zoomBlurFilter.inputImage = beginImage
        
        let motionBlurFilter = CIFilter.motionBlur()
        motionBlurFilter.angle = 20
        motionBlurFilter.inputImage = beginImage
        
        let hexPixelateFilter = CIFilter.hexagonalPixellate()
        hexPixelateFilter.inputImage = beginImage
        hexPixelateFilter.scale = 10
        
        guard let twirlFilter = CIFilter(name: "CITwirlDistortion") else {
            return
        }
        
        twirlFilter.setValue(beginImage, forKey: kCIInputImageKey)
        twirlFilter.setValue(2000, forKey: kCIInputRadiusKey)
        twirlFilter.setValue(CIVector(x: inputImage.size.width / 2, y: inputImage.size.height / 2), forKey: kCIInputCenterKey)
        
        guard let outputImage = hexPixelateFilter.outputImage else {
            return
        }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
        
    }
}

struct CoreImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoreImageView()
    }
}
