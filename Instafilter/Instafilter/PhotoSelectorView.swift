//
//  PhotoSelectorView.swift
//  Instafilter
//
//  Created by Dave Spina on 1/12/21.
//

import SwiftUI

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save Complete")
    }
}

struct PhotoSelectorView: View {
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image") {
                showImagePicker = true
            }
        }.sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let sepiaFilter = CIFilter.sepiaTone()
        sepiaFilter.inputImage = beginImage
        sepiaFilter.intensity = 1
        
        guard let outputImage = sepiaFilter.outputImage else {
            return
        }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: uiImage)
        }
        

    }
}

struct PhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectorView()
    }
}
