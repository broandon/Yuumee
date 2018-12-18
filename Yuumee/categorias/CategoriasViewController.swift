//
//  CategoriasViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class CategoriasViewController: BaseViewController {
    
    let headerContent: UIView = {
        let view = UIView()
        return view
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    var categorias = ["", "", "", "", "", "", "", "", "", ""]
    
    override func viewDidLoad() {
        
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        // below code write in view did appear() -------------------------------
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // below code create swipe gestures function ---------------------------
        
        // ---------------------------------------------------------------------
        mainView.addSubview(headerContent)
        mainView.addSubview(tableView)
        
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: headerContent)
        mainView.addConstraintsWithFormat(format: "V:|-[v0(44)][v1]|", views: headerContent, tableView)
        
        let settingsImage = UIImageView(image: UIImage(named: "settings"))
        settingsImage.contentMode = .scaleAspectFit
        settingsImage.image = settingsImage.image?.withRenderingMode(.alwaysTemplate)
        settingsImage.tintColor = .white
        let settings = UIButton(type: .custom)
        settings.setImage( settingsImage.image , for: .normal)
        settings.backgroundColor = .rojo
        settings.tintColor = .white
        settings.layer.cornerRadius = 15
        
        let randomImage = UIImageView(image: UIImage(named: "random"))
        randomImage.contentMode = .scaleAspectFit
        randomImage.image = randomImage.image?.withRenderingMode(.alwaysTemplate)
        randomImage.tintColor = .white
        let random = UIButton(type: .custom)
        random.setImage( randomImage.image, for: .normal)
        random.backgroundColor = .rojo
        random.tintColor = .white
        random.layer.cornerRadius = 15
        
        let date = UILabel()
        date.textAlignment = .center
        date.text = " 3 de agosto de 2018 "
        date.font = UIFont.boldSystemFont(ofSize: date.font.pointSize)
        
        headerContent.addSubview(settings)
        headerContent.addSubview(date)
        headerContent.addSubview(random)
        headerContent.addConstraintsWithFormat(format: "H:|-[v0(30)]-[v1]-[v2(30)]-|", views: random, date, settings)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: random)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: date)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: settings)
        // ---------------------------------------------------------------------
        
    }
    
    
    // MARK: - swiped
    @objc  func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3
            { // set here  your total tabs
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
}




extension CategoriasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categorias.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.selectionStyle = .none
        
        let backgroundImage = UIImageView(image: UIImage(named: "hamburger"))
        backgroundImage.contentMode = .scaleAspectFill
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.7) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        backgroundImage.addSubview(tintView)
        
        cell.backgroundView = backgroundImage
        
        
        let categoriaNameLabel = UILabel()
        categoriaNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoriaNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        categoriaNameLabel.text = "Regional"
        categoriaNameLabel.textColor = .white
        categoriaNameLabel.textAlignment = .center
        
        cell.addSubview(categoriaNameLabel)
        cell.centerView(superView: cell, container: categoriaNameLabel)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        return 200.0 // UITableViewAutomaticDimension
    }
    
    
    // Footer View Section
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let sep = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3) )
        sep.backgroundColor = UIColor.black//.withAlphaComponent(0.7)
        sep.layer.cornerRadius = 2
        view.addSubview(sep)
        
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: sep)
        view.addConstraintsWithFormat(format: "V:|-[v0]-|", views: sep)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetalleListadoCategoriaViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}







