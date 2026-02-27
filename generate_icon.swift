#!/usr/bin/env swift
import AppKit

// 生成 macOS 风格的圆角矩形图标
let sizes: [(name: String, width: Int)] = [
    ("16x16", 16),
    ("16x16@2x", 32),
    ("32x32", 32),
    ("32x32@2x", 64),
    ("128x128", 128),
    ("128x128@2x", 256),
    ("256x256", 256),
    ("256x256@2x", 512),
    ("512x512", 512),
    ("512x512@2x", 1024)
]
let outputDir = "/Users/jun/Projects/AgentSkillsManager/AgentSkillsManager/Assets.xcassets/AppIcon.appiconset"

func generateIcon(size: Int) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))

    image.lockFocus()

    let context = NSGraphicsContext.current!
    context.imageInterpolation = .high
    context.cgContext.interpolationQuality = .high

    let rect = NSRect(x: 0, y: 0, width: size, height: size)

    // 圆角半径 (macOS 图标风格 22.37%)
    let cornerRadius = CGFloat(size) * 0.2237

    // 创建圆角矩形路径
    let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)

    // 渐变背景 - 蓝色系
    let gradient = NSGradient(colors: [
        NSColor(red: 0.25, green: 0.50, blue: 0.95, alpha: 1.0),
        NSColor(red: 0.15, green: 0.35, blue: 0.85, alpha: 1.0)
    ])
    gradient?.draw(in: path, angle: -90)

    // 添加顶部高光
    let highlightPath = NSBezierPath(roundedRect: NSRect(x: 0, y: size - Int(CGFloat(size) * 0.5), width: size, height: Int(CGFloat(size) * 0.5)), xRadius: cornerRadius, yRadius: cornerRadius)
    NSColor.white.withAlphaComponent(0.15).setFill()
    highlightPath.fill()

    // 绘制白色齿轮图标
    let gearCenter = NSPoint(x: size / 2, y: size / 2)
    let gearRadius = CGFloat(size) * 0.30

    NSColor.white.setFill()

    // 绘制齿轮齿
    let teeth = 8
    for i in 0..<teeth {
        let angle = Double(i) * (2.0 * .pi / Double(teeth))
        let nextAngle = Double(i + 1) * (2.0 * .pi / Double(teeth))

        let toothPath = NSBezierPath()

        let innerRadius = gearRadius * 0.55
        let outerRadius = gearRadius

        let x1 = gearCenter.x + CGFloat(cos(angle - 0.12)) * innerRadius
        let y1 = gearCenter.y + CGFloat(sin(angle - 0.12)) * innerRadius
        let x2 = gearCenter.x + CGFloat(cos(angle - 0.12)) * outerRadius
        let y2 = gearCenter.y + CGFloat(sin(angle - 0.12)) * outerRadius
        let x3 = gearCenter.x + CGFloat(cos(nextAngle + 0.12)) * outerRadius
        let y3 = gearCenter.y + CGFloat(sin(nextAngle + 0.12)) * outerRadius
        let x4 = gearCenter.x + CGFloat(cos(nextAngle + 0.12)) * innerRadius
        let y4 = gearCenter.y + CGFloat(sin(nextAngle + 0.12)) * innerRadius

        toothPath.move(to: NSPoint(x: x1, y: y1))
        toothPath.line(to: NSPoint(x: x2, y: y2))
        toothPath.line(to: NSPoint(x: x3, y: y3))
        toothPath.line(to: NSPoint(x: x4, y: y4))
        toothPath.close()

        toothPath.fill()
    }

    // 绘制中心深色圆
    let centerCircle = NSBezierPath(ovalIn: NSRect(
        x: gearCenter.x - gearRadius * 0.50,
        y: gearCenter.y - gearRadius * 0.50,
        width: gearRadius,
        height: gearRadius
    ))
    NSColor(red: 0.12, green: 0.30, blue: 0.75, alpha: 1.0).setFill()
    centerCircle.fill()

    // 绘制闪电图标
    let boltPath = NSBezierPath()
    let boltSize = CGFloat(size) * 0.20
    let boltX = gearCenter.x + boltSize * 0.05
    let boltY = gearCenter.y - boltSize * 0.35

    boltPath.move(to: NSPoint(x: boltX - boltSize * 0.35, y: boltY + boltSize))
    boltPath.line(to: NSPoint(x: boltX + boltSize * 0.15, y: boltY + boltSize))
    boltPath.line(to: NSPoint(x: boltX - boltSize * 0.15, y: boltY + boltSize * 0.4))
    boltPath.line(to: NSPoint(x: boltX + boltSize * 0.35, y: boltY + boltSize * 0.4))
    boltPath.line(to: NSPoint(x: boltX - boltSize * 0.25, y: boltY))
    boltPath.line(to: NSPoint(x: boltX - boltSize * 0.55, y: boltY + boltSize * 0.5))
    boltPath.line(to: NSPoint(x: boltX - boltSize * 0.05, y: boltY + boltSize * 0.5))
    boltPath.close()

    NSColor.white.setFill()
    boltPath.fill()

    image.unlockFocus()

    return image
}

// 保存图片
func saveImage(_ image: NSImage, to path: String, size: Int) {
    // 使用正确的 bitmap 格式
    guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil,
                                         pixelsWide: size,
                                         pixelsHigh: size,
                                         bitsPerSample: 8,
                                         samplesPerPixel: 4,
                                         hasAlpha: true,
                                         isPlanar: false,
                                         colorSpaceName: .deviceRGB,
                                         bytesPerRow: 0,
                                         bitsPerPixel: 0) else {
        print("Failed to create bitmap for \(path)")
        return
    }

    let ctx = NSGraphicsContext(bitmapImageRep: bitmap)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = ctx

    // 绘制图像
    image.draw(in: NSRect(x: 0, y: 0, width: size, height: size))

    NSGraphicsContext.restoreGraphicsState()

    guard let pngData = bitmap.representation(using: .png, properties: [.compressionFactor: 0.9]) else {
        print("Failed to create PNG data for \(path)")
        return
    }

    do {
        try pngData.write(to: URL(fileURLWithPath: path))
        print("Generated: \(path) (\(size)x\(size))")
    } catch {
        print("Failed to write \(path): \(error)")
    }
}

// 生成所有尺寸
for (name, size) in sizes {
    let image = generateIcon(size: size)
    saveImage(image, to: "\(outputDir)/\(name).png", size: size)
}

print("Icon generation complete!")
