//
//  TabBarViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        let images = [TabBarImage(image: .home.withRenderingMode(.alwaysOriginal), selectedImage: .selectedHome.withRenderingMode(.alwaysOriginal)), TabBarImage(image: .health.withRenderingMode(.alwaysOriginal), selectedImage: .selectedHealth.withRenderingMode(.alwaysOriginal)), TabBarImage(image: .calendar.withRenderingMode(.alwaysOriginal), selectedImage: .selectedCalendar.withRenderingMode(.alwaysOriginal)), TabBarImage(image: .food.withRenderingMode(.alwaysOriginal), selectedImage: .selectedFood.withRenderingMode(.alwaysOriginal)), TabBarImage(image: .settings.withRenderingMode(.alwaysOriginal), selectedImage: .selectedSettings.withRenderingMode(.alwaysOriginal))]
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        for (index, controller) in (viewControllers ?? []).enumerated() {
            controller.tabBarItem.image = images[index].image
            controller.tabBarItem.selectedImage = images[index].selectedImage
        }
    }
}

struct TabBarImage {
    var image: UIImage?
    var selectedImage: UIImage?
}

import UIKit

class CustomTabBar: UITabBar {
    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addShape()
        self.addTopBorder()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 120
        return sizeThatFits
    }

    private func addShape() {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 12, height: 12)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.frame = bounds
        layer.mask = maskLayer

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.frame = bounds
        shapeLayer.fillColor = UIColor.background.cgColor

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    private func addTopBorder() {
        let borderLayer = CAShapeLayer()
        let borderPath = UIBezierPath()
        borderPath.move(to: CGPoint(x: bounds.minX, y: bounds.minY + 12))
        borderPath.addArc(withCenter: CGPoint(x: bounds.minX + 12, y: bounds.minY + 12),
                          radius: 12,
                          startAngle: .pi,
                          endAngle: .pi * 1.5,
                          clockwise: true)
        
        borderPath.addLine(to: CGPoint(x: bounds.maxX - 12, y: bounds.minY))
        borderPath.addArc(withCenter: CGPoint(x: bounds.maxX - 12, y: bounds.minY + 12),
                          radius: 12,
                          startAngle: .pi * 1.5,
                          endAngle: 0,
                          clockwise: true)

        borderLayer.path = borderPath.cgPath
        borderLayer.lineWidth = 4.0
        borderLayer.strokeColor = #colorLiteral(red: 0.9150597453, green: 0.9150597453, blue: 0.9150597453, alpha: 1).cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(borderLayer)
    }
}

