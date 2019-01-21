//
//  DetalleListadoCategoriaViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/27/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

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
    
    let dataStorage = UserDefaults.standard
    
    var idCategoria: String = ""
    
    lazy var settings: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.addTarget(self, action: #selector(settingsTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        mainView.backgroundColor = .white
        // -------------------------------- Nav --------------------------------
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = "Regresar"
        let backButton = UIBarButtonItem(title: "Regresar", style: .plain,
                                         target: self, action: #selector(back))
        //self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settings)
        self.navigationItem.leftBarButtonItem = backButton
        // ------------------------------- Datos -------------------------------
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    @objc func back() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func settingsTap(sender: UIButton) {
        let vc = SubCategoriasViewController()
        vc.idCategoria = self.idCategoria
        let popVC = UINavigationController(rootViewController: vc)
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.settings // self.button
        popOverVC?.sourceRect = CGRect(x: self.settings.bounds.midX,
                                       y: self.settings.bounds.minY,
                                       width: 0, height: 0)
        let widthModal = ScreenSize.screenWidth - 16
        let heightModal = ScreenSize.screenWidth
        popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
        self.present(popVC, animated: true)
        
    }
    
    
}

extension DetalleListadoCategoriaViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
        let r = Restaurant(restaurant: [:])
        cell.setUpView(restaurant: r)
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
    
} // DetalleListadoCategoriaViewController




