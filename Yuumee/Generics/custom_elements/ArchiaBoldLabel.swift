//
//  ArchiaBoldLabel.swift
//  Yuumee
//
//  Created by Luis Segoviano on 12/24/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class ArchiaBoldLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        self.setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    func setup() {
        self.font = UIFont(name: "ArchiaRegular", size: self.font.pointSize)
        self.font = UIFont.boldSystemFont(ofSize: self.font.pointSize)
    }
    
}
