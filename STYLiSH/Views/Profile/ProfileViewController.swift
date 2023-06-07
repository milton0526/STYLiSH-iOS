//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelInfo: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    private let manager = ProfileManager()
    
    private let userProvider = UserProvider()
    
    private var user: User? {
        didSet {
            if let user = user {
                updateUser(user)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setSellerIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    // MARK: - Action
    private func fetchData() {
        userProvider.getUserProfile(completion: { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
    
    private func setSellerIcon() {
        let setSellerIcon = UIImage.asset(.house_lodge_fill)
        let setSellerButton = UIBarButtonItem(image: setSellerIcon, style: .plain, target: self, action: #selector(sellerButtonTapped))
        setSellerButton.tintColor = UIColor(hex: "3F3A3A")
        navigationItem.leftBarButtonItem = setSellerButton
    }
    
    private func updateUser(_ user: User) {
        imageProfile.loadImage(user.picture, placeHolder: .asset(.Icons_36px_Profile_Normal))
        
        labelName.text = user.name
        labelInfo.text = user.getUserInfo()
        labelInfo.isHidden = false
    }

    @IBAction func signOutButtonClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "登出", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "確定", style: .default) { [weak self] _ in
            KeyChainManager.shared.token = nil

            self?.tabBarController?.selectedIndex = 0
            // update UI
        }

        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    
    @objc private func sellerButtonTapped() {
        let alert = UIAlertController(title: "進入我的賣場", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "返回", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        let confirmAction = UIAlertAction(title: "確定", style: .default) { [weak self]_ in
            let sellerVC = SellerProductViewController()
            let navVC = UINavigationController(rootViewController: sellerVC)
            navVC.modalPresentationStyle = .fullScreen
            self?.present(navVC, animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.groups.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.groups[section].items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )
        guard let profileCell = cell as? ProfileCollectionViewCell else { return cell }
        let item = manager.groups[indexPath.section].items[indexPath.row]
        profileCell.layoutCell(image: item.image, text: item.title)
        return profileCell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: ProfileCollectionReusableView.self),
                for: indexPath
            )
            guard let profileView = header as? ProfileCollectionReusableView else { return header }
            let group = manager.groups[indexPath.section]
            profileView.layoutView(title: group.title, actionText: group.action?.title)
            return profileView
        }
        return UICollectionReusableView()
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.width / 5.0, height: 60.0)
        } else if indexPath.section == 1 {
            return CGSize(width: UIScreen.width / 4.0, height: 60.0)
        }
        return CGSize.zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 24.0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: UIScreen.width, height: 48.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let historyIcon = IndexPath(item: 8, section: 1)

        if indexPath == historyIcon {
            let historyVC = HistoryViewController()
            navigationController?.pushViewController(historyVC, animated: true)
        } else {
            return
        }

    }
}
