//
//  MainReactor.swift
//  pulley
//
//  Created by eli on 2021/05/01.
//

import ReactorKit
import PencilKit
import UIKit

final class MainReactor: Reactor {
    // Action
    enum Action {
        case tapImage
        case tapSave(UIImage?, PKDrawing)
        case tapLoad
    }
    
    enum Mutation {
        case setImage(UIImage?)
        case setCanvas(Canvas?)
    }
    
    struct State {
        var currentCanvas: Canvas? = Canvas()
    }
    
    // MARK: Property
    var initialState: State = State()
    let imagePickerService: ImagePickerServiceType
    let canvasService: CanvasServiceType
    
    // MARK: Init
    init(imagePickerService: ImagePickerServiceType,
         canvasService: CanvasServiceType
    ) {
        self.imagePickerService = imagePickerService
        self.canvasService = canvasService
    }
    
    // MARK: `Reactor` implementation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapImage:
            return self.imagePickerService.selectImage()
                .map { .setImage($0) }
            
        case let .tapSave(background, canvas):
            self.canvasService.saveCanvas(background: background, canvas: canvas)
            
        case .tapLoad:
            return self.canvasService.loadCanvas()
                .map{ .setCanvas($0) }
        }
        
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setImage(image):
            newState.currentCanvas?.background = image
        case let .setCanvas(canvas):
            newState.currentCanvas = canvas
        }
        
        return newState
    }
}
