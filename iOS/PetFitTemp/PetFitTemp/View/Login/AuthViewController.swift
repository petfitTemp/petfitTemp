import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AuthViewController : BaseViewController {
    var greetingLabelL : UILabel!
    var greetingLabelS : UILabel!
    var phoneNumberLabel : UILabel!
    var codeTextField: UITextField!
    var digitLabels: [UILabel] = []
    var stackView : UIStackView!
    var reSendButton : UIButton!
    var warningImage : UIImageView!
    var warningLabel : UILabel!
    
    let disposeBag = DisposeBag()
    
    var phoneNumber : String!
    var countdownTimer: Timer?
    var resendTimer: Timer?
    var remainingTime = 180 // 3분(180초)
    var resendRemainingTime = 60 // 재전송 대기 시간(60초)
    
    override func viewDidLoad() {
        //서버 인증코드 요청
        super.viewDidLoad()
        configureUI()
        configureConstraint()
        configureUtil()
        configureBackButton()
        bindTextField()
        startCountdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        codeTextField.becomeFirstResponder()
    }
    
    override func configureUI() {
        view.backgroundColor = .systemBackground
        configureTextField()
        
        phoneNumberLabel = UILabel()
        phoneNumberLabel.text = phoneNumber
        phoneNumberLabel.font = UIFont.pretendardSemiBold(size: 16)
        phoneNumberLabel.textColor = .main
        
        greetingLabelL = UILabel()
        let text = "문자로 보내드린 \n인증번호를 입력해주세요."
        let attributedString = NSMutableAttributedString(string: text)

        let paragraphStyle = NSMutableParagraphStyle()
        let desiredLineHeight: CGFloat = 36 // 원하는 라인 높이 설정
        paragraphStyle.minimumLineHeight = desiredLineHeight
        paragraphStyle.maximumLineHeight = desiredLineHeight

        let font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let baselineOffset: CGFloat = (desiredLineHeight - font.lineHeight) / 2

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset,
            .font: font
        ]

        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))

        greetingLabelL.attributedText = attributedString
        greetingLabelL.numberOfLines = 2
        greetingLabelL.lineBreakMode = .byWordWrapping
        greetingLabelL.font = font
//        greetingLabelL.backgroundColor = .white
//        greetingLabelL.layer.borderColor = UIColor.black.cgColor
//        greetingLabelL.layer.borderWidth = 1
        greetingLabelL.textAlignment = .left
        
        greetingLabelS = UILabel()
        greetingLabelS.text = "3분 00초 이내에 입력해주세요."
        greetingLabelS.textColor = .deHighLight
        greetingLabelS.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        
        reSendButton = UIButton()
        reSendButton.setTitle("인증번호 다시 요청", for: .normal)
        reSendButton.backgroundColor = .deHighLightButton
        reSendButton.titleLabel?.font = .pretendardMedium(size: 10)
        reSendButton.setTitleColor(UIColor(hexCode: "7B7B7B"), for: .normal)
        reSendButton.layer.cornerRadius = 10
        
        warningImage = UIImageView(image: UIImage.alertCircle)
        
        warningLabel = UILabel()
        warningLabel.text = "휴대폰 번호 인증에 실패했어요."
        warningLabel.font = UIFont.pretendardRegular(size: 12)
        warningLabel.textColor = UIColor(hexCode: "CA0121")
        
        [warningImage,warningLabel].forEach{
            $0?.isHidden = true
        }
        
    }
    
    func configureTextField(){
        codeTextField = UITextField()
        codeTextField.keyboardType = .numberPad
        codeTextField.isHidden = true
        codeTextField.delegate = self
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        
        for _ in 0..<6 {
            let label = UILabel()
            label.backgroundColor = UIColor.deHighLightButton
            label.textAlignment = .center
            label.font = UIFont.robotoMedium(size: 22)
            label.layer.cornerRadius = 8
            label.layer.masksToBounds = true
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        [greetingLabelL, greetingLabelS,stackView,codeTextField, phoneNumberLabel, reSendButton, warningImage,warningLabel].forEach{
            self.view.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        phoneNumberLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(21)
        }
        
        greetingLabelL.snp.makeConstraints{
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
        
        greetingLabelS.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(greetingLabelL.snp.bottom).offset(4)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(greetingLabelS.snp.bottom).offset(32)
            $0.height.equalTo(42)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(234)
        }
        warningImage.snp.makeConstraints{
            $0.size.equalTo(16)
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        warningLabel.snp.makeConstraints{
            $0.leading.equalTo(warningImage.snp.trailing).offset(4)
            $0.centerY.equalTo(warningImage)
        }
        reSendButton.snp.makeConstraints{
            $0.top.equalTo(stackView.snp.bottom).offset(32)
            $0.height.equalTo(29)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(94)
        }
    }
    
    override func configureUtil() {
        super.configureUtil()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        codeTextField.becomeFirstResponder()
        
        // 1분에 1번으로 제한 해야함
        reSendButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.startResendCountdown()
            self?.remainingTime = 180
            self?.updateCountdownLabel()
            self?.startCountdown()
            // 서버 코드 재요청
        }).disposed(by: disposeBag)
    }
    
    @objc func handleTap() {
        codeTextField.becomeFirstResponder()
    }
    
    
    func bindTextField() {
        codeTextField.rx.text.orEmpty
            .map { String($0.prefix(6)) } // 최대 6자리까지만 허용
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                for i in 0..<self.digitLabels.count {
                    if i < text.count {
                        let index = text.index(text.startIndex, offsetBy: i)
                        self.digitLabels[i].text = String(text[index])
                        self.digitLabels[i].layer.borderColor = UIColor.clear.cgColor
                        self.digitLabels[i].layer.borderWidth = 0.0
                    } else {
                        self.digitLabels[i].text = ""
                        self.digitLabels[i].layer.borderColor = UIColor.clear.cgColor
                        self.digitLabels[i].layer.borderWidth = 0.0
                    }
                }
                
                // 다음 입력 위치의 borderColor 설정
                if text.count < self.digitLabels.count {
                    self.digitLabels[text.count].layer.borderColor = UIColor(hexCode: "521AFB").cgColor
                    self.digitLabels[text.count].layer.borderWidth = 1.5
                }

                // 텍스트가 "111111"이 아닌 경우 특정 액션 수행
                if text != "111111" && text.count == 6 {
                    self.shakeTextField()
                    self.digitLabels.forEach { $0.layer.borderColor = UIColor(hexCode: "FF3B30").cgColor }
                    self.digitLabels.forEach { $0.layer.borderWidth = 1.5 } // 여기에 borderWidth를 설정
                    self.warningImage.isHidden = false
                    self.warningLabel.isHidden = false
                } else if text == "111111" && text.count == 6 {
                    // 인증 성공
//                    print("인증 성공")
//                    self.digitLabels.forEach { $0.layer.borderColor = UIColor.clear.cgColor } // 인증 성공 시 테두리 색상 제거
//                    self.warningImage.isHidden = true
//                    self.warningLabel.isHidden = true
                    let nextVC = NickNameViewController()
                    nextVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func startCountdown() {
        countdownTimer?.invalidate()
        updateCountdownLabel()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateCountdownLabel()
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            // 여기에 타이머가 끝났을 때의 동작을 추가할 수 있습니다.
        }
    }
    
    func updateCountdownLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        greetingLabelS.text = String(format: "%d분 %02d초 이내에 입력해주세요.", minutes, seconds)
    }
    
    func startResendCountdown() {
        reSendButton.isEnabled = false
        resendRemainingTime = 30
        updateResendButtonTitle()
        resendTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateResendCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func updateResendCountdown() {
        if resendRemainingTime > 0 {
            resendRemainingTime -= 1
            updateResendButtonTitle()
        } else {
            resendTimer?.invalidate()
            resendTimer = nil
            reSendButton.isEnabled = true
            reSendButton.setTitle("인증번호 다시 요청", for: .normal)
        }
    }
    
    func updateResendButtonTitle() {
        reSendButton.setTitle("다시 요청 (\(resendRemainingTime))", for: .normal)
    }
    func shakeTextField() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.values = [
            NSValue(cgPoint: CGPoint(x: stackView.center.x, y: stackView.center.y-5)),
            NSValue(cgPoint: CGPoint(x: stackView.center.x, y: stackView.center.y+5))
        ]
        animation.autoreverses = true
        animation.repeatCount = 1
        stackView.layer.add(animation, forKey: "position")
    }
}

extension AuthViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        let newLength = currentText.count + string.count - range.length
        return newLength <= 6 // 6자리까지만 입력 허용
    }
}


