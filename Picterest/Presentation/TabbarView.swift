//
//  TabbarView.swift
//  Picterest
//
//  Created by 이다훈 on 2022/07/29.
//

import Foundation
import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            PhotoCollectionView()
                .tabItem {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                    Text("Images")
                }
            PhotoFavoriteView()
                .tabItem {
                    Image(systemName: "star.bubble")
                    Text("Saved")
                }
        }
    }
}

