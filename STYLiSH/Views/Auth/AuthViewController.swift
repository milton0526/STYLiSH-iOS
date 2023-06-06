//
//  AuthViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/15.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class AuthViewController: STBaseViewController {

    @IBOutlet weak var contentView: UIView!

    private let userProvider = UserProvider()

    @IBOutlet weak var emailTextField: STOrderUserInputTextField!
    @IBOutlet weak var passwordTextField: STOrderUserInputTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.contentView.isHidden = false
        })
    }

    @IBAction func dismissView(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: false, completion: nil)
    }


//    @IBAction func onFacebookLogin() {
//        userProvider.loginWithFaceBook(from: self, completion: { [weak self] result in
//            switch result {
//            case .success(let token):
//                self?.onSTYLiSHSignIn(token: token)
//            case .failure:
//                LKProgressHUD.showSuccess(text: "Facebook 登入失敗!")
//            }
//        })
//    }

    @IBAction func signUpButtonAction(_ sender: UIButton) {
        let authStoryBoard = UIStoryboard(name: "Auth", bundle: nil)
        guard let signUpVC = authStoryBoard.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController else {
            return
        }

        if #available(iOS 16.0, *) {
            if let sheetVC = signUpVC.sheetPresentationController {
                sheetVC.detents = [.custom(resolver: { context in
                    context.maximumDetentValue * 0.5
                })]

            }
        } else {
            // Fallback on earlier versions
        }
        signUpVC.isModalInPresentation = true
        present(signUpVC, animated: true)
    }

    @IBAction func onSTYLiSHSignIn(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            showAlert()
            return
        }

        LKProgressHUD.show()

        userProvider.signInToSTYLiSH(email: email, password: password, completion: { [weak self] result in
            LKProgressHUD.dismiss()

            switch result {
            case .success:
                LKProgressHUD.showSuccess(text: "STYLiSH 登入成功")
            case .failure:
                LKProgressHUD.showSuccess(text: "STYLiSH 登入失敗!")
            }
            DispatchQueue.main.async {
                self?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        })
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Something went wrong!",
            message: "Please check your email and password",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
