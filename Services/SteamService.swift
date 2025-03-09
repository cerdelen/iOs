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
    private let steamAPIKey = "YourKey"

    func fetchPlayerSummaries(steamID: Int) -> AnyPublisher<PlayerSummaryResponse, Error> {
        let urlString = "\(baseURL)/ISteamUser/GetPlayerSummaries/v2/?key=\(steamAPIKey)&steamids=\(steamID)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PlayerSummaryResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }


    func fetchMatchHistory(accountID: Int) -> AnyPublisher<[MatchDetails], Error> {
        let urlString = "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1/?key=\(steamAPIKey)&account_id=\(accountID)&matches_requested=10"

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//            return []
        }

//        let res = URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: MatchHistoryResponse.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//
//        var some_array: [MatchDetailsWrapper] = []
//        let other_var = res.sink(receiveCompletion: {_ in} , receiveValue: { matchHistory in
//            for match in matchHistory.result.matches {
//                let lol = self.fetchMatchHistoryDetail(match_seq_num: match.match_seq_num).sink(receiveCompletion: {_ in}, receiveValue: { matchWrapper in
//                    some_array.append(matchWrapper.result)
//                })
//            }
//        })
//
//        return some_array

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MatchHistoryResponse.self, decoder: JSONDecoder())
            .flatMap { matchHistory in
                let detailPublishers = matchHistory.result.matches.map { match in
                    self.fetchMatchHistoryDetail(match_seq_num: match.match_seq_num)
                        .map(\.result.matches) // Extracts [Match] from the response
                }
                return Publishers.MergeMany(detailPublishers).collect() // Merges multiple publishers
            }
            .map { $0.flatMap{ $0 } } // Flatten [[Match]] into [Match]
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: MatchHistoryResponse.self, decoder: JSONDecoder())
//            .flatMap { matchHistory in
//                let detailPublishers = matchHistory.result.matches.map { match in
//                    self.fetchMatchHistoryDetail(match_seq_num: match.match_seq_num)
//                        .map(\.result.matches)
//                        .flatMap { matches in Publishers.Sequence(sequence: matches) } // Flatten array
//                }
//                return Publishers.MergeMany(detailPublishers).collect() // Collect into a single array
//            }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//        return URLSession.shared.dataTaskPublisher(for: url)
//                .map(\.data)
//                .decode(type: MatchHistoryResponse.self, decoder: JSONDecoder())
//                .flatMap { matchHistory in
//                    let detailPublishers = matchHistory.result.matches.map { match in
//                        self.fetchMatchHistoryDetail(match_seq_num: match.match_seq_num)
//                            .map(\.result.matches)
//                    }
//                    return Publishers.MergeMany(detailPublishers).collect()
//                }
//                .receive(on: DispatchQueue.main)
//                .eraseToAnyPublisher()
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
