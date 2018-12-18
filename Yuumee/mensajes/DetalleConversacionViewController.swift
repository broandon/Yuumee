//
//  DetalleConversacionViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/26/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

struct Conversation {
    
    var comentario: String = ""
    var fecha: String = ""
    var id: String = ""
    var tipo: String = ""
    
    init(conversation: Dictionary<String, Any>) {
        
        if let tipo = conversation["tipo"] as! String? {
            self.tipo = tipo
        }
        
        if let id = conversation["id"] as! String? {
            self.id = id
        }
        
        if let comentario = conversation["comentario"] as! String? {
            self.comentario = comentario
        }
        
        if let fecha = conversation["fecha"] as! String? {
            self.fecha = fecha
        }
        
    }
    
}



class DetalleConversacionViewController: BaseViewController, UITextViewDelegate {
    
    let backButton: UIButton = {
        let imageBtn = UIImage(named: "close")?.imageResize(sizeChange: CGSize(width: 20.0, height: 20.0))
        let back = UIButton(type: .custom)
        back.setImage(imageBtn?.withRenderingMode(.alwaysTemplate), for: .normal)
        back.setTitle("Evento", for: .normal)
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
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
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
        let button = UIButton(type: .custom)
        button.setImage( UIImage(named: "post") , for: .normal)
        button.addTarget(self, action: #selector(postMessageToLayer), for: .touchUpInside)
        return button
    }()
    
    let containerMessage: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.gris
        return view
    }()
    
    //var mensaje: Mensaje!
    
    //var conversations: [Conversation] = []
    var conversations: [String] = ["", "", ""]
    
    let dataStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        self.hideKeyboardWhenTappedAround()
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
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
        mainView.addConstraintsWithFormat(format: "V:|-[v0]-[v1(60)]|",
                                          views: tableView, containerMessage)
        
        containerMessage.addSubview(message)
        containerMessage.addSubview(postMessage)
        containerMessage.addConstraintsWithFormat(format: "H:|-[v0]-[v1(35)]-|", views: message, postMessage)
        containerMessage.addConstraintsWithFormat(format: "V:|-[v0(40)]", views: message)
        containerMessage.addConstraintsWithFormat(format: "V:|-16-[v0(35)]", views: postMessage)
        message.delegate = self
        
    }
    
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
        print(" postMessageToLayer ")
        
        conversations.append(self.message.text)
        self.tableView.reloadData()
        mainView.endEditing(true)
        self.message.text = ""
        
        /*if (self.message.text?.isEmpty)! {
            return
        }*/
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
        let currentRow = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConversation, for: indexPath) as! CellConversation
        cell.releaseView()
        cell.setUpView()
        cell.layoutIfNeeded()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        
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
        return 40
    }
    
    
}











class CellConversation: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    /*
    let avatar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "perfil")
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
    }()*/
    
    let message: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        //label.text = ""
        //label.font = UIFontMetrics.default.scaledFont(for: UIFont(name: FontName.MyriadProRegular.rawValue, size: 18)!)
        label.numberOfLines = 0
        label.sizeToFit()
        //label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    /*
    let date: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gris
        label.text = ""
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()*/
    
    func setUpView() {
        layer.cornerRadius = 15
        let tipo = "1" // mensaje.tipo
        
        // addSubview(avatar)
        // addSubview(date)
        addSubview(message)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.minimumLineHeight = 5
        let attributedString = NSMutableAttributedString(string: "test test test test...", attributes: [NSAttributedString.Key.paragraphStyle:paragraphStyle]
        )
        
        
        message.attributedText = attributedString
        message.layer.cornerRadius = 15
        
        //date.text = "17-01-2019"
        //let avatarSize = 60
        
        if tipo == "1" {
            backgroundColor = UIColor.verde
            addConstraintsWithFormat(format: "H:|-[v0]-|", views: message)
            //addConstraintsWithFormat(format: "H:|-[v0(70)]", views: date)
            //addConstraintsWithFormat(format: "V:|-[v0(\(avatarSize))]-[v1]", views: avatar, date)
            addConstraintsWithFormat(format: "V:|-16-[v0]-|", views: message)
        }
        else if tipo == "2" {
            backgroundColor = UIColor.azul
            addConstraintsWithFormat(format: "H:|-[v0]-|", views: message)
            //addConstraintsWithFormat(format: "H:[v0(70)]|", views: date)
            //addConstraintsWithFormat(format: "V:|-[v0(\(avatarSize))]-[v1]", views: avatar, date)
            addConstraintsWithFormat(format: "V:|-16-[v0]-|", views: message)
        }
        
        
        
    }
    
}



