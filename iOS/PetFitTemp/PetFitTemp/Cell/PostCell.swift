//
//  PostCell.swift
//  petfit
//
//  Created by 서혜림 on 7/31/24.
//

import UIKit

class PostCell: UICollectionViewCell {
    static let reuseIdentifier = "PostCell"
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let postInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentInfoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .comment
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likeInfoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .like
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let postInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subheadlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.image = .post
        imageView.layer.cornerRadius = 37
        imageView.layer.cornerCurve = .continuous
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainView)
        mainView.addSubview(postInfoView)
        mainView.addSubview(headlineLabel)
        mainView.addSubview(subheadlineLabel)
        mainView.addSubview(mainImageView)
        postInfoView.addSubview(postInfoLabel)
        postInfoView.addSubview(likeInfoView)
        postInfoView.addSubview(likeInfoLabel)
        postInfoView.addSubview(commentInfoView)
        postInfoView.addSubview(commentInfoLabel)
        
        setupText()
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            postInfoView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8),
            postInfoView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            postInfoView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            postInfoView.heightAnchor.constraint(equalToConstant: 16),
            
            postInfoLabel.centerYAnchor.constraint(equalTo: postInfoView.centerYAnchor),
            postInfoLabel.leadingAnchor.constraint(equalTo: postInfoView.leadingAnchor),
            
            likeInfoView.centerYAnchor.constraint(equalTo: postInfoView.centerYAnchor),
            likeInfoView.trailingAnchor.constraint(equalTo: likeInfoLabel.leadingAnchor, constant: -4),
            likeInfoView.heightAnchor.constraint(equalToConstant: 16),
            likeInfoView.widthAnchor.constraint(equalToConstant: 16),
            
            likeInfoLabel.centerYAnchor.constraint(equalTo: postInfoView.centerYAnchor),
            likeInfoLabel.trailingAnchor.constraint(equalTo: commentInfoView.leadingAnchor, constant: -8),
            
            commentInfoView.centerYAnchor.constraint(equalTo: postInfoView.centerYAnchor),
            commentInfoView.trailingAnchor.constraint(equalTo: commentInfoLabel.leadingAnchor, constant: -4),
            commentInfoView.heightAnchor.constraint(equalToConstant: 16),
            commentInfoView.widthAnchor.constraint(equalToConstant: 16),
            
            commentInfoLabel.centerYAnchor.constraint(equalTo: postInfoView.centerYAnchor),
            commentInfoLabel.trailingAnchor.constraint(equalTo: postInfoView.trailingAnchor),
            
            headlineLabel.topAnchor.constraint(equalTo: postInfoView.bottomAnchor, constant: 24),
            headlineLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            headlineLabel.trailingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: -8),
            
            subheadlineLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 24),
            subheadlineLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            subheadlineLabel.trailingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: -8),
            
            mainImageView.topAnchor.constraint(equalTo: postInfoView.bottomAnchor, constant: 24),
            mainImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            mainImageView.widthAnchor.constraint(equalToConstant: 108),
            mainImageView.heightAnchor.constraint(equalToConstant: 108)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupText() {
        setAttributedText(for: postInfoLabel, with: "작성자")
        setAttributedText(for: likeInfoLabel, with: "112")
        setAttributedText(for: commentInfoLabel, with: "112")
        setAttributedText(for: headlineLabel, with: "제목은 세 줄까지 노출됩니다 세 줄까지 노출됩니다 세 줄까지 노출됩니다 ")
        setAttributedText(for: subheadlineLabel, with: "본문은 두 줄까지 노출됩니다 본문은 두 줄까지 노출됩니다 본문은 두 줄까지 본문은 두 줄까지 노출됩니다 ")
    }
    
    private func setAttributedText(for label: UILabel, with text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 31.92 // 라인 높이 설정
        paragraphStyle.alignment = .left
//        paragraphStyle.minimumLineHeight = 31.92 // minimumLineHeight도 설정
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.kern, value: -0.04, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
    }
}
