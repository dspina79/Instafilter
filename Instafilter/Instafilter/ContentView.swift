//
//  ContentView.swift
//  Instafilter
//
//  Created by Dave Spina on 1/11/21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State var image: Image?
    @State var filterIntensity = 0.5
    @State var showImagePicker = false
    @State var showActionSheet = false
    @State var inputImage: UIImage?
    @State var processedUIImage: UIImage?
    
    @State var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        let intensity = Binding<Double> (
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        // need the return for processing
        return NavigationView {
            VStack {
                ZStack {
                Rectangle()
                    .fill(Color.secondary)
                
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }.onTapGesture {
                    self.showImagePicker = true
                    
                }
                
                HStack {
                    Slider(value: intensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        self.showActionSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard let processedUIImage = self.processedUIImage else { return }
                        
                        let imageSaver = NewImageSaver()
                        imageSaver.writeImageToPhotoAlbum(image: processedUIImage)
                        imageSaver.successHandler = {
                            print("Success")
                        }
                        imageSaver.errorHandler = {
                            print("There was an error \($0.localizedDescription)")
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle(Text("Instafilter"))
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                NewImagePicker(image: $inputImage)
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Select a Filter"), buttons: [
                                .default(Text("Crystallize")) {
                                    setFilter(CIFilter.crystallize())
                                },
                                .default(Text("Edges")) {
                                    setFilter(CIFilter.edges())
                                },
                                .default(Text("Gaussian Blur")) {
                                    setFilter(CIFilter.gaussianBlur())
                                },
                                .default(Text("Pixellate")) {
                                    self.setFilter(CIFilter.pixellate())
                                },
                                .default(Text("Sepia")) {
                                    self.setFilter(CIFilter.sepiaTone())
                                },
                                .default(Text("Unsharp Mask")) {
                                    self.setFilter(CIFilter.unsharpMask())
                                },
                                .default(Text("Vignette")) {
                                    self.setFilter(CIFilter.vignette())
                                },
                    .cancel()
                ]
                )
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        //image = Image(uiImage: inputImage)
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let filterKeys = currentFilter.inputKeys
        if filterKeys.contains(kCIInputIntensityKey) {
                currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if filterKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200.0, forKey: kCIInputRadiusKey)
        }
        if filterKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10.0, forKey: kCIInputScaleKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImg =  context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImg)
            image = Image(uiImage: uiImage)
            self.processedUIImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        self.currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
