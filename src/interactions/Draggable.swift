/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

@objc(MDMDraggable)
public class Draggable: NSObject, ViewInteraction, MDMViewInteraction {

  public var targetView: UIView?
  public var relativeView: UIView?
  public lazy var gestureRecognizer = UIPanGestureRecognizer()

  public var onCompletion: ((UIPanGestureRecognizer) -> Void)?

  convenience init<S: Sequence>(gestureRecognizers: S) where S.Iterator.Element: UIGestureRecognizer {
    self.init()

    for gestureRecognizer in gestureRecognizers {
      switch gestureRecognizer {
      case let pan as UIPanGestureRecognizer:
        self.gestureRecognizer = pan
        break

      default:
        ()
      }
    }
  }

  public func add(to reactiveView: ReactiveUIView, withRuntime runtime: MotionRuntime) {
    let position = reactiveView.reactiveLayer.position
    let relativeView = self.relativeView ?? runtime.containerView

    targetView?.isUserInteractionEnabled = true

    var stream = runtime.get(gestureRecognizer).asStream()
    if let targetView = targetView {
      stream = stream.filter(whenStartsWithin: targetView)
    }
    runtime.add(stream.translated(from: position, in: relativeView),
                to: position)

    if let onCompletion = onCompletion {
      runtime.add(stream.onRecognitionState(.ended), to: createCallback(onCompletion))
    }
  }

  public func add(to view: UIView, withRuntime runtime: MDMMotionRuntime) {
    add(to: runtime.runtime.get(view), withRuntime: runtime.runtime)
  }
}
