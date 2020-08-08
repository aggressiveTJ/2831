//
//  MCChallengeListRow.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/09.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCChallengeListRow: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, content: {
            challenge.name.map(Text.init)
                .font(.title)
            
            HStack(content: {
                challenge.id.map({
                    Text($0.uuidString)
                })
                    .font(.caption)
                
                Spacer()
                
                challenge.date.map ({
                    Text(DateFormatter.longStyle.string(from: $0))
                })
                    .font(.caption)
            })
        })
    }
}
