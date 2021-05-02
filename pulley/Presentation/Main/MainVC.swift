//
//  MainVC.swift
//  pulley
//
//  Created by eli on 2021/05/01.
//

import UIKit
import PencilKit
import ReactorKit

final class MainVC: BaseVC, View {
    // MARK: UI Components
    private let saveButton = UIBarButtonItem().then {
        $0.title = "Save"
    }
    
    private let loadButton = UIBarButtonItem().then {
        $0.title = "Load"
    }
    
    private let addImageButton = UIBarButtonItem().then {
        $0.title = "Add"
    }
    
    private let backButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "arrow.backward")
    }
    
    private let forwardButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "arrow.forward")
    }
    
    private let penButton = UIBarButtonItem().then {
        $0.title = "Pen"
    }
    
    private let eraseButton = UIBarButtonItem().then {
        $0.title = "Erase"
    }
    
    private let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let canvasView = PKCanvasView(frame: .zero).then {
        $0.drawing = PKDrawing()
        $0.tool = PKInkingTool(.pen, color: .black, width: 15)
        $0.backgroundColor = .clear
        $0.drawingPolicy = .anyInput
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.canvasView.becomeFirstResponder()
    }
    
    // MARK: Layout
    private func addView() {
        let leftItems = [
            self.saveButton,
            self.loadButton,
            self.addImageButton
        ]
        
        let rightItems = [
            self.eraseButton,
            self.penButton,
            self.forwardButton,
            self.backButton
        ]
        
        self.navigationItem.leftBarButtonItems = leftItems
        self.navigationItem.rightBarButtonItems = rightItems
        
        self.view.addSubview(self.backgroundImage)
        self.view.addSubview(self.canvasView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        self.backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.canvasView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Bind
    func bind(reactor: MainReactor) {
        // Action
        self.backButton.rx.tap
            .bind { [weak self] in
                self?.canvasView.undoManager?.undo()
            }
            .disposed(by: self.disposeBag)
        
        self.forwardButton.rx.tap
            .bind { [weak self] in
                self?.canvasView.undoManager?.redo()
            }
            .disposed(by: self.disposeBag)
        
        self.penButton.rx.tap
            .bind { [weak self] in
                self?.canvasView.tool = PKInkingTool(
                    .pen,
                    color: .black,
                    width: 15
                )
            }
            .disposed(by: self.disposeBag)
        
        self.eraseButton.rx.tap
            .bind { [weak self] in
                self?.canvasView.tool = PKEraserTool(.vector)
            }
            .disposed(by: self.disposeBag)
        
        
        self.addImageButton.rx.tap
            .map{ .tapImage }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.saveButton.rx.tap
            .filter { [weak self] in
                return self != nil
            }
            .map { [weak self] in
                return (self?.backgroundImage.image, self!.canvasView.drawing)
            }
            .map { canvas in
                Reactor.Action.tapSave(canvas.0, canvas.1)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.loadButton.rx.tap
            .map { .tapLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // Bind
        reactor.state.asObservable()
            .map(\.currentCanvas?.background)
            .bind { [weak self] image in
                self?.backgroundImage.image = image
            }
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map(\.currentCanvas?.canvas)
            .bind { [weak self] canvas in
                if let c = canvas {
                    self?.canvasView.drawing = c
                }
            }
            .disposed(by: self.disposeBag)
    }
}
