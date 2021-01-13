//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Dave Spina on 1/12/21.
//

import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    typealias UIViewControllerType = UIImagePickerController
    
}
