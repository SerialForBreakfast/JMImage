//
//  Image.swift
//  BlendBuddyCameraColors
//
//  Created by Joseph McCraw on 12/5/16.
//  Copyright © 2016 Joseph McCraw. All rights reserved.
//
import UIKit

public class Image {
    let pixels: UnsafeMutableBufferPointer<RGBAPixel>
    let height: Int
    let width: Int
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
    static let bitsPerComponent = Int(8)
    
    let bytesPerRow: Int
    
    public init(width: Int, height: Int){
        self.height = height
        print(height)
        self.width = width
        
        bytesPerRow = 4 * width
        let rawData = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: (width * height))
        
        pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawData, count: width * height)
    }
    
    
    
    public init(image: UIImage){
        self.height = Int((image.size.height))
        self.width = Int((image.size.width))
        
        bytesPerRow = 4 * width
        let rawData = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: (width * height))
        let CGPointZero = CGPoint(x: 0, y: 0)
        let rect = CGRect(origin: CGPointZero, size: (image.size))
        
        
        
        let imageContext = CGContext(data: rawData, width: width, height: height, bitsPerComponent: Image.bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        
        imageContext?.draw(image.cgImage!, in: rect)
        
        pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawData, count: width * height)
    }
    
    public func getPixel( x:Int, y:Int) -> RGBAPixel {
        return pixels[x + y*width]
    }
    public func setPixel(value: RGBAPixel, x:Int, y:Int) {
        pixels[x + y*width] = value
    }
    
    public func toUIImage() -> UIImage {
        let outContext = CGContext(data: pixels.baseAddress, width: width, height: height, bitsPerComponent: Image.bitsPerComponent,bytesPerRow: bytesPerRow,space: colorSpace,bitmapInfo: bitmapInfo,releaseCallback: nil,releaseInfo: nil)
        
        return UIImage(cgImage: outContext!.makeImage()!)
    }
    public func transformPixels(transformFunc: (RGBAPixel)->RGBAPixel) -> Image {
        let newImage = Image(width: self.width, height: self.height)
        for y in 0 ..< height {
            for x in 0 ..< width {
                let p1 = getPixel(x: x,y:y)
                let p2 = transformFunc(p1)
                newImage.setPixel(value: p2, x:x, y:y)
            }
        }
        return newImage
    }
}
