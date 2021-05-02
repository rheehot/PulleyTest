//
//  CanvasService.swift
//  pulley
//
//  Created by eli on 2021/05/02.
//

import RxSwift
import UIKit
import PencilKit


protocol CanvasServiceType: AnyObject {
    func saveCanvas(background: UIImage?, canvas: PKDrawing?)
    func loadCanvas() -> Observable<Canvas?>
}

final class CanvasService: CanvasServiceType {
    // MARK: Property
    private let defaults = UserDefaults.standard
    
    // MARK: Constants
    private let CANVAS_KEY = "CANVAS"
    private let BACKGROUND = "BACKGROUND"
    
    // MARK: `CanvasServiceType` implementation
    func saveCanvas(background: UIImage?, canvas: PKDrawing?) {
        let background = background?.pngData()
        let canvas = canvas?.dataRepresentation()
        
        self.defaults.set(background, forKey: self.BACKGROUND)
        self.defaults.set(canvas, forKey: self.CANVAS_KEY)
    }
    
    func loadCanvas() -> Observable<Canvas?> {
        var background: UIImage?
        if let backgroundData = self.defaults.object(forKey: self.BACKGROUND) as? Data {
            background = UIImage(data: backgroundData)
        }
        let canvasData = self.defaults.object(forKey: self.CANVAS_KEY) as? Data
        let canvas = try? PKDrawing(data: canvasData!)
        
        return .just(Canvas(background: background, canvas: canvas))
    }
}
