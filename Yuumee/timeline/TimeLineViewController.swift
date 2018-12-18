//
//  TimeLineViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class TimeLineViewController: BaseViewController {
    
    let headerContent: UIView = {
        let view = UIView()
        return view
    }()
    
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
        self.navigationController?.isNavigationBarHidden = true
        
        //below code write in view did appear()
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // below code create swipe gestures function
        
        
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
        
    }
    
    // MARK: - swiped
    @objc  func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3 { // set here  your total tabs
                self.tabBarController?.selectedIndex += 1
            }
        }
        else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
    var feeds = ["", "", "", "", "", "", "", "", "", ""]
    
}


extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: restaurantCell, for: indexPath) as! RestaurantCell
        cell.setUpView()
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



class RestaurantCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    let restaurantImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hamburger")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nombreRestaurant: UILabel = {
        let label = UILabel()
        label.text = "FloriArte"
        label.font = UIFont(name: label.font.fontName, size: 24)
        //label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let descripcion: UILabel = {
        let label = UILabel()
        label.text = "Comida regional"
        label.textColor = .rosa
        return label
    }()
    
    let distanciaAprox: UILabel = {
        let label = UILabel()
        label.text = "Distancia proximada"
        label.textColor = .rosa
        return label
    }()
    
    let costo: UILabel = {
        let label = UILabel()
        label.text = "$ 200"
        label.textColor = .rosa
        return label
    }()
    
    let kms: UILabel = {
        let label = UILabel()
        label.text = "15 Km"
        label.textColor = .rosa
        return label
    }()
    
    
    func setUpView() {
        addSubview(restaurantImage)
        addSubview(nombreRestaurant)
        addSubview(descripcion)
        addSubview(distanciaAprox)
        addSubview(costo)
        addSubview(kms)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: restaurantImage)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: nombreRestaurant)
        addConstraintsWithFormat(format: "H:|-[v0]", views: descripcion)
        addConstraintsWithFormat(format: "H:[v0]-|", views: distanciaAprox)
        addConstraintsWithFormat(format: "H:|-[v0]", views: costo)
        addConstraintsWithFormat(format: "H:[v0]-|", views: kms)
        addConstraintsWithFormat(format: "V:|[v0(200)]-[v1]-[v2]-[v3]",
                                 views: restaurantImage, nombreRestaurant, descripcion, costo)
        addConstraintsWithFormat(format: "V:|[v0(200)]-[v1]-[v2]-[v3]",
                                 views: restaurantImage, nombreRestaurant, distanciaAprox, kms)
    }
    
    
}
