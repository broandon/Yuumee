//
//  EspaciosDegustarViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/23/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

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

    let lugares = ["Terraza", "Jardín", "Comedor", "Corredor", "Casa", "Otros"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    @objc func lugarParaDegustarEvent(sender: CustomSwitch) {
        let isActivated = sender.isOn
        if isActivated {
            print(" si lo es ")
        }
        else{
            print(" NO lo es ")
        }
        
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
    
}

extension EspaciosDegustarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lugares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lugar = lugares[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultId, for: indexPath)
        cell.textLabel?.text = lugar
        
        let switchP = CustomSwitch(frame: CGRect(x: 50, y: 50, width: 55, height: 25))
        //switchPush.isOn = false
        switchP.onTintColor = UIColor.rosa
        switchP.offTintColor = UIColor.darkGray
        switchP.cornerRadius = 0.5
        switchP.thumbCornerRadius = 0.5
        switchP.thumbSize = CGSize(width: 30, height: 30)
        switchP.thumbTintColor = UIColor.white
        switchP.padding = 0
        switchP.animationDuration = 0.25
        
        switchP.addTarget(self, action: #selector(lugarParaDegustarEvent), for: .valueChanged)
        cell.accessoryView = switchP
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
