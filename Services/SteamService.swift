//
//  DotaService.swift
//  dotaTracker
//
//  Created by cerdelen on 08.03.25.
//
import Foundation
import Combine

class SteamService {
    private let baseURL = "https://api.steampowered.com"
    private let steamAPIKey = "YOUR_API_KEY"

    func fetchPlayerSummaries(steamID: SteamID) -> AnyPublisher<PlayerSummaryResponse, Error> {
        let urlString = "\(baseURL)/ISteamUser/GetPlayerSummaries/v2/?key=\(steamAPIKey)&steamids=\(steamID.toBit64())"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PlayerSummaryResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }


    func fetchMatchHistory(accountID: SteamID) -> AnyPublisher<[MatchDetails], Error> {
        let urlString = "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1/?key=\(steamAPIKey)&account_id=\(accountID.toBit64())&matches_requested=10"

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
                .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: true)
                .map(\.data)
                .decode(type: MatchHistoryResponse.self, decoder: JSONDecoder())
                .flatMap { matchHistory in
                    self.fetchMatchDetails(for: matchHistory.result.matches)
                }
                .eraseToAnyPublisher()
    }

    func fetchMatchDetails(for matches: [Match]) -> AnyPublisher<[MatchDetails], Error> {
        let detailPublishers = matches.enumerated().map { index, match in
               fetchMatchHistoryDetail(match_seq_num: match.match_seq_num)
                   .map { detailResponse -> (Int, MatchDetails) in
                       return (index, detailResponse.result.matches[0])
                   }
           }

           return Publishers.MergeMany(detailPublishers)
               .collect()
               .map { indexedMatches in
                   indexedMatches.sorted { $0.0 < $1.0 }.map { $0.1 }
               }
               .eraseToAnyPublisher()
    }

    func fetchMatchHistoryDetail(match_seq_num: Int) -> AnyPublisher<MatchDetailsResponse, Error> {
        let urlString = "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistoryBySequenceNum/v1/?key=\(steamAPIKey)&start_at_match_seq_num=\(match_seq_num)&matches_requested=1"

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MatchDetailsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
