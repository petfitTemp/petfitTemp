//
//  PersonalAuthViewController.swift
//  PetFitTemp
//
//  Created by Sam.Lee on 7/30/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class PhoneNumViewController : BaseViewController {
    var greetingLabelL : UILabel!
    var greetingLabelS : UILabel!
    var telNumField : UITextField!
    var nextButton : UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraint()
        configureCloseButton()
        bindTextField()
        configureUtil()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        telNumField.becomeFirstResponder()
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.view.backgroundColor = .systemBackground
        
        greetingLabelL = UILabel()
        let text = "안녕하세요! \n전화번호를 입력해주세요."
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        let desiredLineHeight: CGFloat = 36 // 원하는 라인 높이 설정
        paragraphStyle.minimumLineHeight = desiredLineHeight
        paragraphStyle.maximumLineHeight = desiredLineHeight
        
        // 전체 텍스트에 대한 스타일 적용
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        greetingLabelL.attributedText = attributedString
        greetingLabelL.numberOfLines = 2
        greetingLabelL.textAlignment = .left
        greetingLabelL.lineBreakMode = .byWordWrapping
        greetingLabelL.font = UIFont.pretendardSemiBold(size: 24)
        
        greetingLabelS = UILabel()
        greetingLabelS.text = "가입 여부 확인에만 사용되며, 다른 사람에게 노출되지 않아요."
        greetingLabelS.textColor = .deHighLight
        greetingLabelS.font = UIFont.pretendardRegular(size: 14)
        
        telNumField = UITextField()
        telNumField.becomeFirstResponder()
        telNumField.keyboardType = .numberPad
        telNumField.placeholder = "010 1234 1234"
        telNumField.font = UIFont.pretendardSemiBold(size: 24)
        telNumField.delegate = self
        telNumField.clearButtonMode = .whileEditing
        telNumField.tintColor = .black
        
        nextButton = UIButton()
        nextButton.setTitle("본인 인증하기", for: .normal)
//        nextButton.isEnabled = false
        nextButton.titleLabel?.font = UIFont.pretendardSemiBold(size: 17)
        nextButton.layer.cornerCurve = .continuous
        nextButton.layer.cornerRadius = 23
        nextButton.clipsToBounds = true
        nextButton.backgroundColor = .gray
        
    }
    
    
    override func configureConstraint() {
        super.configureConstraint()
        [greetingLabelL, greetingLabelS, telNumField, nextButton].forEach{
            self.view.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        greetingLabelL.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
        
        greetingLabelS.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(greetingLabelL.snp.bottom).offset(4)
        }
        telNumField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(greetingLabelS.snp.bottom).offset(32)
            $0.height.equalTo(36)
        }
        nextButton.snp.makeConstraints{
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(66)
        }
    }
    
    func bindTextField() {
        telNumField.rx.text.orEmpty
            .map { self.format(phoneNumber: $0) }
            .bind(to: telNumField.rx.text)
            .disposed(by: disposeBag)
        
        let phoneNumberValid = telNumField.rx.text.orEmpty
            .map { $0.count == 13 }
            .share(replay: 1)
        
//        phoneNumberValid
//            .bind(to: nextButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        phoneNumberValid
            .map { $0 ? UIColor.main : UIColor.gray }
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        telNumField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count >= 3 && !text.hasPrefix("010") {
                    self.shakeTextField() // "010"으로 강제 변경
                }
            })
            .disposed(by: disposeBag)
    }
    
    func format(phoneNumber: String) -> String {
        let cleanPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let mask = "### #### ####"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result.trimmingCharacters(in: .whitespaces)
    }
    
    func shakeTextField() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.values = [
            NSValue(cgPoint: CGPoint(x: telNumField.center.x, y: telNumField.center.y-5)),
            NSValue(cgPoint: CGPoint(x: telNumField.center.x, y: telNumField.center.y+5))
        ]
        animation.autoreverses = true
        animation.repeatCount = 1
        telNumField.layer.add(animation, forKey: "position")
    }
    
    override func configureUtil() {
        super.configureUtil()
        nextButton.rx.tap.subscribe(onNext: { [weak self] in
            let nextVC = AuthViewController()
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.phoneNumber = String(self?.telNumField.text ?? "")
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }).disposed(by: disposeBag)
    }
}


extension PhoneNumViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트
        let currentText = textField.text ?? ""
        // 새 텍스트
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 앞 3자가 "010"이 아닌 경우 입력을 허용하지 않음
        if updatedText.count > 3 && !updatedText.hasPrefix("010") {
            shakeTextField()
            return false
        }
        
        // 3자 이내일 때는 유효성 검사를 수행하지 않음
        if updatedText.count <= 3 {
            return true
        }
        
        return true
    }
}
