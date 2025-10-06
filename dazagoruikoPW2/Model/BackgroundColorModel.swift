import UIKit

final class BackgroundColorModel {
    private(set) var red: CGFloat = 1
    private(set) var green: CGFloat = 1
    private(set) var blue: CGFloat = 1

    func update(red: CGFloat? = nil, green: CGFloat? = nil, blue: CGFloat? = nil) {
        if let red = red { self.red = red }
        if let green = green { self.green = green }
        if let blue = blue { self.blue = blue }
    }

    var color: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    func randomize() {
        red = CGFloat.random(in: 0...1)
        green = CGFloat.random(in: 0...1)
        blue = CGFloat.random(in: 0...1)
    }
}
