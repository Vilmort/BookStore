import UIKit

extension UIView {
    func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addColors(colors: [UIColor]) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds

            var colorsArray: [CGColor] = []
            var locationsArray: [NSNumber] = []
            for (index, color) in colors.enumerated() {
                // append same color twice
                colorsArray.append(color.cgColor)
                colorsArray.append(color.cgColor)
                locationsArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index)))
                locationsArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index + 1)))
            }

            gradientLayer.colors = colorsArray
            gradientLayer.locations = locationsArray

            self.backgroundColor = .clear
            self.layer.addSublayer(gradientLayer)

            // This can be done outside of this funciton
            self.layer.cornerRadius = self.bounds.height / 2
            self.layer.masksToBounds = true
        }
}
