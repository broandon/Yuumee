//
//  DetalleListadoCategoriaViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/27/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class DetalleListadoCategoriaViewController: BaseViewController {
    
    let defaultReuseId = "cell"
    
    let restaurantCell = "RestaurantCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: restaurantCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    let restaurants = ["", "", "", "", ""]
    
    override func viewDidLoad() {
        mainView.backgroundColor = .white
        // -------------------------------- Nav --------------------------------
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = "Regresar"
        let backButton = UIBarButtonItem(title: "Regresar", style: .plain,
                                         target: self, action: #selector(back))
        
        let settings = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain,
                                       target: self, action: #selector(settingsTap) )
        
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = settings
        
        // ------------------------------- Datos -------------------------------
        
        mainView.addSubview(tableView)
        
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func settingsTap() {
        print(" settings ")
    }
    
    
}


extension DetalleListadoCategoriaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: restaurantCell, for: indexPath) as! RestaurantCell
        cell.selectionStyle = .none
        cell.setUpView()
        cell.descripcion.textColor = UIColor.darkGray
        cell.distanciaAprox.textColor = UIColor.darkGray
        cell.kms.textColor = UIColor.darkGray
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        return 300.0 // UITableViewAutomaticDimension
    }
    
    /*
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
     let currentSection = indexPath.section
     let currentRow = indexPath.row
     return 550.0 // UITableViewAutomaticDimension
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     tableView.deselectRow(at: indexPath, animated: true)
     let currentSection = indexPath.section
     let currentRow = indexPath.row
     //print(" currentRow ", currentRow)
     }
     */
}
