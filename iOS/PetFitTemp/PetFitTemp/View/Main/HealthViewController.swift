//
//  HealthViewController.swift
//  petfit
//
//  Created by 서혜림 on 7/31/24.
//

import UIKit

class HealthViewController: UIViewController {

    var magazineCollectionViewController: MagazineCollectionView!
    var postCollectionView: UICollectionView!
    var scrollView: UIScrollView!
    var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        configureMagazineCollectionViewController()
        configurePostCollectionView()
        adjustContentViewHeight()
    }

    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func configureMagazineCollectionViewController() {
        magazineCollectionViewController = MagazineCollectionView()
        addChild(magazineCollectionViewController)
        contentView.addSubview(magazineCollectionViewController.view)
        
        magazineCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            magazineCollectionViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 66),
            magazineCollectionViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            magazineCollectionViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            magazineCollectionViewController.view.heightAnchor.constraint(equalToConstant: 604)
        ])
        magazineCollectionViewController.didMove(toParent: self)
    }
    
    private func configurePostCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            return HealthViewController.createPostSectionLayout()
        }
        
        postCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        postCollectionView.backgroundColor = .white
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postCollectionView.isScrollEnabled = false
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        postCollectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        
        contentView.addSubview(postCollectionView)
        
        NSLayoutConstraint.activate([
            postCollectionView.topAnchor.constraint(equalTo: magazineCollectionViewController.view.bottomAnchor),
            postCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postCollectionView.heightAnchor.constraint(equalToConstant: 2210)
        ])
    }

    private func adjustContentViewHeight() {
        let contentViewHeight = 538 + 2210 // 임시로 설정, 수정 필요
        contentView.heightAnchor.constraint(equalToConstant: CGFloat(contentViewHeight)).isActive = true
    }

    static func createPostSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(221))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(221))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 19
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

extension HealthViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseIdentifier, for: indexPath) as! PostCell
        return cell
    }
}

extension HealthViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at \(indexPath.row)")
    }
}
