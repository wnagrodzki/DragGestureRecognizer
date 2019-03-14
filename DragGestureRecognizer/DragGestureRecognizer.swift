//
//  DragGestureRecognizer.swift
//  DragGestureRecognizer
//
//  Created by Wojciech Nagrodzki on 01/09/16.
//  Copyright © 2016 Wojciech Nagrodzki. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

/// `DragGestureRecognizer` is a subclass of `UILongPressGestureRecognizer` that allows for tracking translation similarly to `UIPanGestureRecognizer`.
class DragGestureRecognizer: UILongPressGestureRecognizer {
    
    private var initialTouchLocationInScreenFixedCoordinateSpace: CGPoint?
    private var initialTouchLocationsInViews = [UIView: CGPoint]()

    /// The total translation of the drag gesture in the coordinate system of the specified view.
    /// - parameters:
    ///     - view: The view in whose coordinate system the translation of the drag gesture should be computed. Pass `nil` to indicate window.
    func translation(in view: UIView?) -> CGPoint {
        
        // not attached to a view or outside window
        guard let window = self.view?.window else { return CGPoint() }
        // gesture not in progress
        guard let initialTouchLocationInScreenFixedCoordinateSpace = initialTouchLocationInScreenFixedCoordinateSpace else { return CGPoint() }
        
        let initialLocation: CGPoint
        let currentLocation: CGPoint
        
        if let view = view {
            initialLocation = initialTouchLocationsInViews[view] ?? window.screen.fixedCoordinateSpace.convert(initialTouchLocationInScreenFixedCoordinateSpace, to: view)
            currentLocation = location(in: view)
        }
        else {
            initialLocation = initialTouchLocationInScreenFixedCoordinateSpace
            currentLocation = location(in: nil)
        }
        
        return CGPoint(x: currentLocation.x - initialLocation.x, y: currentLocation.y - initialLocation.y)
    }
    
    /// Sets the translation value in the coordinate system of the specified view.
    /// - parameters:
    ///     - translation: A point that identifies the new translation value.
    ///     - view: A view in whose coordinate system the translation is to occur. Pass `nil` to indicate window.
    func setTranslation(_ translation: CGPoint, in view: UIView?) {
        
        // not attached to a view or outside window
        guard let window = self.view?.window else { return }
        // gesture not in progress
        guard let _ = initialTouchLocationInScreenFixedCoordinateSpace else { return }
        
        let inView = view ?? window
        let currentLocation = location(in: inView)
        let initialLocation = CGPoint(x: currentLocation.x - translation.x, y: currentLocation.y - translation.y)
        initialTouchLocationsInViews[inView] = initialLocation
    }
    
    override var state: UIGestureRecognizer.State {
        
        didSet {
            
            switch state {
                
            case .began:
                initialTouchLocationInScreenFixedCoordinateSpace = location(in: nil)
            
            case .ended, .cancelled, .failed:
                initialTouchLocationInScreenFixedCoordinateSpace = nil
                initialTouchLocationsInViews = [:]
            
            case .possible, .changed:
                break
            }
        }
    }
}
