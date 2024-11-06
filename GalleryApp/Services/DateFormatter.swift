//
//  DateFormatter.swift
//  GalleryApp
//
//  Created by Karina Kovaleva on 6.11.24.
//

import Foundation

var fromStringToDateFormatter: DateFormatter = {
    var customDateFormatter = DateFormatter()
    customDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return customDateFormatter
}()

var fromDateToStringFormatter: DateFormatter = {
    var customDateFormatter = DateFormatter()
    customDateFormatter.dateStyle = .long
    customDateFormatter.timeStyle = .short
    return customDateFormatter
}()
