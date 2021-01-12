//
//  ActionSheetView.swift
//  Instafilter
//
//  Created by Dave Spina on 1/11/21.
//

import SwiftUI

struct ActionSheetView: View {
    @State private var showActionSheet = false
    @State private var backgroundColor: Color = Color.white
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(width: 300, height: 300, alignment:  .center)
            .background(backgroundColor)
            .onTapGesture {
                self.showActionSheet = true
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Color"), message: Text("Select a new color"), buttons: [
                    .default(Text("Green")) { self.backgroundColor = Color.green },
                    .default(Text("Red")) {
                            self.backgroundColor = Color.red
                    },
                        .default(Text("Blue")) { self.backgroundColor = Color.blue},
                        .cancel()
                ])
            }
    }
}

struct ActionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ActionSheetView()
    }
}
