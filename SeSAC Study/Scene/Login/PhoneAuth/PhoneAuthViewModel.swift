//
//  PhoneAuthViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import Alamofire

final class PhoneAuthViewModel: CommonViewModel {
        
    struct Input {
        let authCode: ControlProperty<String?>
        let tapDoneButton: ControlEvent<Void>
        let tapRetryButton: ControlEvent<Void>
    }
    struct Output {
        let authCode: Observable<Bool>
        let buttonStatus: Driver<ButtonStatus>
        let tapDoneButton: ControlEvent<Void>
        let authCodeCheck: Driver<AuthCodeCheck>
//        let errorStatus: Driver<LoginErrorString>
        let errorStatus: Driver<LoginError>
        let tapRetryButton: ControlEvent<Void>
        let phoneNumberCheck: Driver<AuthCheck>
    }
    func transform(input: Input) -> Output {
        let authCode = input.authCode.orEmpty.map{$0.count == 6}
        let buttonStatus = buttonStatus.asDriver(onErrorJustReturn: .disable)
        let authCodeCheck = authCodeCheck.asDriver(onErrorJustReturn: .fail)
        let errorStatus = errorStatus.asDriver(onErrorJustReturn: .clientError)
        let phoneNumberCheck = phoneNumberCheck.asDriver(onErrorJustReturn: .fail)
        
        return Output(authCode: authCode, buttonStatus: buttonStatus, tapDoneButton: input.tapDoneButton, authCodeCheck: authCodeCheck, errorStatus: errorStatus, tapRetryButton: input.tapRetryButton, phoneNumberCheck: phoneNumberCheck)
    }
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
        
    var authCodeCheck = PublishRelay<AuthCodeCheck>()
    
//    var errorStatus = PublishRelay<LoginErrorString>()
    var errorStatus = PublishRelay<LoginError>()
    
    var phoneNumberCheck = PublishRelay<AuthCheck>()
    
    func checkAuth(code: String) {
        guard let id = UserDefaultsManager.shared.fetchValue(type: .verificationId) as? String else { return }
        
        if buttonStatus.value == ButtonStatus.disable {
            authCodeCheck.accept(.wrongCode)
            return
        }
        LoadingIndicator.showLoading()
        FirebaseManager.shared.checkAuthCode(verId: id, authCode: code) { [weak self] result in
            switch result {
            case .timeOut:
                LoadingIndicator.hideLoading()
                self?.authCodeCheck.accept(.timeOut)
            case .wrongCode:
                LoadingIndicator.hideLoading()
                self?.authCodeCheck.accept(.wrongCode)
            case .fail:
                LoadingIndicator.hideLoading()
                self?.authCodeCheck.accept(.fail)
            case .success:
                self?.authCodeCheck.accept(.success)
            }
        }
    }
    
    func fetchIdToken() {
        FirebaseManager.shared.fetchIdToken { result in
            switch result {
            case .success(let token):
                print("????????????????????????????????? ???????????? ????????????: \(token)")
                UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                self.checkUser()
            case .failure(let error):
                print("??????????????? ???????????? \(error)")
                LoadingIndicator.hideLoading()
                return
            }
        }
    }
    
    private func checkUser() {
        let api = SeSacAPI.signIn

        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { (data, statusCode) in
            guard let statusCode = LoginError(rawValue: statusCode) else { return }
            switch statusCode {
            case .signUpSuccess:
                guard let data = data else { return }
                print("??????????????? ????????????: \(statusCode)")
                print("?????????: \(data)")
                //?????????????????? ?????? ???????????????
                self.setUserDefaults(data: data)
                LoadingIndicator.hideLoading()
                self.errorStatus.accept(.signUpSuccess)
            default :
                print("???????????? ????????????: \(statusCode.rawValue)")
                LoadingIndicator.hideLoading()
                self.errorStatus.accept(statusCode)
            }
        }
    }
    
    //???????????? ?????? ?????????
    func requestAgain() {
        print("?????????")
        LoadingIndicator.showLoading()
        guard let phoneNumber = UserDefaultsManager.shared.fetchValue(type: .phoneNumber) as? String else { return }
        FirebaseManager.shared.fetchVerificationId(phoneNumber: phoneNumber) { [weak self] value in
            switch value {
            case .wrongNumber:
                LoadingIndicator.hideLoading()
                self?.phoneNumberCheck.accept(.wrongNumber)
            case .fail:
                LoadingIndicator.hideLoading()
                self?.phoneNumberCheck.accept(.fail)
            case .manyRequest:
                LoadingIndicator.hideLoading()
                self?.phoneNumberCheck.accept(.manyRequest)
            case .success:
                LoadingIndicator.hideLoading()
                self?.phoneNumberCheck.accept(.success)
            }
        }
    }
    
    private func setUserDefaults(data: SignIn) {
        //???????????????, ?????????, ??????, ?????????, ??????, fcm??????
        UserDefaultsManager.shared.setValue(value: data.phoneNumber, type: .phoneNumber)
        UserDefaultsManager.shared.setValue(value: data.nick, type: .nick)
        UserDefaultsManager.shared.setValue(value: data.birth, type: .birth)
        UserDefaultsManager.shared.setValue(value: data.email, type: .email)
        UserDefaultsManager.shared.setValue(value: data.gender, type: .gender)
        UserDefaultsManager.shared.setValue(value: data.fcMtoken, type: .fcmToken)
        
        //MARK: ????????? ?????? ??????
        UserDefaultsManager.shared.setValue(value: data, type: .userInfo)
    }
    
    //MARK: ???????????? ????????? ???????????????
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
}
