//
//  ProfileView.swift
//  dotaTracker
//
//  Created by cerdelen on 08.03.25.
//
//

import SwiftUI
import Combine

struct ProfileView: View {
    @State private var player: PlayerSummaryResponse.PlayerSummary?
    @State private var matchHistory: MatchHistoryResponse?
    @State private var matchHistoryArray: [MatchDetails]?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showAllGames = false
    @State private var steamID: SteamID = SteamID.bit32(39401116)
    private let steamService = SteamService()

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
                            matchRowView(for: match, steamID: steamID)
                        }
                        .listStyle(PlainListStyle())
                    }
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

        steamService.fetchPlayerSummaries(steamID: steamID)
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

        steamService.fetchMatchHistory(accountID: steamID)
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


    }

    @State private var cancellables = Set<AnyCancellable>()
}

#Preview {
    ProfileView()
}
