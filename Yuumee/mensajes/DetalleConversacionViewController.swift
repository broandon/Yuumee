//
//  DetalleConversacionViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/26/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetalleConversacionViewController: BaseViewController, UITextViewDelegate {
    
    let backButton: UIButton = {
        let imageBtn = UIImage(named: "close")?.imageResize(sizeChange: CGSize(width: 20.0, height: 20.0))
        let back = UIButton(type: .custom)
        back.setImage(imageBtn?.withRenderingMode(.alwaysTemplate), for: .normal)
        //back.setTitle("Evento", for: .normal)
        back.titleLabel?.textColor = .white
        back.tintColor = .white
        back.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        back.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        return back
    }()
    
    
    let cellConversation = "cellConversation"
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(CellConversation.self, forCellReuseIdentifier: cellConversation)
        //tableView.register(TableDataProfileCell.self, forCellReuseIdentifier: tableDataCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        //tableView.keyboardDismissMode = .onDrag
        //tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        return tableView
    }()
    
    
    let message: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10,left: 5,bottom: 10,right: 5)
        textView.layer.cornerRadius = 10
        textView.addBorder(borderColor: .lightGray, widthBorder: 1)
        textView.font = UIFont.systemFont(ofSize: 13)
        return textView
    }()
    
    /*
     let message: UITextField = {
     let textField = UITextField()
     textField.placeholder = "Escribir mensaje..."
     textField.backgroundColor = .white
     textField.addBottomBorderWithColor(color: Colors.hexStringToUIColor(hex: Colors.gray) , width: 2)
     textField.layer.cornerRadius = 15
     return textField
     }()
    */
    
    let postMessage: UIButton = {
        let size = CGSize(width: 24, height: 24)
        let image = UIImage(named: "post")?.imageResize(sizeChange: size)
        let button = UIButton(type: .custom)
        button.setImage(image , for: .normal)
        button.addTarget(self, action: #selector(postMessageToLayer), for: .touchUpInside)
        return button
    }()
    
    let containerMessage: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.gris
        return view
    }()
    
    var conversations: [Conversation] = []
    //var conversations: [String] = ["", "", ""]
    
    let dataStorage = UserDefaults.standard
    
    var idChat: String = ""
    
    var idSaucer: String = ""
    
    var titulo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        self.hideKeyboardWhenTappedAround()
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        backButton.setTitle(titulo, for: .normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationController?.navigationBar.barTintColor = UIColor.rosa
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.rosa]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        mainView.addSubview(tableView)
        mainView.addSubview(containerMessage)
        
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerMessage)
        mainView.addConstraintsWithFormat(format: "V:|-16-[v0]-[v1(60)]|",
                                          views: tableView, containerMessage)
        containerMessage.addSubview(message)
        containerMessage.addSubview(postMessage)
        containerMessage.addConstraintsWithFormat(format: "H:|-[v0]-[v1(35)]-|", views: message, postMessage)
        containerMessage.addConstraintsWithFormat(format: "V:|-[v0(40)]", views: message)
        containerMessage.addConstraintsWithFormat(format: "V:|-16-[v0(35)]", views: postMessage)
        message.delegate = self
        
        if !idChat.isEmpty {
            // ---------------------------------------------------------------------
            let headers: HTTPHeaders = [
                // "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                "Accept" : "application/json",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
            let parameters: Parameters = ["funcion" : "getChatDetail",
                                          "id_user" : dataStorage.getUserId(),
                                          "id_chat" : idChat] as [String: Any]
            Alamofire.request(BaseURL.baseUrl() , method: .post, parameters: parameters,
                              encoding: ParameterQueryEncoding(),
                              headers: headers).responseJSON{ (response: DataResponse) in
                                switch(response.result) {
                                case .success(let value):
                                    if let result = value as? Dictionary<String, Any> {
                                        let statusMsg = result["status_msg"] as? String
                                        let state     = result["state"] as? String
                                        if statusMsg == "OK" && state == "200" {
                                            if let data = result["data"] as? [Dictionary<String, AnyObject>] {
                                                for c in data {
                                                    let newC = Conversation(conversation: c)
                                                    self.conversations.append(newC)
                                                }
                                                if self.conversations.count > 0 {
                                                    self.tableView.reloadData()
                                                }
                                            }
                                        }
                                    }
                                    //completionHandler(value as? NSDictionary, nil)
                                    break
                                case .failure(let error):
                                    //completionHandler(nil, error as NSError?)
                                    print(error)
                                    print(error.localizedDescription)
                                    break
                                }
            }
            // ---------------------------------------------------------------------
        }
        
    } // viewDidLoad
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func keyboardWillAppear(notification: Notification){
        makeSpaceForKeyboard(notification: notification)
    }
    
    @objc func keyboardWillDisappear(notification: Notification){
        makeSpaceForKeyboard(notification: notification)
    }
    
    func makeSpaceForKeyboard(notification: Notification) {
        let info = notification.userInfo!
        let keyboardHeight:CGFloat = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        let duration:Double = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        if notification.name == UIResponder.keyboardWillShowNotification {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                frame.size.height = frame.size.height - keyboardHeight
                self.view.frame = frame
            })
        } else {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                frame.size.height = frame.size.height + keyboardHeight
                self.view.frame = frame
            })
        }
    }
    
    @objc func postMessageToLayer(sender: Any) {
        
        if (self.message.text?.isEmpty)! {
            return
        }
        
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            // "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters: Parameters = ["funcion" : "sendMessageChat",
                                      "id_user" : dataStorage.getUserId(),
                                      "id_saucer" : idChat,
                                      "tipo" : dataStorage.getTipo(),
                                      "message" : message.text!] as [String: Any]
        
        Alamofire.request(BaseURL.baseUrl() , method: .post, parameters: parameters,
                          encoding: ParameterQueryEncoding(),
                          headers: headers).responseJSON{ (response: DataResponse) in
                            switch(response.result) {
                            case .success(let value):
                                if let result = value as? Dictionary<String, Any> {
                                    let statusMsg = result["status_msg"] as? String
                                    let state     = result["state"] as? String
                                    if statusMsg == "OK" && state == "200" {
                                        
                                        if let data = result["data"] as? [Dictionary<String, AnyObject>] {
                                            
                                            let newMessage = ["Id": "0",
                                                              "comentarios": self.message.text!,
                                                              "persona": "\(self.dataStorage.getFirstName()) \(self.dataStorage.getLastName())",
                                                              "id_usuario": self.dataStorage.getUserId()] as [String : Any]
                                            self.message.text = ""
                                            let newC = Conversation(conversation: newMessage)
                                            
                                            self.conversations.append(newC)
                                            self.tableView.reloadData()
                                            self.message.resignFirstResponder()
                                            
                                            //let indexPath = IndexPath(item: self.conversations.count, section: 0)
                                            //self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                            
                                        }
                                        
                                    }
                                }
                                //completionHandler(value as? NSDictionary, nil)
                                break
                            case .failure(let error):
                                //completionHandler(nil, error as NSError?)
                                print(error)
                                print(error.localizedDescription)
                                break
                            }
        }
        // ---------------------------------------------------------------------
        
        /*
        conversations.append(self.message.text)
        self.tableView.reloadData()
        mainView.endEditing(true)
        self.message.text = ""*/
        /**/
    }
    
    
    
    /*
     func textViewDidChange(_ textView: UITextView) {
     print(textView.text)
     let size = CGSize(width: view.frame.width, height: .infinity)
     let estimatedSize = textView.sizeThatFits(size)
     textView.constraints.forEach{ (constraint) in
     if constraint.firstAttribute == .height {
     constraint.constant = estimatedSize.height
     }
     }
     }*/
    
    
}







// MARK: Delegate & DataSource

extension DetalleConversacionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = indexPath.section
        //let currentRow = indexPath.row
        let conversation = conversations[currentSection]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConversation, for: indexPath) as! CellConversation
        cell.releaseView()
        cell.selectionStyle = .none
        cell.setUpView(mensaje: conversation)
        cell.layoutIfNeeded()
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        return UITableView.automaticDimension
    }
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let currentSection = indexPath.section
        //let currentRow = indexPath.row
        return UITableView.automaticDimension // UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Footer View Section
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    
}











class CellConversation: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    let dataStorage = UserDefaults.standard
    
    let message: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    func setUpView(mensaje: Conversation) {
        backgroundColor = .white
        addSubview(container)
        if mensaje.idUsuario == dataStorage.getUserId() { // Verde
            addConstraintsWithFormat(format: "H:|-32-[v0]|", views: container)
            addConstraintsWithFormat(format: "V:|[v0]|", views: container)
        }
        else{ // Azul
            addConstraintsWithFormat(format: "H:|[v0]-32-|", views: container)
            addConstraintsWithFormat(format: "V:|[v0]|", views: container)
        }
        container.addSubview(message)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.minimumLineHeight = 2
        let attributedString = NSMutableAttributedString(string: "\(mensaje.persona) \n \(mensaje.comentarios)",
                                                         attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        message.attributedText = attributedString
        message.layer.cornerRadius = 15
        if mensaje.idUsuario == dataStorage.getUserId() {
            container.backgroundColor = UIColor.verde
            container.addConstraintsWithFormat(format: "H:|-[v0]-|", views: message)
            container.addConstraintsWithFormat(format: "V:|-[v0]-|", views: message)
        }
        else {
            container.backgroundColor = UIColor.azul
            container.addConstraintsWithFormat(format: "H:|-[v0]-|", views: message)
            container.addConstraintsWithFormat(format: "V:|-[v0]-|", views: message)
        }
    }
    
}






struct Conversation {
    
    var id: String = ""
    var idUsuario: String = ""
    var persona: String = ""
    var comentarios: String = ""
    
    init(conversation: Dictionary<String, Any>) {
        
        if let id = conversation["Id"] as? String {
            self.id = id
        }
        
        if let id_usuario = conversation["id_usuario"] as? String {
            self.idUsuario = id_usuario
        }
        
        if let comentarios = conversation["comentarios"] as? String {
            self.comentarios = comentarios
        }
        
        if let persona = conversation["persona"] as? String {
            self.persona = persona
        }
        
    }
    
}




