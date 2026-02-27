#!/usr/bin/env swift
import AppKit

// 生成 macOS 风格的圆角矩形图标
// 无文字，简洁的齿轮+闪电设计

let sizes = [16, 32, 128, 256, 512]
let outputDir = "/Users/jun/Projects/AgentSkillsManager/AgentSkillsManager/Assets.xcassets/AppIcon.appiconset"

func generateIcon(size: Int, scale: Int = 1) -> NSImage {
    let pixelSize = size * scale
    let image = NSImage(size: NSSize(width: pixelSize, height: pixelSize))

    image.lockFocus()

    let context = NSGraphicsContext.current!
    context.imageInterpolation = .high

    let rect = NSRect(x: 0, y: 0, width: pixelSize, height: pixelSize)

    // 圆角半径 (macOS 图标风格)
    let cornerRadius = CGFloat(pixelSize) * 0.2237

    // 创建圆角矩形路径
    let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)

    // 渐变背景 - 蓝色系
    let gradient = NSGradient(colors: [
        NSColor(red: 0.35, green: 0.55, blue: 0.95, alpha: 1.0),
        NSColor(red: 0.20, green: 0.40, blue: 0.85, alpha: 1.0)
    ])
    gradient?.draw(in: path, angle: -90)

    // 添加轻微内阴影效果
    path.lineWidth = 1
    NSColor.white.withAlphaComponent(0.3).setStroke()
    path.stroke()

    // 绘制齿轮图标
    let gearCenter = NSPoint(x: pixelSize / 2, y: pixelSize / 2)
    let gearRadius = CGFloat(pixelSize) * 0.28

    NSColor.white.withAlphaComponent(0.95).setFill()

    // 绘制齿轮齿
    let teeth = 8
    for i in 0..<teeth {
        let angle = Double(i) * (2.0 * .pi / Double(teeth))
        let nextAngle = Double(i + 1) * (2.0 * .pi / Double(teeth))

        let toothPath = NSBezierPath()
        toothPath.move(to: gearCenter)

        let innerRadius = gearRadius * 0.6
        let outerRadius = gearRadius

        let x1 = gearCenter.x + CGFloat(cos(angle - 0.15)) * innerRadius
        let y1 = gearCenter.y + CGFloat(sin(angle - 0.15)) * innerRadius
        let x2 = gearCenter.x + CGFloat(cos(angle - 0.15)) * outerRadius
        let y2 = gearCenter.y + CGFloat(sin(angle - 0.15)) * outerRadius
        let x3 = gearCenter.x + CGFloat(cos(nextAngle + 0.15)) * outerRadius
        let y3 = gearCenter.y + CGFloat(sin(nextAngle + 0.15)) * outerRadius
        let x4 = gearCenter.x + CGFloat(cos(nextAngle + 0.15)) * innerRadius
        let y4 = gearCenter.y + CGFloat(sin(nextAngle + 0.15)) * innerRadius

        toothPath.move(to: NSPoint(x: x1, y: y1))
        toothPath.line(to: NSPoint(x: x2, y: y2))
        toothPath.line(to: NSPoint(x: x3, y: y3))
        toothPath.line(to: NSPoint(x: x4, y: y4))
        toothPath.close()

        toothPath.fill()
    }

    // 绘制中心圆
    let centerCircle = NSBezierPath(ovalIn: NSRect(
        x: gearCenter.x - gearRadius * 0.45,
        y: gearCenter.y - gearRadius * 0.45,
        width: gearRadius * 0.9,
        height: gearRadius * 0.9
    ))
    NSColor(red: 0.25, green: 0.45, blue: 0.90, alpha: 1.0).setFill()
    centerCircle.fill()

    // 绘制闪电图标
    let boltPath = NSBezierPath()
    let boltSize = CGFloat(pixelSize) * 0.22
    let boltX = gearCenter.x - boltSize * 0.15
    let boltY = gearCenter.y - boltSize * 0.4

    boltPath.move(to: NSPoint(x: boltX - boltSize * 0.3, y: boltY + boltSize * 0.9))
    boltPath.line(to: NSPoint(x: boltX + boltSize * 0.2, y: boltY + boltSize * 0.9))
    boltPath.line(to: NSPoint(x: boltX - boltSize * 0.1, y: boltY + boltSize * 0.4))
    boltPath.line(to: NSPoint(x: boltX + boltSize * 0.4, y: boltY + boltSize * 0.4))
    boltPath.line(to: NSPoint(x: boltX - boltSize * 0.2, y: boltY))
    boltPath.line(to: NSPoint(x: boltX - boltSize * 0.5, y: boltY + boltSize * 0.5))
    boltPath.line(to: NSPoint(x: boltX, y: boltY + boltSize * 0.5))
    boltPath.close()

    NSColor.white.setFill()
    boltPath.fill()

    image.unlockFocus()

    return image
}

// 保存图片
func saveImage(_ image: NSImage, to path: String) {
    guard let tiffData = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData),
          let pngData = bitmap.representation(using: .png, properties: [:]) else {
        print("Failed to create PNG data for \(path)")
        return
    }

    do {
        try pngData.write(to: URL(fileURLWithPath: path))
        print("Generated: \(path)")
    } catch {
        print("Failed to write \(path): \(error)")
    }
}

// 生成所有尺寸
for size in sizes {
    // 1x
    let image1x = generateIcon(size: size, scale: 1)
    saveImage(image1x, to: "\(outputDir)/\(size)x\(size).png")

    // 2x
    let image2x = generateIcon(size: size, scale: 2)
    saveImage(image2x, to: "\(outputDir)/\(size)x\(size)@2x.png")
}

print("Icon generation complete!")
