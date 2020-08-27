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
        VStack(alignment: .leading, spacing: 10, content: {
            Text(challenge.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(1)
            
            Divider()
            
            Text(challenge.id.uuidString)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
        })
        .padding(.trailing, 5.0)
    }
}

struct MCChallengeListRow_Previews: PreviewProvider {
    static var previews: some View {
        MCChallengeListRow(challenge: Challenge.preview)
            .previewLayout(.fixed(width: 375, height: 65))
    }
}
