import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NickNameViewController: BaseViewController, UITextFieldDelegate {
    var greetingLabel: UILabel!
    var nickNameField: UITextField!
    var warningLabel: UILabel!
    var nextButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraint()
        configureUtil()
        configureBackButton()
        bindTextField()
    }
    
    override func configureUI() {
        self.view.backgroundColor = .systemBackground
        greetingLabel = UILabel()
        let text = "닉네임을 입력해주세요."
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        let desiredLineHeight: CGFloat = 36 // 원하는 라인 높이 설정
        paragraphStyle.minimumLineHeight = desiredLineHeight
        paragraphStyle.maximumLineHeight = desiredLineHeight
        
        // 전체 텍스트에 대한 스타일 적용
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        greetingLabel.attributedText = attributedString
        greetingLabel.numberOfLines = 2
        greetingLabel.textAlignment = .left
        greetingLabel.lineBreakMode = .byWordWrapping
        greetingLabel.font = UIFont.pretendardSemiBold(size: 24)
        
        nickNameField = UITextField()
        nickNameField.delegate = self
        nickNameField.keyboardType = .default
        nickNameField.placeholder = "귀여운애옹이하루"
        nickNameField.font = UIFont.pretendardSemiBold(size: 24)
        nickNameField.clearButtonMode = .whileEditing
        nickNameField.tintColor = .black
        
        nextButton = UIButton()
        nextButton.setTitle("다음", for: .normal)
        nextButton.titleLabel?.font = UIFont.pretendardSemiBold(size: 17)
        nextButton.layer.cornerCurve = .continuous
        nextButton.layer.cornerRadius = 23
        nextButton.clipsToBounds = true
        nextButton.backgroundColor = .gray
        
        warningLabel = UILabel()
        warningLabel.text = "한글, 영어, 숫자만 사용할 수 있어요. (최대 12자)"
        warningLabel.font = UIFont.pretendardRegular(size: 14)
        warningLabel.textColor = UIColor(hexCode: "FF3B30")
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        [greetingLabel, nickNameField, nextButton, warningLabel].forEach {
            self.view.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
        nickNameField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(greetingLabel.snp.bottom).offset(32)
            $0.height.equalTo(36)
        }
        warningLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(nickNameField.snp.bottom).offset(4)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(66)
        }
    }
    
    override func configureUtil() {
        // 추가 설정이 필요한 경우 여기에 구현
    }
    
    func bindTextField() {
        nickNameField.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance) // 1초 동안 텍스트 변경 없을 시
            .distinctUntilChanged() // 중복된 텍스트 무시
            .subscribe(onNext: { [weak self] newValue in
                guard let self = self else { return }
                
                if !self.isValidNickname(newValue) {
                    self.warningLabel.text = "한글, 영어, 숫자만 사용할 수 있어요. (최대 12자)"
                    self.warningLabel.textColor = UIColor(hexCode: "FF3B30")
                    self.nextButton.isEnabled = false
                    self.nextButton.backgroundColor = .gray
                    return
                }
                
                // 닉네임 길이 검사
                if newValue.count > 12 {
                    self.shakeTextField()
                    self.nickNameField.text = String(newValue.prefix(13))
                    self.warningLabel.text = "최대 12자까지만 입력 가능합니다."
                    self.nextButton.backgroundColor = .gray
                } else if newValue.count < 2 {
                    self.warningLabel.text = "한글, 영어, 숫자만 사용할 수 있어요. (최대 12자)"
                    self.warningLabel.textColor = UIColor(hexCode: "FF3B30")
                    self.nextButton.backgroundColor = .gray
                } else if !self.isValidNickname(newValue) {
                    self.warningLabel.text = "한글, 영어, 숫자만 사용할 수 있어요. (최대 12자)"
                    self.warningLabel.textColor = UIColor(hexCode: "FF3B30")
                    self.nextButton.isEnabled = false
                    self.nextButton.backgroundColor = .gray
                } else {
                    // 서버와 통신하여 닉네임 사용 가능 여부 확인
                    self.checkNicknameAvailability(newValue)
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { isAvailable in
                            if isAvailable {
                                self.warningLabel.text = "사용 가능한 닉네임입니다."
                                self.warningLabel.textColor = .systemGreen
                                self.nextButton.isEnabled = true
                                self.nextButton.backgroundColor = .systemBlue
                            } else {
                                self.warningLabel.text = "이미 사용 중인 닉네임입니다."
                                self.warningLabel.textColor = UIColor(hexCode: "FF3B30")
                                self.nextButton.isEnabled = false
                                self.nextButton.backgroundColor = .gray
                            }
                            self.warningLabel.isHidden = false
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func isValidNickname(_ nickname: String) -> Bool {
        let regex = "^[A-Za-z0-9가-힣]{1,12}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: nickname)
    }

    func isValidHangul(_ text: String) -> Bool {
        let pattern = "^[A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: text.utf16.count)
            if regex.firstMatch(in: text, options: [], range: range) != nil {
                return true
            }
        }
        return false
    }
    
    func checkNicknameAvailability(_ nickname: String) -> Observable<Bool> {
        // 서버와 통신하여 닉네임 사용 가능 여부 확인
        return Observable<Bool>.just(true).delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트와 새로운 텍스트 결합
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 12자 초과 시 흔들림 효과 및 입력 방지
        if newText.count > 13{
            shakeTextField()
            self.warningLabel.text = "최대 12자까지만 입력 가능합니다."
            self.warningLabel.textColor = UIColor(hexCode: "FF3B30")
            return false
        }else if !isValidHangul(newText){
            shakeTextField()
            self.warningLabel.text = "한글, 영어, 숫자만 사용할 수 있어요. (최대 12자)"
            self.warningLabel.textColor = UIColor(hexCode: "FF3B30")
            return false
        }else{
            return true
        }
    }
    func shakeTextField() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.values = [
            NSValue(cgPoint: CGPoint(x: nickNameField.center.x, y: nickNameField.center.y-5)),
            NSValue(cgPoint: CGPoint(x: nickNameField.center.x, y: nickNameField.center.y+5))
        ]
        animation.autoreverses = true
        animation.repeatCount = 1
        nickNameField.layer.add(animation, forKey: "position")
    }
}
