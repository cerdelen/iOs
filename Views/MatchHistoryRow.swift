//
//  MatchHistoryRow.swift
//  dotaTracker
//
//  Created by cerdelen on 10.03.25.
//

import Foundation
import SwiftUI

func matchRowView(for match: MatchDetails, steamID: SteamID) -> some View {
    VStack{
        let heroId = match.players.first(where: { $0.account_id == steamID.toBit32()
        })?.hero_id ?? 69
        
        let heroName = heroNameMap[heroId] ?? "Name not Found"
        let heroIcon = loadHeroIcon(withID: heroId) ?? UIImage(named: "1_antimage.png")
        HStack {
            if let heroIcon = heroIcon {
                Image(uiImage: heroIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 45)
                    .padding(.trailing, 15)
            } else {
                Text("Icon not found")
                    .frame(width: 75, height: 45)
                    .background(Color.gray)
                    .padding(.trailing, 15)
            }
            
            VStack{
                Text("\(heroName)")
                    .font(.subheadline)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                let timeAgo = timeAgoSince(startTime: match.start_time)
                Text("\(timeAgo)")
                    .font(.system(size: 11, weight: .thin))
                    .foregroundColor(.black)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
            }
            //                                .frame(minWidth: 140 )
            .frame(maxWidth: 140 )
            
            
            
            let playerPos = match.players.first(where: { $0.account_id == steamID.toBit32() })?.player_slot ?? 0
            let isRadiant = isRadiant(playerSlot: playerPos)
            let isWin = match.radiant_win == isRadiant
            
            VStack(alignment: .leading, spacing: 4) {
                Text(isWin ? "Won" : "Lost")
                    .font(.subheadline)
                    .foregroundColor(isWin ? .green : .red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                let duration = TimeInterval(match.duration)
                Text(formatDuration(duration))
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            
            let deaths: Int = match.players.first(where: { $0.account_id == steamID.toBit32() })?.deaths ?? -1
            let assists: Int = match.players.first(where: { $0.account_id == steamID.toBit32() })?.assists ?? -1
            let kills: Int = match.players.first(where: { $0.account_id == steamID.toBit32() })?.kills ?? -1
            
            
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(kills)/\(deaths)/\(assists)")
                    .font(.subheadline)
                
                
                
                
                
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        // Kills (green)
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: calculateBarWidth(total: geometry.size.width, value: kills, totalValues: kills + deaths + assists))
                        
                        // Deaths (red)
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: calculateBarWidth(total: geometry.size.width, value: deaths, totalValues: kills + deaths + assists))
                        
                        // Assists (white)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: calculateBarWidth(total: geometry.size.width, value: assists, totalValues: kills + deaths + assists))
                    }
                }
                .frame(height: 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding(.vertical, 8)
    }
}
