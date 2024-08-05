//
//  CustomNaviViewController.swift
//  petfit
//
//  Created by 서혜림 on 7/31/24.
//

import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func didSelectTab(at index: Int)
}

class CustomNaviViewController: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let tabTitles = ["건강", "정보", "음식"]
    internal var selectedIndex: Int = 0
    private var indicatorLeadingConstraint: NSLayoutConstraint!
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    weak var delegate: CustomTabBarDelegate?

    lazy var tabBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: "TabCell")
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        self.addSubview(tabBarCollectionView)
        tabBarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            tabBarCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .gray
        self.addSubview(bottomBorder)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBorder.heightAnchor.constraint(equalToConstant: 1),
            bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        let indicatorView = UIView()
        indicatorView.backgroundColor = .black
        self.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: 3),
            indicatorView.widthAnchor.constraint(equalToConstant: 120),
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorLeadingConstraint.isActive = true

        configureDataSource()
        updateIndicatorViewPosition(animated: false)
        
        DispatchQueue.main.async {
            self.tabBarCollectionView.selectItem(at: IndexPath(item: self.selectedIndex, section: 0), animated: false, scrollPosition: [])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: tabBarCollectionView) {
            (collectionView, indexPath, title) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as! TabCell
            cell.titleLabel.text = title
            cell.isSelected = indexPath.item == self.selectedIndex
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(tabTitles)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func updateIndicatorViewPosition(animated: Bool) {
        let indicatorPosition = CGFloat(selectedIndex * 120 + 18)
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.indicatorLeadingConstraint.constant = indicatorPosition
                self.layoutIfNeeded()
            }
        } else {
            self.indicatorLeadingConstraint.constant = indicatorPosition
            self.layoutIfNeeded()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(tabTitles)
        dataSource.apply(snapshot, animatingDifferences: true)
        updateIndicatorViewPosition(animated: true)
        delegate?.didSelectTab(at: selectedIndex) 
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: self.frame.height)
    }
}
