//
//  MCChallengeDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCChallengeDetailView: View {
    let challenge: Challenge
    
    var body: some View {
        ScrollView(content: {
            VStack(alignment: .leading, spacing: 5, content: {
                MCCalendarView(date: challenge.date ?? Date())
                
                challenge.id.map({
                    Text($0.uuidString)
                })
                    .font(.caption)
                    .foregroundColor(.gray)
            
                Spacer(minLength: 30)
                
                Button(action: {
                }, label: {
                    HStack(content: {
                        Image(systemName: "pencil.circle")
                        Text("Edit")
                            .fontWeight(.semibold)
                    })
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .foregroundColor(.green)
                })
                
                Button(action: {
                }, label: {
                    HStack(content: {
                        Image(systemName: "trash.circle")
                        Text("Remove")
                            .fontWeight(.semibold)
                    })
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .foregroundColor(.red)
                        .opacity(0.5)
                })
            })
                .padding()
        })
            .navigationBarTitle(Text(challenge.name ?? "Untitled"))
    }
}

struct MCChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let challenge = Challenge.empty
        challenge.id = UUID()
        challenge.name = "Preview"
        challenge.date = Date()
        
        return MCChallengeDetailView(challenge: challenge)
    }
}
