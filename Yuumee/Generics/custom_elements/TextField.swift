//
//  TextField.swift
//  Yuumee
//
//  Created by Luis Segoviano on 12/24/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class TextField : UITextField {
    var leftTextMargin : CGFloat = 25.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }
}
