//
//  MCOmakeDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCOmakeDetailView: View {
    let achievement: Achievement
    private let maximumSize = UIScreen.main.fixedCoordinateSpace.bounds.size
    
    var body: some View {
        ScrollView(content: {
            if let image = achievement.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: maximumSize.width)
            }
        })
        .navigationTitle(achievement.name)
    }
}

struct MCOmakeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MCOmakeDetailView(achievement: Achievement.preview())
    }
}
