//
//  SignUpViewController.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/6.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SignUpViewController: STBaseViewController {


    @IBOutlet weak var nameTextField: STOrderUserInputTextField!
    @IBOutlet weak var emailTextField: STOrderUserInputTextField!
    @IBOutlet weak var passwordTextField: STOrderUserInputTextField!

    private let userProvider = UserProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        createUser()
    }

    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }

    private func createUser() {
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !name.isEmpty,
            !email.isEmpty,
            !password.isEmpty
        else {
            showAlert()
            return
        }

        signUpToStylish(name: name, email: email, password: password)
    }

    private func signUpToStylish(name: String, email: String, password: String) {
        LKProgressHUD.shared.hud.show(in: view)
        
        userProvider.signUpToSTYLiSH(name: name, email: email, password: password) { result in
            DispatchQueue.main.async {
                LKProgressHUD.shared.hud.dismiss()
            }
            
            switch result {
            case .success:
                LKProgressHUD.showSuccess(text: "STYLiSH 註冊成功")
            case .failure:
                LKProgressHUD.showSuccess(text: "STYLiSH 註冊失敗!")
            }

            DispatchQueue.main.async { [weak self] in
                self?.view.window?.rootViewController?.dismiss(animated: true)
            }
        }
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Something went wrong!",
            message: "Please check all field had information.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
