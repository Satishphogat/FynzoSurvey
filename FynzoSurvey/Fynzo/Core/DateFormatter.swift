import Foundation

public extension DateFormatter {
    
    class func getDateFormat(_ date: Date, _ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return  formatter.string(from: date)
    }
}

extension String {
    // TODO: need refactor
    func combinedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func getDayString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd", requiredFormat: "dd")
    }
    
    func getMonthString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd", requiredFormat: "MM")
    }
    
    func getYearString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd", requiredFormat: "yyyy")
    }
    
    func utcToLocale(currentFormat: String, requiredFormat: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = formatter.date(from: self) {
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = requiredFormat
            return formatter.string(from: date)
        }
        
        return self
    }
    
    func toDate(_ format: String? = "yyyy-MM-dd HH:mm") -> Date? {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone(abbreviation: "UTC")
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.date(from: self)
    }
    
    func getDateFormattedString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredFormat: "d MMM, yyyy")
    }
    
    func yyyymmddFormattedString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredFormat: "yyyy-MM-dd")
    }
    
    func yyyymmddFormattedTwillioString(_ dateFormat: String = "d MMM, yyyy") -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredFormat: dateFormat)
    }
    
    func twillioFormattedTimeString(_ dateFormat: String = "yyyy-MM-dd") -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredFormat: dateFormat)
    }
    
    func twillioFormattedHourString(_ dateFormat: String = "hh:mm a") -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredFormat: dateFormat)
    }
    
    func getDateFormattedWithTimeString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd HH:mm:ss", requiredFormat: "EE, MMM d, yyyy | h:mm a")
    }
    
    func getTimeFormatedString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredFormat: "hh:mm a")
    }
    
    func getCustomizedTime() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ssZ", requiredFormat: "h:mm a")
    }
    
    func getCustomizedDate() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", requiredFormat: "yyyy-MM-dd")
    }
    
    func getSlashedDateFormatedString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredFormat: "MM/yy")
    }
    
    func convertTo(format: String) -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredFormat: format)
    }
    
    func convertTo(_ currentFormat: String = "yyyy-MM-dd'T'HH:mm:ss+SSSS", format: String) -> String {
        return utcToLocale(currentFormat: currentFormat, requiredFormat: format)
    }
    
    func hasEventStarted() -> Bool {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let eventDate = dateFormater.date(from: self)
        if let date = eventDate?.addingTimeInterval(100), date >= Date() {
            return false
        } else {
            return true
        }
    }
    
    func hasEventFinished(_ startDate: String = "") -> Bool {
        
        if self.isEmpty {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let eventDate = dateFormater.date(from: startDate) {
                return daysBetweenDates(startDate: eventDate, endDate: Date()) > 1
            } else {
                return false
            }
        } else {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let eventDate = dateFormater.date(from: self)
            if let date = eventDate?.addingTimeInterval(100), date < Date() {
                return true
            } else {
                return false
            }
        }
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

extension Date {
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyy"
        
        return formatter.string(from: self)
    }
    
    func pickerViewDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return formatter.string(from: self)
    }
    
    func getyyyyMMDDString(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func get12HourFormatString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        return formatter.string(from: self)
    }
    
    func get24HourUTCFromatString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return formatter.string(from: self)
    }
    
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }
}
