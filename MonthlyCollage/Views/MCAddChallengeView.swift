//
//  MCAddChallengeView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCAddChallengeView: View {
    @Binding var challengeName: String
    @Environment(\.presentationMode) var presentationMode
    
    private let challengeUUID = UUID()
    
    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                VStack(alignment: .leading, content: {
                    Text(challengeUUID.uuidString)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    HStack(content: {
                        Text("Title")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Divider()
                        
                        TextField("name", text: $challengeName)
                            .font(.body)
                    })
                })
                    .padding()
            })
                .navigationBarTitle(Text("Add New Challenge"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Add")
                }))
        })
    }
}

struct MCAddChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        MCAddChallengeView(challengeName: .constant("Challenge"))
    }
}
