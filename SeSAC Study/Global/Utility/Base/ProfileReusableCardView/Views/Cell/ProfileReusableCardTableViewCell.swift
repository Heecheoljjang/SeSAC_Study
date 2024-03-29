////
////  CardTableViewCell.swift
////  SeSAC Study
////
////  Created by HeecheolYoon on 2022/11/15.
////
import UIKit
import SnapKit
import RxSwift

class ProfileTableViewCell: BaseTableViewCell {

    var disposeBag = DisposeBag()
    
    //MARK: 배경이미지
    let imageSetView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: ProfileImage.background)
        return view
    }()
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ProfileImage.sesacFirst)
        return view
    }()
    let requestButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()
    
    //MARK: 스택뷰 => 이름, 새싹 타이틀, 하고싶은스터디, 새싹 리뷰
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 0
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grayTwo.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .brandGreen
        return view
    }()
    
    //이름
    let nameView = NameHeaderView()
    //새싹 타이틀
    let sesacTitleView = SesacTitleView()
    //하고싶은스터디
    let studyView = StudyTableView()
    //새싹 리뷰
    let reviewView = ReviewView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: ProfileTableViewCell.identifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        nameView.clearButton.removeTarget(nil, action: nil, for: .allEvents)
//        setUpView(collapsed: !isSelected)
        disposeBag = DisposeBag()
    }
    
    override func configure() {
        super.configure()
        
        [backgroundImageView, sesacImageView].forEach {
            imageSetView.addSubview($0)
        }
        [nameView, sesacTitleView, studyView, reviewView].forEach {
            stackView.addArrangedSubview($0)
        }
        [imageSetView, requestButton, stackView].forEach {
            contentView.addSubview($0)
        }
        sesacTitleView.isHidden = true
        studyView.isHidden = true
        reviewView.isHidden = true
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        imageSetView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(192)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.size.equalTo(184)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(19)
        }
        requestButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(backgroundImageView).inset(12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        nameView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        sesacTitleView.snp.makeConstraints { make in
            make.height.equalTo(194)
        }
        studyView.snp.makeConstraints { make in
            make.height.equalTo(68)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageSetView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
//MARK: 주변새싹에서 사용. 내 정보에서는 하고싶은 스터디가 없으므로 사용 안함
extension ProfileTableViewCell {
    func setUpView(collapsed: Bool) {
        print(#function)
        sesacTitleView.isHidden = collapsed
        reviewView.isHidden = collapsed
        studyView.isHidden = collapsed
        nameView.chevronButton.configuration?.image = collapsed ? UIImage(named: ImageName.downChevron) : UIImage(named: ImageName.upChevron)
    }
}
