//
//  UserDefaultsStorage.swift
//  Yuumee
//
//  Created by Easy Code on 1/7/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import Foundation

// Keys Userdefaults
enum UserDefaultKeys: String {
    
    case isLoggedIn
    case userId
    case firstName
    case lastName
    case email
    case tipo
    case token
    case lastLatitude
    case lastLongitude
    case notificationsActive
    case avatarFacebook
    case isLoggedInFacebook
    
    case lastDateEventSelected
    case lastFoodSelectedEvent
    
}

// -----------------------------------------------------------------------------
// UserDefaults
// -----------------------------------------------------------------------------

extension UserDefaults {
    
    // ---------------------- INFORMACION DE USUARIO ---------------------------
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    func setUserId(userId: String) {
        set(userId, forKey: UserDefaultKeys.userId.rawValue)
    }
    
    func getUserId() -> String {
        return string(forKey: UserDefaultKeys.userId.rawValue) ?? ""
    }
    
    func setFirstName(firstName: String) {
        set(firstName, forKey: UserDefaultKeys.firstName.rawValue)
    }
    
    func getFirstName() -> String {
        return string(forKey: UserDefaultKeys.firstName.rawValue)!
    }
    
    func setLastName(lastName: String) {
        set(lastName, forKey: UserDefaultKeys.lastName.rawValue)
    }
    
    func getLastName() -> String {
        return string(forKey: UserDefaultKeys.lastName.rawValue)!
    }
    
    func setEmail(email: String) {
        set(email, forKey: UserDefaultKeys.email.rawValue)
    }
    
    func getEmail() -> String {
        return string(forKey: UserDefaultKeys.email.rawValue)!
    }
    
    func setTipo(tipo: String) {
        set(tipo, forKey: UserDefaultKeys.tipo.rawValue)
    }
    
    func getTipo() -> String {
        return string(forKey: UserDefaultKeys.tipo.rawValue)!
    }
    
    
    
    // Ultima fecha seleccionada del evento
    //
    func setDate(tipo: String) {
        set(tipo, forKey: UserDefaultKeys.lastDateEventSelected.rawValue)
    }
    func getDate() -> String {
        return string(forKey: UserDefaultKeys.lastDateEventSelected.rawValue)!
    }
    
    // Ultima comida seleccionada del evento
    //
    func setLastFoodSelectedEvent(tipo: String) {
        set(tipo, forKey: UserDefaultKeys.lastFoodSelectedEvent.rawValue)
    }
    func getLastFoodSelectedEvent() -> String {
        return string(forKey: UserDefaultKeys.lastFoodSelectedEvent.rawValue)!
    }
    
    
    
    
    
    // Latitud
    func setLatitud(tipo: String) {
        set(tipo, forKey: UserDefaultKeys.lastLatitude.rawValue)
    }
    func getLatitud() -> String {
        return string(forKey: UserDefaultKeys.lastLatitude.rawValue)!
    }
    
    // Longitud
    func setLongitud(tipo: String) {
        set(tipo, forKey: UserDefaultKeys.lastLongitude.rawValue)
    }
    func getLongitud() -> String {
        return string(forKey: UserDefaultKeys.lastLongitude.rawValue)!
    }
    
    
    
    // -------------------------------------------------------------------------
    //                  F A C E B O O K
    // -------------------------------------------------------------------------
    func setLoggedInFacebook(value: Bool) {
        set(value, forKey: UserDefaultKeys.isLoggedInFacebook.rawValue)
    }
    func isLoggedInFacebook() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedInFacebook.rawValue)
    }
    func setAvatarFacebook(userId: String) {
        set(userId, forKey: UserDefaultKeys.avatarFacebook.rawValue)
    }
    func getAvatarFacebook() -> String {
        return string(forKey: UserDefaultKeys.avatarFacebook.rawValue)!
    }
    // -------------------------------------------------------------------------
    
    
    
    
    // ------------------------ SETEAR/OBTENER TOKEN ---------------------------
    func setToken(token: String) {
        set(token, forKey: UserDefaultKeys.token.rawValue)
    }
    func getToken() -> String? {
        return string(forKey: UserDefaultKeys.token.rawValue) ?? ""
    }
    
    
    // ---------------- ACTIVAR/DEASCTIVAR NOTIFICACIONES ----------------------
    func activateNotifications(activate: Bool = false) {
        set(activate, forKey: UserDefaultKeys.notificationsActive.rawValue)
    }
    func isNotificationActivated() -> Bool? {
        return bool(forKey: UserDefaultKeys.notificationsActive.rawValue)
    }
    
    
}

// -----------------------------------------------------------------------------

