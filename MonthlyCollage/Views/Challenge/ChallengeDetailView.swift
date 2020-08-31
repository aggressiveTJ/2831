//
//  ChallengeDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct ChallengeDetailView: View {
    enum SheetType: Identifiable {
        case edit
        case activityView
        case imagePicker
        
        var id: Int {
            self.hashValue
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var selectedDay: Day? {
        didSet {
            guard let day = selectedDay else {
                return
            }

            if !day.hasImages {
                showsActionSheet = false
                sheetType = nil
                sheetType = .imagePicker
            }
        }
    }
    @State private var sheetType: SheetType?
    @State private var showsActionSheet = false

    let challenge: Challenge
    
    var body: some View {
        let selected = Binding<Day?>(get: {
            return selectedDay
        }, set: {
            selectedDay = $0
        })
        
        return ScrollView(content: {
            VStack(alignment: .leading, spacing: 5, content: {
                Text(challenge.id.uuidString)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Divider()
                Spacer(minLength: 30)
                
                CalendarView(selectedDay: selected, challenge: challenge)
                
                Button(action: {
                    if let _ = challenge.complete()?.collageImage {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        print("[ChallengeDetailView.body] smt wrong")
                    }
                }, label: {
                    Text("Export Collage")
                })
            })
            .padding()
        })
        .navigationBarTitle(Text(challenge.title))
        .navigationBarItems(trailing: moreButton)
        .sheet(item: $sheetType, onDismiss: {
            self.sheetType = nil
        }, content: { (type) in
            if type == .edit {
                AddChallengeView(challenge: challenge)
            } else if type == .activityView {
                ActivityViewController(activityItems: [selectedDay?.sharableImage(original: true)])
            } else if type == .imagePicker {
                ImagePicker(sourceType: .photoLibrary, onImagePicked: { (image) in
                    if let day = self.selectedDay {
                        day.saveImage(with: image)
                    }
                })
            }
        })
    }
    
    private var moreButton: some View {
        Button(action: {
            self.showsActionSheet = true
        }, label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
        })
        .actionSheet(isPresented: $showsActionSheet, content: {
            ActionSheet(title: Text(""), buttons: [
                .default(Text("Edit"), action: {
                    self.sheetType = .edit
                }),
                .default(Text("Remove"), action: {
                    self.challenge.remove()
                    self.presentationMode.wrappedValue.dismiss()
                }),
                .cancel()
            ])
        })
    }
}

struct ChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChallengeDetailView(challenge: Challenge.preview)
            ChallengeDetailView(challenge: Challenge.preview)
                .preferredColorScheme(.dark)
        }
    }
}
