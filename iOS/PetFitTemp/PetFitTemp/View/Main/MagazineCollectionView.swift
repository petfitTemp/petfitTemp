//
//  MagazineCollectionView.swift
//  petfit
//
//  Created by 서혜림 on 8/5/24.
//

import UIKit

class MagazineCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    let pageControl = PageControlView()
    let numberOfItems = 5
    private var separateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCollectionView()
        setupPageControl()
        setupView()
    }
    
    func setupCollectionView() {
        let layout = CustomFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 361, height: 410)
        layout.minimumLineSpacing = 8
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MagazineCell.self, forCellWithReuseIdentifier: MagazineCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 98),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 426)
        ])
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = numberOfItems
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControl.widthAnchor.constraint(equalToConstant: 128),
            pageControl.heightAnchor.constraint(equalToConstant: 24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupView() {
        separateView = UIView()
        separateView.backgroundColor = .lightGray
        separateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separateView)
        
        NSLayoutConstraint.activate([
            separateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separateView.heightAnchor.constraint(equalToConstant: 8),
            separateView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 18)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineCell.reuseIdentifier, for: indexPath) as! MagazineCell
        // 셀 설정
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at \(indexPath.row)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / (361 + 8))
        pageControl.currentPage = Int(page)
    }
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    let inactiveScale: CGFloat = 0.95
    let activeScale: CGFloat = 1.0
    let activeDistance: CGFloat = 200
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = 8
        itemSize = CGSize(width: 361, height: 410)
        
        let horizontalInset = (collectionView!.bounds.width - itemSize.width) / 2
        collectionView!.contentInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        let center = collectionView!.contentOffset.x + collectionView!.bounds.size.width / 2
        for attribute in attributes {
            let distance = abs(attribute.center.x - center)
            let cell = collectionView!.cellForItem(at: attribute.indexPath) as? MagazineCell
            if distance < activeDistance {
                attribute.transform3D = CATransform3DMakeScale(activeScale, activeScale, 1.0)
                attribute.zIndex = 1
                cell?.applyActiveState()
            } else {
                attribute.transform3D = CATransform3DMakeScale(inactiveScale, inactiveScale, 1.0)
                attribute.zIndex = 0
                cell?.applyInactiveState()
            }
        }
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let layoutAttributes = layoutAttributesForElements(in: collectionView!.bounds)
        let center = proposedContentOffset.x + collectionView!.bounds.size.width / 2
        let closest = layoutAttributes!.sorted {
            abs($0.center.x - center) < abs($1.center.x - center)
        }.first ?? UICollectionViewLayoutAttributes()
        let targetOffset = CGPoint(x: closest.center.x - collectionView!.bounds.size.width / 2, y: proposedContentOffset.y)
        return targetOffset
    }
}
