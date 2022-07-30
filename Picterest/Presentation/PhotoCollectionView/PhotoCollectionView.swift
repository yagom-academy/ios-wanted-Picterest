//
//  PhotoCollectionView.swift
//  Picterest
//
//  Created by 이다훈 on 2022/07/29.
//

import Foundation
import SwiftUI

struct PhotoCollectionView: View {
    
    let columns = [GridItem(),
                   GridItem()]
    
    var body: some View {
        ScrollView {
            Text("PhotoCollectionView")
            LazyVGrid(columns: columns, alignment: .center, spacing: 5 ) {
                PhotoCard()
                PhotoCard()
                PhotoCard()
            }
        }
    }
    
}

struct PhotoCollectionView_Preview: PreviewProvider {
    static var previews: some View {
        PhotoCollectionView()
    }
}
