//
//  MCOmakeDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCOmakeDetailView: View {
    @State var isPresented = false
    
    let achievement: Achievement
    private let maximumSize = UIScreen.main.fixedCoordinateSpace.bounds.size
    
    var body: some View {
        ScrollView(content: {
            if let image = achievement.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
        })
        .navigationTitle(achievement.name)
        .navigationBarItems(trailing: Button(action: {
            self.isPresented.toggle()
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .imageScale(.large)
        }))
        .sheet(isPresented: $isPresented, content: {
            if let image = achievement.image {
                ActivityViewController(activityItems: [image])
            }
        })
    }
}

struct MCOmakeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MCOmakeDetailView(achievement: Achievement.preview())
    }
}
