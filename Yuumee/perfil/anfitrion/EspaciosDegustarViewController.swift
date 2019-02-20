//
//  EspaciosDegustarViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/23/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire


class EspaciosDegustarViewController: BaseViewController {
    
    let defaultId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle  = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultId)
        return tableView
    }()

    var lugares = ["Terraza", "Jardín", "Comedor", "Corredor", "Casa", "Otros"]
    
    var ids: [String] = []
    
    let textView = UITextView()
    
    let guardar: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Guardar", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.cornerRadius = 15
        button.addBorder(borderColor: .lightGray, widthBorder: 1)
        return button
    }()
    
    private lazy var toolbarView: UIToolbar = {
        let rectFrame = CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 40)
        let toolbar   = UIToolbar(frame: rectFrame)
        //toolbar.barStyle = .blackTranslucent
        toolbar.barTintColor = .white
        //toolbar.tintColor = .lightGray
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain,
                                           target: self, action: #selector(cancelPressed) )
        let doneButton = UIBarButtonItem(title: "Ok", style: .done, target: self,
                                         action: #selector(donePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                         target: self, action: nil)
        toolbar.setItems([cancelButton, flexButton, doneButton], animated: true)
        return toolbar
    }()
    
    
    @objc func cancelPressed() {
        textView.resignFirstResponder()
    }
    
    @objc func donePressed() {
        textView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        let backButton = UIBarButtonItem()
        backButton.title = "Regresar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
        mainView.addSubview(textView)
        mainView.addSubview(tableView)
        mainView.addSubview(guardar)
        
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: textView)
        mainView.addConstraintsWithFormat(format: "H:[v0(120)]-|", views: guardar)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]-[v1(50)]-[v2(40)]-|",
                                          views: tableView, textView, guardar)
        
        guardar.addTarget(self, action: #selector(sendRequestSpace) , for: .touchUpInside)
        
        textView.delegate = self
        textView.textColor = UIColor.black
        textView.backgroundColor = .gris
        placeholderLabel.text = "Ingresa algo de texto..."
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (placeholderLabel.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.gray
        placeholderLabel.isHidden = !textView.text.isEmpty
        textView.inputAccessoryView = toolbarView
    }
    
    let dataStorage = UserDefaults.standard
    
    var spaceOther = ""
    
    @objc func sendRequestSpace(sender: UIButton) {
        
        if (idsEspacios["6"]!) {
            
            if textView.text!.isEmpty {
                let alert = UIAlertController(title: "Campo requerido.",
                                              message: "Es necesario un platillo para este espacio.",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return;
            }
            
            spaceOther = textView.text!
        }
        
        let parameters: Parameters=["funcion" : "saveSpaces",
                                    "id_user": dataStorage.getUserId(),
                                    "space1" : idsEspacios["1"]! ? "1" : 0,
                                    "space2" : idsEspacios["2"]! ? "2" : 0,
                                    "space3" : idsEspacios["3"]! ? "3" : 0,
                                    "space4" : idsEspacios["4"]! ? "4" : 0,
                                    "space5" : idsEspacios["5"]! ? "5" : 0,
                                    "space6" : idsEspacios["6"]! ? "6" : 0,
                                    "space_other" : spaceOther] as [String: Any]
        
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
                            Utils.showSimpleAlert(message: "Información actualizada.",
                                                  context: self,
                                                  success: {(alert: UIAlertAction!) in
                                self.navigationController?.popViewController(animated: true)
                            })
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
        
        
    }
    
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        self.view.frame.origin.y -= 200
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        self.view.frame.origin.y += 200
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let parameters: Parameters = ["funcion" : "getSpaces",
                                      "id_user": dataStorage.getUserId()] as [String: Any]
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
                            if let espacios = result["data"] as? [Dictionary<String, AnyObject>] {
                                
                                for e in espacios {
                                    let newE = Espacio(espacioArray: e)
                                    self.ids.append(newE.id)
                                    
                                    self.idsEspacios["\(newE.id)"] = true
                                    
                                    if newE.id == "6" {
                                        self.spaceOther = newE.descripcion
                                    }
                                    
                                }
                                
                                self.tableView.reloadData()
                                
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.",
                                                          message: "\(statusMsg!)",
                                preferredStyle: UIAlertController.Style.alert)
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
    }
    
    
    //var idsEspacios: [String] = [String]()
    var idsEspacios: Dictionary<String, Bool> = ["1": false, "2": false,
                                                 "3": false, "4": false,
                                                 "5": false, "6": false]
    
    @objc func lugarParaDegustarEvent(sender: CustomSwitch) {
        
        let isActivated = sender.isOn
        
        idsEspacios["\(sender.tag)"] = isActivated
        
        /*
        if isActivated {
            // Agrega al array el nuevo ID
            if !idsEspacios.contains("\(sender.tag)") {
                idsEspacios.append("\(sender.tag)")
            }
        }
        else{
            // Remueve del array el ID que llegue
            if let index = idsEspacios.index(of: "\(sender.tag)") {
                idsEspacios.remove(at: index)
            }
        }*/
        
        /*
         switchNotifications.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
         if dataStorage.isNotificationActivated()! {
         switchNotifications.isOn = true
         }
         else{
         switchNotifications.isOn = false
         }
         self.switchPush.setOn(on: !self.switchPush.isOn, animated: true)
         */
    }
    
    
    
    let placeholderLabel = UILabel()
    
    
}

extension EspaciosDegustarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lugares.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lugar = lugares[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultId, for: indexPath)
        cell.textLabel?.textColor = .darkGray
        let tagId = indexPath.row + 1
        
        let frame: CGRect = CGRect(x: 50, y: 50, width: 55, height: 25)
        let switchP = CustomSwitch(frame: frame)
        switchP.onTintColor  = UIColor.rosa
        switchP.offTintColor = UIColor.black
        switchP.cornerRadius = 0.5
        switchP.thumbCornerRadius = 0.5
        switchP.thumbSize = CGSize(width: 30, height: 30)
        switchP.thumbTintColor = UIColor.white
        
        if ids.contains("\(tagId)") {
            // idsEspacios.append("\(sender.tag)")
            switchP.isOn = true
        }
        else{
            switchP.isOn = false
        }
        
        switchP.padding = 0
        switchP.animationDuration = 0.25
        switchP.addTarget(self, action: #selector(lugarParaDegustarEvent), for: .valueChanged)
        
        switchP.tag = tagId
        
        
        if tagId == 6 {
            
            cell.textLabel?.text = spaceOther
            
        }
        else{
            cell.textLabel?.text = lugar
        }
        
        cell.textLabel?.tag = tagId
        
        cell.accessoryView = switchP
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}



extension EspaciosDegustarViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}





struct Espacio {
    
    var id: String = ""
    var descripcion: String = ""
    
    init(espacioArray: Dictionary<String, AnyObject>) {
        self.id = espacioArray["Id"] as! String
        if let desc = espacioArray["descripcion"] as? String {
            self.descripcion = desc
        }
    }
    
}
