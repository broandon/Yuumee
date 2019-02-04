//
//  NumeroPersonasViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 2/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class NumeroPersonasViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC))
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
    
    let personas = ["1", "2", "3", "4", "5"]
    var delegate: NumeroPersonasSeleccionadas?
    var currentPerson = ""
    
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
        return personas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let num = personas[indexPath.row]
        if num == currentPerson {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = num
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex: Int = indexPath.row
        let persona = personas[currentIndex]
        self.dismiss(animated: true, completion: {
            self.delegate?.getNumeroPersonas(numero: persona)
        })
    }
}
protocol NumeroPersonasSeleccionadas {
    func getNumeroPersonas(numero: String)
}
