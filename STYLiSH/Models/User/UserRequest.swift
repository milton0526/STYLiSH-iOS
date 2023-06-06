//
//  UserRequest.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

enum STUserRequest: STRequest {
    case signUp(name: String, email: String, password: String)
    case signin(email: String, password: String)
    case checkout(token: String, body: Data?)
    case profile(token: String)

    var headers: [String: String] {
        switch self {
        case .signUp:
            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
        case .signin:
            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
        case .checkout(let token, _):
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
        case .profile(let token):
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
        }
    }

    var body: Data? {
        switch self {
        case .signUp(let name, let email, let password):
            let dict = [
                "name": name,
                "email": email,
                "password": password
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .signin(let email, let password):
            let dict = [
                "provider": "native",
                "email": email,
                "password": password
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        case .checkout(_, let body):
            return body
        case .profile: return nil
        }
    }

    var method: String {
        switch self {
        case .signUp: return STHTTPMethod.POST.rawValue
        case .signin, .checkout: return STHTTPMethod.POST.rawValue
        case .profile: return STHTTPMethod.GET.rawValue
        }
    }

    var endPoint: String {
        switch self {
        case .signUp: return "/user/signup"
        case .signin: return "/user/signin"
        case .checkout: return "/order/checkout"
        case .profile: return "/user/profile"
        }
    }
}
