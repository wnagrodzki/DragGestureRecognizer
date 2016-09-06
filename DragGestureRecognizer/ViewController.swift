//
// MIT License
//
// Copyright (c) 2016 Wojciech Nagrodzki
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var draggableView: UIView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let dragGestureRecognizer = DragGestureRecognizer(target: self, action: #selector(ViewController.handleGesture(gestureRecognizer:)))
        draggableView.addGestureRecognizer(dragGestureRecognizer)
    }

    @objc private func handleGesture(gestureRecognizer: DragGestureRecognizer) {
        
        switch gestureRecognizer.state {
        
        case .began:
            UIView.animate(withDuration: 0.25, animations: {
                gestureRecognizer.setTranslation(self.draggableView.center, in: self.view)
                self.draggableView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                self.draggableView.alpha = 0.5
            })
        
        case .changed:
            draggableView.center = gestureRecognizer.translation(in: view)
        
        case .cancelled, .failed, .ended:
            UIView.animate(withDuration: 0.25, animations: {
                self.draggableView.transform = CGAffineTransform.identity
                self.draggableView.alpha = 1
            })
        
        case .possible:
            break
        }
    }
}

