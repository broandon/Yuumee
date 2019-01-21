//
//  ModalFiltersViewController.swift
//  Yuumee
//
//  Created by Easy Code on 12/19/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import ViewPager_Swift

enum Tabs: String {
    case fecha
    case organizar
    
    var description : String {
        switch self {
        case .fecha:     return "Fecha"
        case .organizar: return "Organizar"
        }
    }
}

class ModalFiltersViewController: UIViewController {
    
    var tabs = [
        ViewPagerTab(title: Tabs.fecha.description, image: nil),
        ViewPagerTab(title: Tabs.organizar.description, image: nil)
    ]
    
    var viewPager:ViewPagerController!
    
    var options:ViewPagerOptions!
    
    
    var mainView: UIView {
        return self.view
    }
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg   = CGSize(width: 24, height: 24)
        let imgClose  = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain,
                                        target: self, action: #selector(closeVC))
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        cerrarBtn.target = self
        self.navigationItem.rightBarButtonItem = cerrarBtn
        
        options = ViewPagerOptions(viewPagerWithFrame: mainView.bounds)
        options.tabType = ViewPagerTabType.basic
        options.tabViewImageSize    = CGSize(width: 20, height: 20)
        options.tabViewPaddingLeft  = 20
        options.tabViewPaddingRight = 20
        options.fitAllTabsInView    = true
        options.isTabHighlightAvailable    = true
        options.isEachTabEvenlyDistributed = true
        options.tabViewBackgroundDefaultColor = UIColor.white
        // Background Color for current tab.
        // Only displays if isTabViewHighlightAvailable is set to true
        options.isTabIndicatorAvailable         = false
        options.tabViewBackgroundHighlightColor = UIColor.white
        options.tabViewTextDefaultColor         = UIColor.lightGray
        options.tabViewTextHighlightColor       = UIColor.darkGray
        // Background Color for tab Indicator
        options.tabIndicatorViewBackgroundColor = UIColor.darkGray
        options.tabViewTextFont = UIFont.boldSystemFont(ofSize: 19)
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChild(viewPager)
        mainView.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
        
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
} // ModalFiltersViewController


extension ModalFiltersViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        let vcPosition = tabs[position]
        
        if vcPosition.title == Tabs.fecha.description {
            let vc = CalendarioViewController()
            return vc
        }
        
        if vcPosition.title == Tabs.organizar.description {
            let vc = OrganizarViewController()
            return vc
        }
        
        return UIViewController()
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}


extension ModalFiltersViewController: ViewPagerControllerDelegate {
    func willMoveToControllerAtIndex(index:Int) {
        // print("Moving to page \(index)")
    }
    func didMoveToControllerAtIndex(index: Int) {
        // print("Moved to page \(index)")
    }
}
