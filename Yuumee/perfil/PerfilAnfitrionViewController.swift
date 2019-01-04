//
//  PerfilAnfitrionViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/2/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class PerfilAnfitrionViewController: BaseViewController {
    
    let informacionAnfitrionCell = "InformacionAnfitrionCell"
    
    let backgroundImageId = "backgroundImageId"
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(BackgroundImageHeader.self, forCellReuseIdentifier: backgroundImageId)
        tableView.register(InformacionAnfitrionCell.self, forCellReuseIdentifier: informacionAnfitrionCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.gris
        return tableView
    }()
    
    
    let secciones = ["background_image", "info"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mainView.backgroundColor = UIColor.gris
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        self.view.frame.origin.y -= 200
        /*
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            mainView.frame.origin.y = -(keyboardSize.height/2)
        }
        */
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        self.view.frame.origin.y += 200
        /*
        mainView.frame.origin.y = 0
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        */
    }
    
   
}



extension PerfilAnfitrionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = secciones[indexPath.row]
        if section == "background_image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: backgroundImageId, for: indexPath)
            if let cell = cell as? BackgroundImageHeader {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
        if section == "info" {
            let cell = tableView.dequeueReusableCell(withIdentifier: informacionAnfitrionCell, for: indexPath)
            if let cell = cell as? InformacionAnfitrionCell {
                cell.selectionStyle = .none
                cell.reference = self
                cell.setUpView()
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        //cell.addBorder()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = secciones[indexPath.row]
        if section == "background_image" {
            return ScreenSize.screenWidth / 2
        }
        if section == "info" {
            return ScreenSize.screenHeight - (ScreenSize.screenWidth*0.3)
        }
        return UITableView.automaticDimension
    }
    
    
}
