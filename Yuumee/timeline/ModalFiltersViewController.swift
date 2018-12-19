//
//  ModalFiltersViewController.swift
//  Yuumee
//
//  Created by Easy Code on 12/19/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class ModalFiltersViewController: UIViewController {
    
    weak var interfaceSegmented: CustomSegmentedControl!{
        didSet{
            interfaceSegmented.setButtonTitles(buttonTitles: ["Fecha","Organizar"])
            interfaceSegmented.selectorViewColor = UIColor.rosa
            interfaceSegmented.selectorTextColor = UIColor.rosa
        }
    }
    
    var mainView: UIView {
        return self.view
    }
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC) )
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        cerrarBtn.target = self
        self.navigationItem.rightBarButtonItem = cerrarBtn
        
        // CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 40)
        let codeSegmented = CustomSegmentedControl(frame: CGRect.zero , buttonTitle: ["Fecha","Organizar"] )
        codeSegmented.delegate = self
        codeSegmented.backgroundColor = .clear
        changeToIndex(index: 0)
        mainView.addSubview(codeSegmented)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: codeSegmented)
        mainView.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: codeSegmented)
        
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
} // ModalFiltersViewController


extension ModalFiltersViewController: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        
        print(" index: \(index) ")
        
        switch index {
        case 0:
            self.view.backgroundColor = UIColor.green
            
            let btn = UIButton(type: .system)
            btn.setTitle("test 0", for: .normal)
            mainView.addSubview(btn)
            mainView.addConstraintsWithFormat(format: "H:[v0]-|", views: btn)
            mainView.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: btn)
            
        case 1:
            self.view.backgroundColor = UIColor.blue
            
            let btn = UIButton(type: .system)
            btn.setTitle("test 1", for: .normal)
            mainView.addSubview(btn)
            mainView.addConstraintsWithFormat(format: "H:|-[v0]", views: btn)
            mainView.addConstraintsWithFormat(format: "V:[v0(30)]-|", views: btn)
            
            
        default:
            print(" Default ")
        }
    }
    
}
