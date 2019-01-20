//
//  FormattedCurrentDate.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/6/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import Foundation

class FormattedCurrentDate {
    
    /**
     * How to use:
     *
     * FormattedCurrentDate.getFormattedCurrentDate(date: Date(), format: "d/MMM/yyyy")
     *
     * Retorna un String de una fecha, con el formato que se le envíe
     * (Valido para el id de la region de donde se envíe)
     *
     */
    static func getFormattedCurrentDate(date: Date = Date(), format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
