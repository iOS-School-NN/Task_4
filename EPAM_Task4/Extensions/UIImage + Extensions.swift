import UIKit

// Расширение функционала класса UIImage
// Реализуем метод, который позволяет получить изображение исходя из цвета и размера
// При передаче UIColor.clear возвращает прозрачное изображение
// Полученное изображение будет использовано для установки его как фонового для UITabBar

extension UIImage {
    static func getColorImage(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
