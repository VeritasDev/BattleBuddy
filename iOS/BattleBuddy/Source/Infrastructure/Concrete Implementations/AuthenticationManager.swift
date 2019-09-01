//
//  AuthManagerOld.swift
//  BattleBuddy
//
//  Created by Mike on 6/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import JWTDecode

protocol AuthenticationDelegate {
    func didAuthenticateSuccessfully()
    func didFailToAuthenticate()
}

class AuthManagerOld {
    var delegate: AuthenticationDelegate?
    let apiKeyFilename = "keys"
    let apiKeyFileType: String = "txt"
    var apiKey: String?
    let baseUrl: String = "https://api.tarkov-database.com/v2/"
    let tokenRoute: String = "token"
    let authTokenKey: String = "PersistedAuthToken"
    var authToken: String?
    var isAuthorized: Bool {
        guard let token = authToken else { return false }
        guard let jwt = try? decode(jwt: token) else { return false }
        return !jwt.expired
    }

    // TODO: Don't store token in user defaults
    init() {
        loadApiKey()
        authToken = UserDefaults.standard.string(forKey: authTokenKey)
    }

    func loadApiKey() {
        guard let apiKeyPath = Bundle.main.path(forResource: apiKeyFilename, ofType: apiKeyFileType) else {
            print("No API key present in main bundle.")
            return
        }

        do {
            let apiKeyFilePath = URL(fileURLWithPath: apiKeyPath)
            apiKey = try String(contentsOf: apiKeyFilePath, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            print("No API key present in main bundle.")
        }
    }

    func refreshToken(delegate: AuthenticationDelegate) {
        self.delegate = delegate

        if self.isAuthorized {
            print("Cached token still valid.")
            self.delegate!.didAuthenticateSuccessfully()
            return
        }

        authToken = nil

        guard let apiKey = apiKey else {
            delegate.didFailToAuthenticate()
            return
        }

        let authValue: String = "Bearer " + apiKey
        let headers = ["authorization": authValue]
        let url = baseUrl + tokenRoute
        DependencyManager.shared.httpRequestor.sendGetRequest(url: url, headers: headers) { json in
            guard let json = json as [String: Any]?, let token = json["token"] as? String else {
                self.delegate!.didFailToAuthenticate(); return
            }

            print("Received updated auth token.")
            self.authToken = token

            UserDefaults.standard.set(token, forKey: self.authTokenKey)

            self.delegate!.didAuthenticateSuccessfully()
        }
    }
}
