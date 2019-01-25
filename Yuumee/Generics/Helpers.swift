//
//  Helpers.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/11/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ScreenSize {
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
}



enum TipoTarjeta: String {
    case american_express = "AMEX" // 3
    case visa             = "VISA" // 4
    case master_card      = "MASTER CARD" // 5
}


enum TipoUsuario: Int {
    case anfitrion = 2
    case cliente   = 3
}


enum TipoComida: String {
    case desayuno = "1"
    case comida   = "2"
    case cena     = "3"
}

class Utils {
    
    typealias callbackAlert = ((UIAlertAction) -> Void)?
    
    static func showSimpleAlert(message: String!, context: UIViewController, success: callbackAlert ) {
        let alertController = UIAlertController(title: "Yuumee",
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let dismissAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: success)
        alertController.addAction(dismissAction)
        context.present(alertController, animated: true, completion: nil)
    }
    
}




struct ParameterQueryEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = parameters?
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
            .data(using: .utf8)
        return request
    }
}

class BaseURL {
    private static let scheme = "http://"
    private static var host = "easycode.mx/"
    private static let path = "yuumee/webservice/controller_last.php"
    
    /**
     * Retorna la URL base para hacer el request
     *
     */
    class func baseUrl() -> String {
        return scheme + host + path
    }
}




class CategoriasComidaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC) )
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let secciones = ["Regional", "Ocasional", "Mediterranea", "Chida", "Una mas"]
    
    var delegate: FoodSelected?
    
    var currentFood = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gris
        cerrarBtn.target = self
        self.navigationItem.leftBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let seccion = secciones[indexPath.row]
        if seccion == currentFood {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = seccion
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seccion = secciones[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.delegate?.getFoodSelected(food: seccion)
        })
    }
    
}
protocol FoodSelected {
    func getFoodSelected(food: String)
}




class WebViewController: UIViewController, UIWebViewDelegate {
    var mainView: UIView {
        return self.view
    }
    
    var url: String?
    var titleVC: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        let imageBtn = UIImage(named: "back")?.imageResize(sizeChange: CGSize(width: 30.0, height: 30.0))
        let back = UIButton(type: .system)
        back.setImage(imageBtn, for: .normal)
        //back.setTitle(titleVC, for: .normal)
        back.titleLabel?.textColor = .white
        back.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        back.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        back.addTarget(self, action: #selector(regresar), for: .touchUpInside)
        back.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
        let webView = UIWebView()
        mainView.addSubview(webView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: webView)
        mainView.addConstraintsWithFormat(format: "V:|[v0]|", views: webView)
        if !(url?.isEmpty)! {
            let url = NSURL(string: self.url!)
            let requestObj = NSURLRequest(url: url! as URL)
            webView.delegate = self
            webView.loadRequest(requestObj as URLRequest)
        }
    }
    
    @objc func regresar() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}




let TAG_DESCRIPCION_EVENT: Int  = 121212

let TAG_MENU_EVENT: Int         = 213141
let TAG_BEBIDAS_EVENT: Int      = 146777
let TAG_POSTRES_EVENT: Int      = 324566

let TAG_COSTO_MENU_EVENT: Int   = 214532
let TAG_COSTO_BEBIDAS_EVENT:Int = 121980
let TAG_COSTO_POSTRES_EVENT:Int = 232167

let TAG_TITULO_EVENT: Int       = 989876
let TAG_COMIENZA_EVENT: Int     = 565678
let TAG_TERMINA_EVENT: Int      = 324564


/*
class ComidasCategoriasPaisesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC) )
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let secciones = ["Italiana", "Francesa", "Americana", "Asiática", "Otros"]
    
    var delegate: FoodCategorySelectedCountry?
    
    var currentFood = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gris
        cerrarBtn.target = self
        self.navigationItem.leftBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let seccion = secciones[indexPath.row]
        if seccion == currentFood {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = seccion
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seccion = secciones[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.delegate?.getFoodSelected(food: seccion)
        })
    }
    
}

protocol FoodCategorySelectedCountry {
    func getFoodSelected(food: String)
}

 
 
--------------------------------------------------------------------------------
echo getCategories($_POST['id_user']);
echo getSubCategories($_POST['id_cat']);
 
 
 case 'uploadImage_event':
 
 let parameters: Parameters = ["funcion" : "uploadImage_event", "image": ""] as [String: Any]
 
 
 case 'saveEvent'://PROBADA
 let parameters: Parameters=["funcion"    : "saveEvent",
 "id_user"    : idDownloaded,
 "name" : "",
 "description": "",
 "menu" : "",
 "menu_cost" : "",
 "drinks" : "",
 "drinks_cost" : "",
 "dessert" : "",
 "dessert_cost" : "",
 "date_event" : "",
 "start_time" : "",
 "end_time" : "",
 "capacity" : "",
 "costo" : "",
 "type" : "",
 "id_cat" : "",
 "id_sub_cat" : "",
 "image" : "",
 "extra_products" : ""] as [String: Any]
 let headers: HTTPHeaders = ["Accept": "application/json",
 "Content-Type" : "application/x-www-form-urlencoded"]
 Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
 { (response: DataResponse) in
 switch(response.result) {
 case .success(let value):
 if let result = value as? Dictionary<String, Any> {
 let statusMsg = result["status_msg"] as? String
 let state     = result["state"] as? String
 if statusMsg == "OK" && state == "200" {
 let alert = UIAlertController(title: "Información actualizada.", message: "", preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 return;
 }
 else{
 let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.", message: "\(statusMsg!)", preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 return;
 }
 }
 //completionHandler(value as? NSDictionary, nil)
 break
 case .failure(let error):
 //completionHandler(nil, error as NSError?)
 //print(" error:  ")
 //print(error)
 break
 }
 }
 
 
 
 
 
 
 case 'cancelEvent'://PROBADA
 
 let parameters: Parameters = ["funcion" : "cancelEvent",
 "id_user": "", "id_event" : ""] as [String: Any]
 let headers: HTTPHeaders = ["Accept": "application/json",
 "Content-Type" : "application/x-www-form-urlencoded"]
 Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
 { (response: DataResponse) in
 switch(response.result) {
 case .success(let value):
 if let result = value as? Dictionary<String, Any> {
 let statusMsg = result["status_msg"] as? String
 let state     = result["state"] as? String
 if statusMsg == "OK" && state == "200" {
 let alert = UIAlertController(title: "Información actualizada.", message: "", preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 return;
 }
 else{
 let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.", message: "\(statusMsg!)", preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 return;
 }
 }
 //completionHandler(value as? NSDictionary, nil)
 break
 case .failure(let error):
 //completionHandler(nil, error as NSError?)
 //print(" error:  ")
 //print(error)
 break
 }
 }
 
 
 
 
 
 
 
 
 
 case 'getSpaces':
 
 let parameters: Parameters = ["funcion" : "getSpaces",
 "id_user": ""] as [String: Any]
 let headers: HTTPHeaders = ["Accept": "application/json",
 "Content-Type" : "application/x-www-form-urlencoded"]
 Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
 { (response: DataResponse) in
 switch(response.result) {
 case .success(let value):
 if let result = value as? Dictionary<String, Any> {
 let statusMsg = result["status_msg"] as? String
 let state     = result["state"] as? String
 if statusMsg == "OK" && state == "200" {
 let alert = UIAlertController(title: "Información actualizada.", message: "", preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 return;
 }
 else{
 let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.", message: "\(statusMsg!)", preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 return;
 }
 }
 //completionHandler(value as? NSDictionary, nil)
 break
 case .failure(let error):
 //completionHandler(nil, error as NSError?)
 //print(" error:  ")
 //print(error)
 break
 }
 }
 
 
 case 'saveSpaces':
 
 let parameters: Parameters=["funcion" : "saveSpaces",
 "id_user": "",
 "space1" : "",
 "space2" : "",
 "space3" : "",
 "space4" : "",
 "space5" : "",
 "space6" : "",
 "space_other" : ""] as [String: Any]
 let headers: HTTPHeaders = ["Accept": "application/json",
 "Content-Type" : "application/x-www-form-urlencoded"]
 Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
 { (response: DataResponse) in
 switch(response.result) {
 case .success(let value):
 if let result = value as? Dictionary<String, Any> {
 let statusMsg = result["status_msg"] as? String
 let state     = result["state"] as? String
 if statusMsg == "OK" && state == "200" {
 let alert = UIAlertController(title: "Información actualizada.", message: "", preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 return;
 }
 else{
 let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.", message: "\(statusMsg!)", preferredStyle: UIAlertController.Style.alert)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 return;
 }
 }
 //completionHandler(value as? NSDictionary, nil)
 break
 case .failure(let error):
 //completionHandler(nil, error as NSError?)
 //print(" error:  ")
 //print(error)
 break
 }
 }
 

 
 
*/




