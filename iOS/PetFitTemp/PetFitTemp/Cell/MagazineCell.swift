//
//  MagazineCell.swift
//  petfit
//
//  Created by 서혜림 on 7/31/24.
//

import UIKit

class MagazineCell: UICollectionViewCell {
    static let reuseIdentifier = "MagazineCell"
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.26
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dog
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "자연 친화적인 라이프스타일을 위한 환경 보호 방법"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "건강과 지속 가능성을 추구하는 이들을 위해, 맛과 영양이 가득한 채식 요리 레시피를 소개합니다. 이 글에서는 간단하지만 맛있는 채식 요리 10가지를 선보입니다. 첫 번째 레시피는 아보카도 토스트, 아침 식사로 완벽하며 영양소가 풍부합니다. 두 번째는 콩과 야채를 사용한 푸짐한 채식 칠리, 포만감을 주는 동시에 영양소를 공급합니다. 세 번째는 색다른 맛의 채식 패드타이, 고소한 땅콩 소스로 풍미를 더합니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainView)
        mainView.addSubview(mainImageView)
        mainView.addSubview(mainLabel)
        mainView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainView.widthAnchor.constraint(equalToConstant: 361),
            mainView.heightAnchor.constraint(equalToConstant: 410),
            
            mainImageView.topAnchor.constraint(equalTo: mainView.topAnchor),
            mainImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            mainImageView.widthAnchor.constraint(equalTo: mainView.widthAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 203),
            
            mainLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            mainLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            mainLabel.widthAnchor.constraint(equalToConstant: 313),
            mainLabel.heightAnchor.constraint(equalToConstant: 49),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 12),
            descriptionLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 313),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 96)
        ])
        
        applyCornerRadiusToImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyCornerRadiusToImageView() {
        let path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: 361, height: 203),
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        mainImageView.layer.mask = maskLayer
    }
    
    func applyActiveState() {
        mainView.layer.shadowOpacity = 0.26
        transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
    }
    
    func applyInactiveState() {
        mainView.layer.shadowOpacity = 0.0
        transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
    }
}
