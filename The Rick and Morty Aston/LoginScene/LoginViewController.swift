//
//  LoginViewController.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 20.09.2022.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    lazy private var loginTF: UITextField = createTextField(
        placeholder: "Enter your email",
        keyboardType: .emailAddress,
        returnKeyType: .next,
        secureText: false,
        selector: #selector(checkEmail(sender:))
    )
    
    lazy private var passwordTF: UITextField = createTextField(
        placeholder: "Enter your password",
        keyboardType: .default,
        returnKeyType: .done,
        secureText: true
    )
    
    lazy private var confirmPasswordTF: UITextField = createTextField(
        placeholder: "Confirm your password",
        keyboardType: .default,
        returnKeyType: .done,
        isHidden: true,
        secureText: true,
        selector: #selector(confirmPassword(sender:))
    )
    
    lazy private var singInButton: UIButton = createButton(
        title: "SingIn",
        color: .systemBlue,
        action: #selector(singInButtonPressed)
    )
        
    lazy private var descriptionSingUpButton: UIButton = createButton(
        title: "SingUp",
        fontSize: 9,
        color: .systemBlue,
        action: #selector(descriptionSingUpButtonPressed)
    )
    
    lazy private var testAccountButton: UIButton = createButton(
        title: "Test Account",
        fontSize: 9,
        color: .systemBlue,
        action: #selector(testAccountButtonPressed)
    )
        
    lazy private var singUpButton: UIButton = createButton(
        title: "SingUp",
        color: .systemBlue,
        isHidden: true,
        action: #selector(singUpButtonPressed)
    )
    
    lazy private var cancelSingUpButton: UIButton = createButton(
        title: "Cancel",
        color: .systemRed,
        isHidden: true,
        action: #selector(cancelSingUpButtonPressed)
    )
    lazy private var firstDescriptionLabel: UILabel = createDescriptionLabel(
        text: "Also you can"
    )
    
    lazy private var secondDescriptionLabel: UILabel = createDescriptionLabel(
        text: "or use"
    )
    
    lazy private var textFieldStackView: UIStackView = createStackView(
        views: [loginTF, passwordTF, confirmPasswordTF],
        axis: .vertical,
        spacing: 8
    )
    lazy private var descriptionStackView: UIStackView = createStackView(
        views: [
            firstDescriptionLabel,
            descriptionSingUpButton,
            secondDescriptionLabel,
            testAccountButton
        ],
        axis: .horizontal,
        spacing: 4
    )
    lazy private var buttonStackView: UIStackView = createStackView(
        views: [
            singInButton,
            descriptionStackView,
            singUpButton,
            cancelSingUpButton
        ],
        axis: .vertical
    )
    // MARK: - Private properties
    private var loginViewModel: LoginViewModelProtocol
    // MARK: - Initialisers
    init(loginViewModel: LoginViewModelProtocol) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubviews([textFieldStackView, buttonStackView])
        textFieldStackView.setOnCenterSuperView()
        textFieldStackView.setConstraintsToSuperView(left: 16, right: -16)
        buttonStackView.setConstraintsToOtherView(
            otherView: textFieldStackView,
            below: 50
        )
        buttonStackView.setOnCenterSuperView(yOffset: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = loginViewModel.title
        
    }
    // MARK: - UIActions Methods
    @objc private func checkEmail(sender: UITextField) {
        guard let text = sender.text else { return }
        loginViewModel.checkEmailString(email: text) { isValid in
            if isValid {
                sender.attributedText = NSAttributedString(
                    string: text,
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.systemGreen
                    ]
                )
            } else {
                sender.textColor = .systemRed
            }
        }
    }
    
    @objc private func confirmPassword(sender: UITextField) {
        guard let first = passwordTF.text, let second = sender.text
        else {
            return
        }
        if loginViewModel.confirmNewPassword(first: first, second: second) {
            sender.attributedText = NSAttributedString(
                string: second,
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.systemGreen
                ]
            )
        } else {
            sender.textColor = .systemRed
        }
    }
    
    @objc private func singInButtonPressed() {
        if loginTF.text == "" {
            showAlert(with: "Please enter your e-mail")
            return
        }
        guard let email = loginTF.text, let password = passwordTF.text else { return }
        let result = loginViewModel.singIn(email: email, password: password)
        if !result.validEmail {
            showAlert(with: "User with this e-mail not registered")
        } else if result.validEmail && !result.validPassword {
            showAlert(with: "Wrong password")
        } else {
            loginViewModel.logIn()
        }
    }
    @objc private func descriptionSingUpButtonPressed() {
        changeView()
    }
    @objc private func testAccountButtonPressed() {
        let user = loginViewModel.createTestUser()
        loginTF.text = user.email
        passwordTF.text = user.password
    }
    @objc private func cancelSingUpButtonPressed() {
        changeView()
    }
    @objc private func singUpButtonPressed() {
        guard let email = loginTF.text
        else {
            showAlert(with: "Please enter your e-mail")
            return
        }
        guard let first = passwordTF.text,
              let second = confirmPasswordTF.text
        else {
            showAlert(with: "Wrong password")
            return
        }
        if loginViewModel.confirmNewPassword(first: first, second: second) {
            loginViewModel.singUp(email: email, password: first)
            changeView()
            loginTF.text = email
            passwordTF.text = first
        }
    }
    
    @objc private func kbWillShow(notification: NSNotification) {
        if let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
            as? NSValue)?
            .cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(
                    translationX: 0,
                    y: -keyboardSize.height / 2
                )
            }
        }
    }
    
    @objc private func kbWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // MARK: - Private Methods
    
    private func changeView() {
        confirmPasswordTF.isHidden.toggle()
        singUpButton.isHidden.toggle()
        cancelSingUpButton.isHidden.toggle()
        descriptionStackView.isHidden.toggle()
        singInButton.isHidden.toggle()
        loginViewModel.changeViewModel { viewModelType in
            title = viewModelType.rawValue
            switch viewModelType {
            case .logIn:
                passwordTF.returnKeyType = .done
            case .singUp:
                passwordTF.returnKeyType = .next
            }
        }
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - Creating UI elements

extension LoginViewController {
    private func createTextField(
        placeholder: String,
        keyboardType: UIKeyboardType,
        returnKeyType: UIReturnKeyType,
        isHidden: Bool = false,
        secureText: Bool,
        selector: Selector? = nil
    ) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white.withAlphaComponent(0.4)
        textField.keyboardType = keyboardType
        textField.clearButtonMode = .always
        textField.delegate = self
        textField.returnKeyType = returnKeyType
        textField.enablesReturnKeyAutomatically = true
        textField.isSecureTextEntry = secureText
        textField.isHidden = isHidden
        if let selector = selector {
            textField.addTarget(self, action: selector, for: .editingChanged)
        }
        return textField
    }
    private func createStackView(
        views: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat? = nil
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.addArrangedSubviews(views)
        if let spacing = spacing {
            stack.spacing = spacing
        }
        return stack
    }
    private func createDescriptionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 9)
        label.textColor = .lightGray
        return label
    }
    private func createButton(
        title: String,
        fontSize: CGFloat? = nil,
        color: UIColor,
        isHidden: Bool = false,
        action: Selector
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setTitleColor(color.withAlphaComponent(0.4), for: .highlighted)
        button.isHidden = isHidden
        if let fontSize = fontSize {
            button.titleLabel?.font = .systemFont(ofSize: fontSize)
        }
        return button
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            if confirmPasswordTF.isHidden {
                singInButtonPressed()
            } else {
                confirmPasswordTF.becomeFirstResponder()
            }
        case confirmPasswordTF:
            singUpButtonPressed()
        default:
            return false
        }
        return true
    }
}

// MARK: - AlertController

extension LoginViewController {
    
    private func showAlert(with title: String) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
