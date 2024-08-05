//
//  MainPageViewController.swift
//  petfit
//
//  Created by 서혜림 on 7/31/24.
//

import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, CustomTabBarDelegate {

    var pages: [UIViewController] = [HealthVC(), InfoVC(), FoodVC()]
    var customTabBarView: CustomNaviViewController!
    var topNavView: UIView!
    var topView: UIView!
    var bottomView: UIView!
    var feedView: UIView!
    var writeView: UIView!
    var searchView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self

        setupTopView()
        setupBottomView()
        customTabBarView.delegate = self

        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }

    private func setupTopView() {
        topView = UIView()
        topView.backgroundColor = .white
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 150)
        ])

        topNavView = UIView()
        topNavView.backgroundColor = .white
        topView.addSubview(topNavView)
        topNavView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topNavView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 44), 
            topNavView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            topNavView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            topNavView.heightAnchor.constraint(equalToConstant: 48)
        ])

        let logo = UIImageView(image: UIImage(named: "Logo"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        topNavView.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.centerYAnchor.constraint(equalTo: topNavView.centerYAnchor),
            logo.leadingAnchor.constraint(equalTo: topNavView.leadingAnchor, constant: 16),
            logo.widthAnchor.constraint(equalToConstant: 86),
            logo.heightAnchor.constraint(equalToConstant: 21)
        ])

        let user = UIImageView(image: UIImage(named: "User"))
        user.translatesAutoresizingMaskIntoConstraints = false
        topNavView.addSubview(user)
        NSLayoutConstraint.activate([
            user.centerYAnchor.constraint(equalTo: topNavView.centerYAnchor),
            user.trailingAnchor.constraint(equalTo: topNavView.trailingAnchor, constant: -16),
            user.widthAnchor.constraint(equalToConstant: 32),
            user.heightAnchor.constraint(equalToConstant: 32)
        ])

        customTabBarView = CustomNaviViewController(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 46))
        topView.addSubview(customTabBarView)
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBarView.topAnchor.constraint(equalTo: topNavView.bottomAnchor, constant: 5),
            customTabBarView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            customTabBarView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            customTabBarView.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
    }

    private func setupBottomView() {
        bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 24
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.cornerCurve = .continuous
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.08
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomView.layer.shadowRadius = 20
        bottomView.layer.borderColor = UIColor.lightGray.cgColor
        bottomView.layer.borderWidth = 0.3
        view.addSubview(bottomView)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 76)
        ])
        
        setupBottomViewSubviews()
    }

    private func setupBottomViewSubviews() {
        let viewWidth = (view.frame.width - 32) / 3
        
        feedView = UIView()
        feedView.backgroundColor = .clear
        bottomView.addSubview(feedView)
        feedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            feedView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            feedView.widthAnchor.constraint(equalToConstant: viewWidth),
            feedView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        writeView = UIView()
        writeView.backgroundColor = .clear
        bottomView.addSubview(writeView)
        writeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            writeView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            writeView.leadingAnchor.constraint(equalTo: feedView.trailingAnchor),
            writeView.widthAnchor.constraint(equalToConstant: viewWidth),
            writeView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        searchView = UIView()
        searchView.backgroundColor = .clear
        bottomView.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: writeView.trailingAnchor),
            searchView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            searchView.widthAnchor.constraint(equalToConstant: viewWidth),
            searchView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        setupImageViews()
    }

    private func setupImageViews() {
        let feedImageView = UIImageView(image: UIImage(named: "FeedIcon"))
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        feedView.addSubview(feedImageView)
        NSLayoutConstraint.activate([
            feedImageView.centerXAnchor.constraint(equalTo: feedView.centerXAnchor),
            feedImageView.centerYAnchor.constraint(equalTo: feedView.centerYAnchor),
            feedImageView.widthAnchor.constraint(equalToConstant: 24),
            feedImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let writeImageView = UIImageView(image: UIImage(named: "WriteIcon"))
        writeImageView.translatesAutoresizingMaskIntoConstraints = false
        writeView.addSubview(writeImageView)
        NSLayoutConstraint.activate([
            writeImageView.centerXAnchor.constraint(equalTo: writeView.centerXAnchor),
            writeImageView.centerYAnchor.constraint(equalTo: writeView.centerYAnchor),
            writeImageView.widthAnchor.constraint(equalToConstant: 24),
            writeImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let searchImageView = UIImageView(image: UIImage(named: "SearchIcon"))
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchView.addSubview(searchImageView)
        NSLayoutConstraint.activate([
            searchImageView.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
            searchImageView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchImageView.widthAnchor.constraint(equalToConstant: 24),
            searchImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: currentVC) {
            customTabBarView.selectedIndex = index
            customTabBarView.tabBarCollectionView.reloadData()
            customTabBarView.updateIndicatorViewPosition(animated: true)
        }
    }

    func didSelectTab(at index: Int) {
        let currentIndex = pages.firstIndex(of: viewControllers!.first!)!
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
    }
}
