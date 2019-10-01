import UIKit


// From Hackingwithswift - https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension Date {
    var short: String {
        let dateFormatter = DateFormatter.shared
            dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    static var shared = DateFormatter()
}

extension NumberFormatter {
    static var shared = NumberFormatter()
}

extension Decimal {
    func toCurrencyString(for locale: Locale) -> String {
        let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.locale = locale
        
        // localing how we group and what decimal we use
        let number = self as NSNumber
        let priceString = currencyFormatter.string(from: number) ?? "\(self)"
        
        return priceString
    }
}

enum Currency: String {
    
    case jpy,
    usd
    
    
    //This could be WAY better.  Hacking locale stuff because of time constraint
    var locale: Locale? {
        switch self {
        case .jpy:
            return Locale(identifier: "ja_JP")
        case .usd:
            return Locale(identifier: "en_US")
        }
    }
    
    init?(type: String) {
        switch type {
        case Currency.jpy.rawValue.uppercased(): self = .jpy
        case Currency.usd.rawValue.uppercased(): self = .usd
        default: return nil
        }
    }
}

//TODO: herbal7ea - 10.01.19 - Need to organized these extensions better.
extension String {
    var asCurrency: Currency? { return Currency(type: self) }
}


extension TransactionEntity {
    func amountFormatted(`for` person: Person) -> String {
        guard let locale = person.locale,
            let currency = person.currency.asCurrency else { return "\(amount)" }
        
        let amountDecimal = amount as Decimal
        
        return amountDecimal.toCurrencyString(with: currency, locale: locale)
    }
}

extension Person {
    var locale: Locale? {
        return currency.asCurrency?.locale
    }
}

extension Decimal {
    func toCurrencyString(with currency: Currency, locale: Locale) -> String {
        return "\(currency) \(toCurrencyString(for: locale))"
    }
}
