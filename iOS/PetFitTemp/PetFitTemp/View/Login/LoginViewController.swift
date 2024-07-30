//
//  LoginViewController.swift
//  PetFitTemp
//
//  Created by Sam.Lee on 7/30/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class LoginViewController : BaseViewController {
    
    var logoImage : UIImageView!
    var startButton : UIButton!
    var logoText: UILabel!
    var noticeLabel : UILabel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraint()
        configureUtil()
    }
    
    override func configureUI() {
        super.configureUI()
        self.view.backgroundColor = .systemBackground
        
        logoImage = UIImageView(image: .petPick)
        
        logoText = UILabel()
        logoText.text = "반려인의 정보 커뮤니티"
        logoText.font = UIFont.pretendardRegular(size: 14)
        logoText.textColor = .deHighLight
        
        startButton = UIButton()
        startButton.setTitle("펫핏 시작하기", for: .normal)
        startButton.titleLabel?.font = UIFont.pretendardSemiBold(size: 17)
        startButton.layer.cornerCurve = .continuous
        startButton.layer.cornerRadius = 23
        startButton.clipsToBounds = true
        startButton.backgroundColor = .main
        
        configureNoticeLabel()
    }
    
    func configureNoticeLabel() {
        noticeLabel = UILabel()
        
        noticeLabel.isUserInteractionEnabled = true
        let text = "시작하면 서비스 이용약관, 개인정보 처리방침, 그리고 위치정보 이용약관에 동의하게 됩니다."
        let attributedString = NSMutableAttributedString(string: text)
        
        let termsRange = (text as NSString).range(of: "서비스 이용약관")
        let privacyRange = (text as NSString).range(of: "개인정보 처리방침")
        let locationRange = (text as NSString).range(of: "위치정보 이용약관")
        
        let baselineOffset: CGFloat = 0
        
        // 각 범위에 밑줄 스타일 적용
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .baselineOffset: baselineOffset
        ], range: termsRange)
        
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .baselineOffset: baselineOffset
        ], range: privacyRange)
        
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .baselineOffset: baselineOffset
        ], range: locationRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        let desiredLineHeight: CGFloat = 17 // 원하는 라인 높이 설정
        paragraphStyle.minimumLineHeight = desiredLineHeight
        paragraphStyle.maximumLineHeight = desiredLineHeight
        
        // 전체 텍스트에 대한 스타일 적용
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        // UILabel에 NSAttributedString 적용
        noticeLabel.attributedText = attributedString
        noticeLabel.font = UIFont.pretendardRegular(size: 12)
        noticeLabel.textColor = .deHighLight
        noticeLabel.numberOfLines = 0
        
        // UITapGestureRecognizer 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        noticeLabel.addGestureRecognizer(tapGesture)
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        [logoText,logoImage,startButton,noticeLabel].forEach{
            self.view.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        startButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(84)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(66)
        }
        logoImage.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(284)
            $0.centerX.equalToSuperview()
        }
        logoText.snp.makeConstraints{
            $0.top.equalTo(logoImage.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        noticeLabel.snp.makeConstraints{
            $0.top.equalTo(startButton.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func configureUtil() {
        super.configureUtil()
        
        startButton.rx.tap.subscribe(onNext: { [weak self] in
            let nextVC = PersonalAuthViewController()
            let navVC = UINavigationController(rootViewController: nextVC)
            navVC.modalPresentationStyle = .fullScreen
            self?.present(navVC, animated: false)
        }).disposed(by: disposeBag)
    }
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        guard let text = noticeLabel.attributedText?.string else { return }
        let termsRange = (text as NSString).range(of: "서비스 이용약관")
        let privacyRange = (text as NSString).range(of: "개인정보 처리방침")
        let locationRange = (text as NSString).range(of: "위치정보 이용약관")
        
        // 터치된 위치 얻기
        let tapLocation = gesture.location(in: noticeLabel)
        
        // 텍스트 레이아웃 매니저 설정
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: noticeLabel.bounds.size)
        let textStorage = NSTextStorage(attributedString: noticeLabel.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = noticeLabel.lineBreakMode
        textContainer.maximumNumberOfLines = noticeLabel.numberOfLines
        
        // 탭 위치와 텍스트 위치 매핑
        let index = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if NSLocationInRange(index, termsRange) {
            print("서비스 이용약관 클릭됨")
            // 서비스 이용약관 클릭 시 동작
        } else if NSLocationInRange(index, privacyRange) {
            print("개인정보 처리방침 클릭됨")
            // 개인정보 처리방침 클릭 시 동작
        } else if NSLocationInRange(index, locationRange) {
            print("위치정보 이용약관 클릭됨")
            // 위치정보 이용약관 클릭 시 동작
        }
    }
}
