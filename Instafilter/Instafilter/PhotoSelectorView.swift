//
//  PhotoSelectorView.swift
//  Instafilter
//
//  Created by Dave Spina on 1/12/21.
//

import SwiftUI

struct PhotoSelectorView: View {
    @State private var image: Image?
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image") {
                showImagePicker = true
            }
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker()
        }
    }
}

struct PhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectorView()
    }
}
