//
//  PhotoCard.swift
//  Picterest
//
//  Created by 이다훈 on 2022/07/29.
//

import Foundation
import SwiftUI

struct PhotoCard: View {
    var body: some View {
        
        Rectangle().frame(width: 150, height: 150)
            .foregroundColor(Color.orange)
            .overlay(
                VStack {
                    HStack {
                        Button.init(action: {
                            print("ButtonTouched")
                        }, label: {
                            Image(systemName: "star")
                        })
                        .padding(.leading)
                        .foregroundColor(.yellow)
                        
                        Spacer()
                        
                        Text("n번째 사진")
                            .foregroundColor(.white)
                            .bold()
                            .padding([.top, .bottom, .trailing])
                        
                    }.background(Color.black.opacity(0.5))
                    Spacer()
                }
            ).cornerRadius(25, antialiased: true)
        
    }
}

struct PhotoCard_Preview: PreviewProvider {
    static var previews: some View {
        PhotoCard()
    }
}
