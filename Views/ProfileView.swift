//
//  ProfileView.swift
//  dotaTracker
//
//  Created by cerdelen on 08.03.25.
//
//

import SwiftUI
import Combine

private func isRadiant(playerSlot: Int) -> Bool {
    return (playerSlot & 0b10000000) == 0
}

private func formatDuration(_ duration: TimeInterval) -> String {
      let minutes = Int(duration) / 60
      let seconds = Int(duration) % 60
      return String(format: "%02d:%02d", minutes, seconds)
  }

// Helper function to calculate KDA ratio
    private func calculateKDA(kills: Int, deaths: Int, assists: Int) -> Double {
        let kda = (Double(kills) + Double(assists)) / max(Double(deaths), 1.0)
        return kda
    }


private func calculateBarWidth(total: CGFloat, value: Int, totalValues: Int) -> CGFloat {
        guard totalValues > 0 else { return 0 }
        return (CGFloat(value) / CGFloat(totalValues)) * total
    }

struct ProfileView: View {
    @State private var player: PlayerSummaryResponse.PlayerSummary?
    @State private var matchHistory: MatchHistoryResponse?
    @State private var matchHistoryArray: [MatchDetails]?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showAllGames = false // Track if "Show More" is clicked
    var displayedGames: [Game] {
            showAllGames ? recentGames : Array(recentGames.prefix(15))
        }
    let recentGames: [Game] = [
        Game(title: "Game 1", date: "2025-10-1", score: 1200),
        Game(title: "Game 21", date: "2025-10-1", score: 1200)
    ]




//    let isWin: Bool = true
//    let duration: TimeInterval = 60 * 101 // Duration in seconds
    let kills: Int = 12
    let deaths: Int = 3
    let assists: Int = 32


    private let steamService = SteamService()
    private let steamID64 = 1
    private let steamID32 = 1
    private let sniperdefault = "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/sniper.png"

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                if let player = player {
                    VStack {
                        AsyncImage(url: URL(string: player.avatarfull)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())

                        Text(player.personaname)
                            .font(.title)
                            .padding(.top, 8)

                    }
                    .padding()


                    if let matches = matchHistoryArray {

                        List(matches, id: \.match_id) { match in
                            HStack {
                                // this will take from assets hero pictures
                                AsyncImage(url: URL(string: sniperdefault)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 75, height: 45)
                                        .padding(.trailing, 15)
                                } placeholder: {
                                    ProgressView()
                                }

                                VStack{
                                    Text("\(match.players.first(where: { $0.account_id == Int(steamID32) })?.hero_id ?? 69)")
                                        .font(.subheadline)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                    Text("12 months ago")
                                        .font(.system(size: 11, weight: .thin))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                                }
                                //                                .frame(minWidth: 140 )
                                .frame(maxWidth: 140 )


                                let playerPos = match.players.first(where: { $0.account_id == Int(steamID32) })?.player_slot ?? 0
                                let isRadiant = isRadiant(playerSlot: playerPos)
                                let isWin = match.radiant_win && isRadiant

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(isWin ? "Win" : "Lost")
                                        .font(.subheadline)
                                        .foregroundColor(isWin ? .green : .red)
                                        .frame(maxWidth: .infinity, alignment: .leading)


                                    let duration = TimeInterval(match.duration)
                                    Text(formatDuration(duration))
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
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
                        .listStyle(PlainListStyle())








//                        List(matches, id: \.match_id) { match in
////                            let playerIDs = match.players.map { $0.account_id }
//
//                            if let lol = match.players.first(where: { $0.account_id == Int(steamID32) }) {
////                                Text("Found")
//                                Text("\(lol.hero_id)")
////                                lol.avatar
//                            } else {
//                                Text("Not Found \(steamID32)")
//                            }
//                        }
                    }
//
//                    List(displayedGames, id: \.id) { game in
//                        HStack {
//                            AsyncImage(url: URL(string: sniperdefault)) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 75, height: 45)
//                                    .padding(.trailing, 15)
//                            } placeholder: {
//                                ProgressView()
//                            }
//
//                            VStack{
//                                Text(game.title)
//                                    .font(.subheadline)
//                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
//                                Text("12 months ago")
//                                    .font(.system(size: 11, weight: .thin))
//                                    .foregroundColor(.black)
//                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
//                            }
////                                .frame(minWidth: 140 )
//                                .frame(maxWidth: 140 )
//
//
//
//
////                            VStack(alignment: .leading, spacing: 4) {
////                                            Text(isWin ? "Win" : "Lost")
////                                                .font(.subheadline)
////                                                .foregroundColor(isWin ? .green : .red)
////                                                .frame(maxWidth: .infinity, alignment: .leading)
////
////                                            Text(formatDuration(duration))
////                                                .font(.subheadline)
////                                                .foregroundColor(.blue)
////                                                .frame(maxWidth: .infinity, alignment: .leading)
////                                        }
//
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("\(kills)/\(deaths)/\(assists)")
//                                    .font(.subheadline)
//
//
//                                GeometryReader { geometry in
//                                                    HStack(spacing: 0) {
//                                                        // Kills (green)
//                                                        Rectangle()
//                                                            .fill(Color.green)
//                                                            .frame(width: calculateBarWidth(total: geometry.size.width, value: kills, totalValues: kills + deaths + assists))
//
//                                                        // Deaths (red)
//                                                        Rectangle()
//                                                            .fill(Color.red)
//                                                            .frame(width: calculateBarWidth(total: geometry.size.width, value: deaths, totalValues: kills + deaths + assists))
//
//                                                        // Assists (white)
//                                                        Rectangle()
//                                                            .fill(Color.gray)
//                                                            .frame(width: calculateBarWidth(total: geometry.size.width, value: assists, totalValues: kills + deaths + assists))
//                                                    }
//                                                }
//                                                .frame(height: 4)
//                                            }
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                        }
//                        .padding(.vertical, 8)
//                    }
//                    .listStyle(PlainListStyle())

//            Spacer()



                }
            }
        }
        .onAppear {
            fetchData()
        }
    }

    private func fetchData() {
        isLoading = true
        errorMessage = nil

        steamService.fetchPlayerSummaries(steamID: steamID64)
            .sink(receiveCompletion: { completion in
                isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if let player = response.response.players.first {
                    self.player = player
                }
            })
            .store(in: &cancellables)

        steamService.fetchMatchHistory(accountID: steamID64)
            .sink(receiveCompletion: { completion in
                    self.isLoading = false
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    case .finished:
                        break
                    }
            }, receiveValue: { response in

                self.matchHistoryArray = response
            })
            .store(in: &cancellables)

//        steamService.fetchMatchHistory(accountID: steamID64)
//            .sink(receiveCompletion: { completion in
//                self.isLoading = false
//                switch completion {
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                case .finished:
//                    break
//                }
//            }, receiveValue: { matches in
//                self.matchHistory = matches
//            })
//            .store(in: &cancellables)

//        let matchDetailPublishers = self.matchHistory.map { match in
//            self.steamService.fetchMatchHistoryDetail(match_seq_num: match.result.matches[0].match_seq_num)
//                        }
//
//                        // Combine all match detail publishers into a single publisher
//        return Publishers.MergeMany(matchDetailPublishers)
//            .collect() // Collect all results into an array
//

    }

    @State private var cancellables = Set<AnyCancellable>()
}

#Preview {
    ProfileView()
}
