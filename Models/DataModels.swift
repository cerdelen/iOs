//
//  DataModels.swift
//  dotaTracker
//
//  Created by cerdelen on 08.03.25.
//

import Foundation

struct Profile {
    let name : String
    let profilePicture : String
}

struct Game {
    let id = UUID()
    let title : String
    let date : String
    let score : Int
}

struct PlayerSummaryResponse: Codable {
    let response: PlayerSummaryList
    
    struct PlayerSummaryList: Codable {
        let players: [PlayerSummary]
    }
    
    struct PlayerSummary: Codable {
        let steamid: String
        let personaname: String
        let profileurl: String
        let avatar: String
        let avatarmedium: String
        let avatarfull: String
    }
}

struct MatchHistoryResponse: Codable {
    let result: MatchHistoryResult
}

struct MatchHistoryResult: Codable {
    let status: Int
    let num_results: Int
    let total_results: Int
    let results_remaining: Int
    let matches: [Match]
}

struct Match: Codable {
    let match_id: Int
    let start_time: Int
    let match_seq_num: Int
    let lobby_type: Int
    let players: [Player]
}

struct Player: Codable {
    let account_id: Int
    let player_slot: Int
    let team_number: Int
    let team_slot: Int
    let hero_id: Int
    let hero_variant: Int
}

struct MatchDetailsResponse: Codable {
    let result: MatchDetailsWrapper
}

struct MatchDetailsWrapper: Codable {
    let status: Int
    let matches: [MatchDetails]
}

struct MatchDetails: Codable {
    let players: [MatchDetailsPlayer]
    let radiant_win: Bool
    let duration: Int
    let pre_game_duration: Int
    let start_time: Int
    let match_id: Int
    let match_seq_num: Int
    let tower_status_radiant: Int
    let tower_status_dire: Int
    let barracks_status_radiant: Int
    let barracks_status_dire: Int
    let cluster: Int
    let first_blood_time: Int
    let lobby_type: Int
    let human_players: Int
    let leagueid: Int
    let game_mode: Int
    let flags: Int
    let engine: Int
    let radiant_score: Int
    let dire_score: Int
    let picks_bans: [MatchDetailsPickBans]
}

struct MatchDetailsPlayer: Codable {
    let account_id: Int
    let player_slot: Int
    let team_number: Int
    let team_slot: Int
    let hero_id: Int
    let hero_variant: Int
//    let item_0: Int
//    let item_1: Int
//    let item_2: Int
//    let item_3: Int
//    let item_4: Int
//    let item_5: Int
//    let backpack_0: Int
//    let backpack_1: Int
//    let backpack_2: Int
//    let item_neutral: Int
//    let item_neutral2: Int
    let kills: Int
    let deaths: Int
    let assists: Int
//    let leaver_status: Int
//    let last_hits: Int
//    let denies: Int
//    let gold_per_min: Int
//    let xp_per_min: Int
//    let level: Int
//    let net_worth: Int
//    let aghanims_scepter: Int
//    let aghanims_shard: Int
//    let moonshard: Int
//    let hero_damage: Int
//    let tower_damage: Int
//    let hero_healing: Int
//    let gold: Int
//    let gold_spent: Int
//    let scaled_hero_damage: Int
    // let scaled_tower_damage: Int
//    let scaled_hero_healing: Int
    //ability_upgrades: [ ]
}

struct MatchDetailsPickBans: Codable {

}

