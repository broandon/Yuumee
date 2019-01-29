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
    case lastCategorySelectedEvent
    case lastSubCategorySelectedEvent
    case comienzaEvent
    case terminaEvent
    case lastImageSelected
    case lastTitle
    
    case urlAvatar
    case urlPortada
    
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
        return string(forKey: UserDefaultKeys.userId.rawValue) ?? "0"
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
    
    func getTipo() -> String? {
        return string(forKey: UserDefaultKeys.tipo.rawValue) ?? ""
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
    
    
    // Ultima categoria seleccionada del evento
    //
    func setLastCategorySelectedEvent(tipo: String) {
        set(tipo, forKey: UserDefaultKeys.lastCategorySelectedEvent.rawValue)
    }
    func getLastCategorySelectedEvent() -> String {
        return string(forKey: UserDefaultKeys.lastCategorySelectedEvent.rawValue)!
    }
    
    
    // Ultima SUB-Categoria seleccionada del evento
    //
    func setLastSubCategorySelectedEvent(tipo: String) {
        set(tipo, forKey: UserDefaultKeys.lastSubCategorySelectedEvent.rawValue)
    }
    func getLastSubCategorySelectedEvent() -> String {
        return string(forKey: UserDefaultKeys.lastSubCategorySelectedEvent.rawValue)!
    }
    
    
    
    // Hora de inicio del evento
    //
    func setComienzaEvent(hora: String) {
        set(hora, forKey: UserDefaultKeys.comienzaEvent.rawValue)
    }
    func getComienzaEvent() -> String {
        return string(forKey: UserDefaultKeys.comienzaEvent.rawValue)!
    }
    
    
    
    
    // Hora que termina del evento
    //
    func setTerminaEvent(hora: String) {
        set(hora, forKey: UserDefaultKeys.terminaEvent.rawValue)
    }
    func getTerminaEvent() -> String {
        return string(forKey: UserDefaultKeys.terminaEvent.rawValue)!
    }
    
    
    
    // Imagen selccionada
    //
    func setImagenEvent(hora: String) {
        set(hora, forKey: UserDefaultKeys.lastImageSelected.rawValue)
    }
    func getImagenEvent() -> String {
        return string(forKey: UserDefaultKeys.lastImageSelected.rawValue)!
    }
    
    
    
    // Titulo ingresado
    //
    func setLastTitle(title: String) {
        set(title, forKey: UserDefaultKeys.lastTitle.rawValue)
    }
    func getLastTitle() -> String {
        return string(forKey: UserDefaultKeys.lastTitle.rawValue)!
    }
    
    
    // IMAGEN DE PERFIL DEL ANFITRION
    //           AVATAR
    //
    func setUrlAvatar(url: String) {
        set(url, forKey: UserDefaultKeys.urlAvatar.rawValue)
    }
    func getUrlAvatar() -> String? {
        return string(forKey: UserDefaultKeys.urlAvatar.rawValue) ?? ""
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

