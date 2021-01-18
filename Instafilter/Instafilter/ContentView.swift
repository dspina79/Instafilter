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
    @State var filterRoundness = 0.0
    @State var filterSharpness = 1.0
    
    @State var showImagePicker = false
    @State var showActionSheet = false
    @State var inputImage: UIImage?
    @State var processedUIImage: UIImage?
    
    @State private var showNoImageMessage = false
    @State private var currentFilterName = "Sepia"
    
    @State var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        let sharpness = Binding<Double> (
            get: {
                return self.filterSharpness
            },
            set: {
                self.filterSharpness = $0
                applyProcessing()
            }
        )
        let roundness = Binding<Double> (
            get: {
                self.filterRoundness
            },
            set: {
                self.filterRoundness = $0
                self.applyProcessing()
            }
        )
        
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
                    Text("Intensity")
                    Slider(value: intensity)
                }
                .padding(.vertical)
                
                HStack {
                    Text("Roundness")
                    Slider(value: roundness)
                }
                .padding(.vertical)
                
                HStack {
                    Text("Sharpness")
                    Slider(value: sharpness)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Filter - \(self.currentFilterName)  - Change") {
                        self.showActionSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard let processedUIImage = self.processedUIImage else {
                            self.showNoImageMessage = true
                            return }
                        
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
                                    setFilter(CIFilter.crystallize(), "Crystallize")
                                },
                                .default(Text("Edges")) {
                                    setFilter(CIFilter.edges(), "Edges")
                                },
                                .default(Text("Gaussian Blur")) {
                                    setFilter(CIFilter.gaussianBlur(), "Gaussian Blur")
                                },
                                .default(Text("Pixellate")) {
                                    self.setFilter(CIFilter.pixellate(), "Pixellate")
                                },
                                .default(Text("Sepia")) {
                                    self.setFilter(CIFilter.sepiaTone(), "Sepia")
                                },
                                .default(Text("Unsharp Mask")) {
                                    self.setFilter(CIFilter.unsharpMask(), "Unsharp Mask")
                                },
                                .default(Text("Vignette")) {
                                    self.setFilter(CIFilter.vignette(), "Vignette")
                                },
                    .cancel()
                ]
                )
            }
            .alert(isPresented: $showNoImageMessage) {
                Alert.init(title: Text("Image Missing"), message: Text("No image has been selected or loaded."), dismissButton: .default(Text("Ok")))
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
            currentFilter.setValue(filterRoundness * 200.0, forKey: kCIInputRadiusKey)
        }
        
        if filterKeys.contains(kCIInputWidthKey) {
            currentFilter.setValue(filterRoundness, forKey: kCIInputWidthKey)
        }
        
        if filterKeys.contains(kCIInputSharpnessKey) {
            currentFilter.setValue(filterSharpness * 100.0, forKey: kCIInputSharpnessKey)
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
    
    func setFilter(_ filter: CIFilter, _ filterName: String) {
        self.currentFilter = filter
        self.currentFilterName = filterName
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
