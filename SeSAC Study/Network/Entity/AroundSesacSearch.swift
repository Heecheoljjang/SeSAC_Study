//
//  SesacSearch.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/17.
//

import Foundation

struct AroundSesacSearch: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

struct FromQueueDB: Codable, Hashable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
