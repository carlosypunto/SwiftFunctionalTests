//: Playground - noun: a place where people can play

import UIKit

// Based in Chris Eidhof Conference, url:
// http://cmdrconf.com/portfolio/chris-eidhof

// CIFilter list:
// https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html

func filter(name: String, image: CIImage, configure: CIFilter -> ()) -> CIImage {
    let filter = CIFilter(name: name)
    filter.setDefaults()
    filter.setValue(image, forKey: "inputImage")
    configure(filter)
    return filter.valueForKey("outputImage") as! CIImage
}

typealias Filter = CIImage -> CIImage

func blur(radius: Double) -> Filter {
    return { image in
        println("blur")
        return filter("CIGaussianBlur", image) { $0.setValue(radius, forKey: "inputRadius") }
    }
}

func sepia(intensity: Double) -> Filter {
    return { image in
        println("sepia")
        return filter("CISepiaTone", image) { $0.setValue(intensity, forKey: "inputIntensity") }
    }
}

func bloom() -> Filter {
    return { image in
        println("bloom")
        return filter("CIBloom", image) { $0.setValue(1.0, forKey: "inputIntensity") }
    }
}

func composeFilters(one: Filter, two: Filter) -> Filter {
    return { image in
        one(two(image))
    }
}


// own sugar: better right associativity and reverse the order of the functions
infix operator >>> { associativity right }
func >>> (one: Filter, two: Filter) -> Filter {
    return { image in
        two(one(image))
    }
}

func myImage() -> CIImage {
    
    let image = CIImage(image: UIImage(named: "Hypnotoad"))
    
    let finalFilter = blur(10.0) >>> sepia(0.7) >>> bloom()
    let outputImage = finalFilter(image)
    
    return outputImage
}

myImage()
