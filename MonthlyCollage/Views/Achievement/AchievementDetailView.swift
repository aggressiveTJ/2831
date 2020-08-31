//
//  AchievementDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct AchievementDetailView: View {
    @State var isPresented = false
    
    let achievement: Achievement
    private let maximumSize = UIScreen.main.fixedCoordinateSpace.bounds.size
    
    @State var image: Image?
    var body: some View {
        ScrollView(content: {
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        })
        .navigationTitle(achievement.title)
        .navigationBarItems(trailing: Button(action: {
            self.isPresented.toggle()
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .imageScale(.large)
        }))
        .sheet(isPresented: $isPresented, content: {
            if let image = achievement.collageImage {
                ActivityViewController(activityItems: [image])
            }
        })
        .onAppear(perform: {
            if let collageImage = achievement.collageImage {
                self.image = Image(uiImage: collageImage)
            } else {
                self.image = Image(systemName: "questionmark.square")
            }
        })
    }
}

struct AchievementDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementDetailView(achievement: Achievement.preview)
    }
}
