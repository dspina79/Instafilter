//
//  CustomBindingView.swift
//  Instafilter
//
//  Created by Dave Spina on 1/11/21.
//

import SwiftUI

struct CustomBindingView: View {
    @State private var blurAmount: CGFloat = 0
    var body: some View {
        // this is the custom binding below
        let blur = Binding<CGFloat>(
            get: {
                self.blurAmount
            },
            set: {
                self.blurAmount = $0
                print("The blur amount is \(self.blurAmount)")
            }
        )
        
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .blur(radius: blurAmount)
        
            Slider(value: blur, in: 0...20)
        }
    }
}

struct CustomBindingView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBindingView()
    }
}
