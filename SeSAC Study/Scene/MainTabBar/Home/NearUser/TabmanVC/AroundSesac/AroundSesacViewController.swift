//
//  AroundSesacViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa

final class AroundSesacViewController: ViewController {
    
    private var mainView = AroundSesacView()
    private let viewModel = AroundSesacViewModel()
    private let disposeBag = DisposeBag()
    
    private var dataSource: UITableViewDiffableDataSource<Int, FromQueueDB>!
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.startSeSacSearch()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UserDefaultsManager.shared.removeValue(type: .otherUid)
    }
    
    override func configure() {
        super.configure()
        
        
        mainView.tableView.isScrollEnabled = true
        mainView.tableView.register(AroundSesacTableViewCell.self, forCellReuseIdentifier: AroundSesacTableViewCell.identifier)
    }
    
    func bind() {
//        viewModel.sesacList
//            .asDriver(onErrorJustReturn: [])
//            .drive(mainView.tableView.rx.items(cellIdentifier: AroundSesacTableViewCell.identifier, cellType: AroundSesacTableViewCell.self)) { [weak self] row, element, cell in
//
//
//                guard let backImage = BackgroundImage(rawValue: element.background)?.imageName,
//                      let sesacImage = UserProfileImage(rawValue: element.sesac)?.image,
//                let reviewIsEmpty = self?.viewModel.checkReviewEmpty(reviews: element.reviews) else { return }
//
////                cell.nameView.clearButton.tag = row
////                cell.nameView.clearButton.addTarget(self, action: #selector(self?.touchToggleButton(_:)), for: .touchUpInside)
////                cell.nameView.clearButton.isSelected ? cell.setUpView(collapsed: false) : cell.setUpView(collapsed: true)
//
//                cell.setUpView(collapsed: !cell.nameView.clearButton.isSelected)
//                cell.backgroundImageView.image = UIImage(named: backImage)
//                cell.sesacImageView.image = UIImage(named: sesacImage)
//                cell.nameView.nameLabel.text = element.nick
//                for i in 0..<element.reputation.count {
//                    if element.reputation[i] == 0 {
//                        continue
//                    }
//                    switch i {
//                    case 0:
//                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.goodButton, status: .enable)
//                    case 1:
//                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.timeButton, status: .enable)
//                    case 2:
//                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.fastButton, status: .enable)
//                    case 3:
//                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.kindButton, status: .enable)
//                    case 4:
//                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.expertButton, status: .enable)
//                    case 5:
//                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.helpfulButton, status: .enable)
//                    default:
//                        break
//                    }
//                }
//                if reviewIsEmpty {
//                    cell.reviewView.detailButton.isHidden = true
//                } else {
//                    cell.reviewView.label.text = element.reviews[0]
//                }
//
////                cell.nameView.clearButton.rx.tap
////                    .bind(onNext: { [weak self] _ in
////                        print(element.nick)
////                        print("????????? iscolla \(cell.isCollapsed.value)", row)
//////                        cell.isCollapsed = !cell.isCollapsed
////                        cell.isCollapsed.accept(!cell.isCollapsed.value)
////                        print("????????? iscolla \(cell.isCollapsed.value)", row)
////                    })
////                    .disposed(by: cell.disposeBag)
////
////                cell.isCollapsed
////                    .bind(onNext: { [weak self] value in
////                        print("??????????????????")
////                        cell.setUpView(collapsed: value)
////                    })
////                    .disposed(by: cell.disposeBag)
////
//                //???????????? ??????
//                cell.requestButton.rx.tap
//                    .bind(onNext: { [weak self] _ in
//                        print("???????????? ??????")
//                        print(element.nick)
//                        self?.viewModel.studyRequest(uid: element.uid)
//                    })
//                    .disposed(by: cell.disposeBag)
//
//                cell.setUpView(collapsed: !cell.nameView.clearButton.isSelected)
//                cell.nameView.clearButton.rx.tap
//                    .bind(onNext: { [weak self] _ in
//                        print("????????? row \(row)")
//                        print("????????? \(cell.nameView.clearButton.isSelected)")
////                        cell.setUpView(collapsed: false)
////                        cell.nameView.clearButton.isSelected = !cell.nameView.clearButton.isSelected
//
////                        self?.mainView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
////                        let cell = self?.mainView.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! AroundSesacTableViewCell
//                        cell.row = row
//                        cell.nameView.clearButton.isSelected = !cell.nameView.clearButton.isSelected
//                        cell.setUpView(collapsed: !cell.nameView.clearButton.isSelected)
//                        self?.mainView.tableView.reloadSections(IndexSet(), with: .none)
//                    })
//                    .disposed(by: cell.disposeBag)
//            }
//            .disposed(by: disposeBag)
        
        viewModel.sesacList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] value in
                var snapshot = NSDiffableDataSourceSnapshot<Int, FromQueueDB>()
                snapshot.appendSections([0]) //0??? ?????????
                snapshot.appendItems(value)
                self?.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        viewModel.sesacList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] value in
                //?????? ???????????? 0?????? noSesacView????????? tableviewhidden
                self?.checkListCount(list: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.requestStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                self?.checkRequestStatus(status: value)
            })
            .disposed(by: disposeBag)
        
        //MARK: ?????? ???????????? 200??? ???????????? ??????????????? ??????
        viewModel.acceptStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                self?.checkAcceptStatus(status: value)
            })
            .disposed(by: disposeBag)
    }
}

extension AroundSesacViewController {
    private func checkListCount(list: [FromQueueDB]) {
        let emptyValue = viewModel.checkListEmpty(list: list)
        mainView.tableView.isHidden = emptyValue
        mainView.noSesacView.isHidden = !emptyValue
    }
    private func checkRequestStatus(status: StudyRequestError) {
        switch status {
        case .studyAccept:
            //accept???????????? ?????? ???????????? ????????? ?????? ???????????? ???????????? ?????????????????? ???????????? ???????????? dismiss
            guard let uid = UserDefaultsManager.shared.fetchValue(type: .otherUid) as? String else { return }
            viewModel.studyAccept(uid: uid)
        default:
            presentToast(view: mainView, message: status.message)
        }
    }
    private func checkAcceptStatus(status: StudyAcceptError) {
        switch status {
        case .acceptSuccess:
            // ????????? ???????????? ??? ????????? ?????? ????????? ????????? ???????????????????????? ?????????????????? ??????????????????
//            presentToast(view: mainView, message: StudyRequestError.studyAccept.message)
            presentHandlerToast(view: mainView, message: StudyRequestError.studyAccept.message) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("?????????")
                    //?????????????????? ??????
                    let vc = ChattingViewController()
                    self.transition(vc, transitionStyle: .push)
                }
            }
        default:
            presentToast(view: mainView, message: status.message)
        }
    }
}

extension AroundSesacViewController: CustomAlertDelegate {
    func ok() {
        //MARK: request??????
        guard let uid = UserDefaultsManager.shared.fetchValue(type: .otherUid) as? String else { return }
        viewModel.studyRequest(uid: uid)
    }
    
    func cancel() {
        print("??????????????? ???????????? ????????????")
    }
}

extension AroundSesacViewController {
    private func configureDataSource() {
    
        dataSource = UITableViewDiffableDataSource(tableView: mainView.tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AroundSesacTableViewCell.identifier, for: indexPath) as? AroundSesacTableViewCell else { return UITableViewCell() }
            guard let backImage = BackgroundImage(rawValue: itemIdentifier.background)?.imageName,
                  let sesacImage = UserProfileImage(rawValue: itemIdentifier.sesac)?.image,
                  let reviewIsEmpty = self?.viewModel.checkReviewEmpty(reviews: itemIdentifier.reviews) else { return UITableViewCell() }
            cell.backgroundImageView.image = UIImage(named: backImage)
            cell.sesacImageView.image = UIImage(named: sesacImage)
            cell.nameView.nameLabel.text = itemIdentifier.nick
            
            for i in 0..<itemIdentifier.reputation.count {
                if itemIdentifier.reputation[i] == 0 {
                    continue
                }
                switch i {
                case 0:
                    self?.changeSelectedButtonColor(button: cell.sesacTitleView.goodButton, status: .enable)
                case 1:
                    self?.changeSelectedButtonColor(button: cell.sesacTitleView.timeButton, status: .enable)
                case 2:
                    self?.changeSelectedButtonColor(button: cell.sesacTitleView.fastButton, status: .enable)
                case 3:
                    self?.changeSelectedButtonColor(button: cell.sesacTitleView.kindButton, status: .enable)
                case 4:
                    self?.changeSelectedButtonColor(button: cell.sesacTitleView.expertButton, status: .enable)
                case 5:
                    self?.changeSelectedButtonColor(button: cell.sesacTitleView.helpfulButton, status: .enable)
                default:
                    break
                }
            }
            if reviewIsEmpty {
                cell.reviewView.detailButton.isHidden = true
            } else {
                cell.reviewView.label.text = itemIdentifier.reviews[0]
                cell.reviewView.detailButton.isHidden = false
            }
            
            cell.requestButton.rx.tap
                .bind(onNext: { [weak self] _ in
                    print("???????????? ??????")
                    print(itemIdentifier.nick)
                    //MARK: ???????????? ????????? ?????? ?????????
                    self?.viewModel.setOtherUid(uid: itemIdentifier.uid)
                    self?.showCustomAlert(title: CustomAlert.studyRequest.title, message: CustomAlert.studyRequest.message)
                })
                .disposed(by: cell.disposeBag)
            
            cell.nameView.clearButton.rx.tap
                .bind(onNext: { [weak self] _ in
                    print("????????????")
//                    cell.setUpView(collapsed: false)
//                    cell.nameView.clearButton.isSelected = !cell.nameView.clearButton.isSelected
//
//                    self?.mainView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//                    let cell = self?.mainView.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! AroundSesacTableViewCell

                    cell.nameView.clearButton.isSelected = !cell.nameView.clearButton.isSelected
                    cell.setUpView(collapsed: !cell.nameView.clearButton.isSelected)
                    var snapshot = self?.dataSource.snapshot()
                    snapshot?.reloadSections([0])
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        })
    }
}

extension AroundSesacViewController {
    private func showCustomAlert(title: String, message: String) {
        let alertVC = CustomAlertViewController()
        alertVC.mainView.titleLabel.text = title
        alertVC.delegate = self
        alertVC.mainView.messagelabel.text = message
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overFullScreen
        present(alertVC, animated: true)
    }
}

extension AroundSesacViewController {
    @objc private func touchToggleButton(_ sender: UIButton) {
        print(sender.tag)
//        sender.isSelected = !sender.isSelected
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ProfileTableViewCell else { return }
        print(cell.isSelected)
//        cell.isSelected = !cell.isSelected
//        cell.setUpView(collapsed: !cell.isSelected)
        mainView.tableView.reloadData()
    }
//    @objc private func tapRequestButton(_ sender: UIButton) {
//        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ProfileTableViewCell else { return }
//    }
}
