//
//  SeSacAPI.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation
import Alamofire

//MARK: - 버전도 다 나누기 => API별로 나눠주고 base랑 version을 각각 두면 해결될듯
enum SeSacAPI {
    
    static let baseUrl = "http://api.sesac.co.kr:1210"
    static let version = "/v1/"
    
    case signIn
    case signUp(phoneNumber: String, fcmToken: String, nickname: String, birth: String, email: String, gender: Int)
    case withdraw
    case updateFCM(oldToken: String)
    case queue(lat: Double, lon: Double, studyList: [String])
    case queueSearch(lat: Double, lon: Double)
    case stopQueueSearch
    case myQueueState
    case update(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String)
    case studyRequest(otherUid: String)
    case studyAccept(otherUid: String)
    case dodge(otherUid: String)
    case chatTo(ohterUid: String, chat: String)
    case chatFrom(ohterUid: String, lastDate: String)
    case rate(otherUid: String, reputation: [Int], comment: String)
    
    case shopMyInfo
    case shopUpdateItem(sesac: Int, background: Int)
    case shopPurchaseItem(receipt: String, product: String)
    
    var url: URL {
        switch self {
        case .signIn, .signUp:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)user")!
        case .withdraw:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)user/withdraw")!
        case .update:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)user/mypage")!
        case .updateFCM:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)user/update_fcm_token")!
        case .shopMyInfo:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)user/shop/myinfo")!
        case .shopUpdateItem:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)user/shop/item")!
        case .shopPurchaseItem:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)user/shop/ios")!
        case .queue, .stopQueueSearch:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue")!
        case .queueSearch:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue/search")!
        case .myQueueState:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue/myQueueState")!
        case .studyRequest:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue/studyrequest")!
        case .studyAccept:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue/studyaccept")!
        case .dodge:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue/dodge")!
        case .rate(let uid, _, _):
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue/rate/\(uid)")!
        case .chatTo(let uid, _):
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)chat/\(uid)")!
        case .chatFrom(let uid, let date):
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)chat/\(uid)?lastchatDate=\(date)")!
        }
    }
    
    var headers: HTTPHeaders {
        guard let token = UserDefaultsManager.shared.fetchValue(type: .idToken) as? String else { return [] }
        
        switch self {
        case .signIn, .withdraw, .myQueueState, .stopQueueSearch, .rate, .updateFCM, .shopMyInfo, .shopUpdateItem, .shopPurchaseItem:
            return ["idtoken": token]
        case .signUp, .queue, .queueSearch, .update, .studyRequest, .studyAccept, .dodge, .chatTo, .chatFrom:
            return [
                "idtoken": token,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .signIn, .withdraw, .myQueueState, .stopQueueSearch, .chatFrom, .shopMyInfo:
            return nil
        case .signUp(let phoneNumber, let fcmToken, let nickname, let birth, let email, let gender):
            return [
                "phoneNumber": phoneNumber,
                "FCMtoken": fcmToken,
                "nick": nickname,
                "birth": birth,
                "email": email,
                "gender": gender
            ]
        case .updateFCM(let oldToken):
            return [
                "FCMtoken": oldToken
            ]
        case .queue(let lat, let lon, let studyList):
            return [
                "lat": lat,
                "long": lon,
                "studylist": studyList
            ]
        case .queueSearch(let lat, let lon):
            return [
                "lat": lat,
                "long": lon,
            ]
        case .update(let searchable, let ageMin, let ageMax, let gender, let study):
            return [
                "searchable": searchable,
                "ageMin": ageMin,
                "ageMax": ageMax,
                "gender": gender,
                "study": study
            ]
        case .studyRequest(let otheruid), .studyAccept(let otheruid), .dodge(let otheruid):
            return [
                "otheruid": otheruid
            ]
        case .chatTo(_, let chat):
            return [
                "chat": chat
            ]
        case .rate(let uid, let reputation, let comment):
            return [
                "otheruid": uid,
                "reputation": reputation,
                "comment": comment
            ]
        case .shopUpdateItem(let sesac, let background):
            return [
                "sesac": sesac,
                "background": background
            ]
        case .shopPurchaseItem(let receipt, let product):
            return [
                "receipt": receipt,
                "product": product
            ]
        }
    }
}
