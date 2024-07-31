import UIKit

extension UILabel {
    @objc dynamic var autoFontText: String? {
        get { return self.text }
        set {
            guard let newValue = newValue else {
                self.text = nil
                return
            }
            let attributedString = NSMutableAttributedString(string: newValue)
            
            let koreanFont = UIFont.systemFont(ofSize: 24) ?? self.font
            let englishFont = UIFont(name: "Pretendard-Thin", size: self.font.pointSize) ?? self.font
            
            for (index, character) in newValue.enumerated() {
                if String(character).range(of: "[가-힣ㄱ-ㅎㅏ-ㅣ]", options: .regularExpression) != nil {
                    attributedString.addAttribute(.font, value: koreanFont, range: NSRange(location: index, length: 1))
                } else {
                    attributedString.addAttribute(.font, value: englishFont, range: NSRange(location: index, length: 1))
                }
            }
            
            self.attributedText = attributedString
        }
    }
}
