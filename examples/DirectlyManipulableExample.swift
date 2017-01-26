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

import UIKit
import IndefiniteObservable
import MaterialMotionStreams

public class DirectlyManipulableExampleViewController: UIViewController, UIGestureRecognizerDelegate {

  let runtime = MotionRuntime()
  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    var center = view.center
    center.x -= 64
    center.y -= 64
    let square = UIView(frame: .init(x: center.x, y: center.y, width: 128, height: 128))
    square.backgroundColor = .red
    view.addSubview(square)

    let interaction = DirectlyManipulable(view: square, containerView: view)
    interaction.connect(with: runtime)

    [interaction.draggable.gestureRecognizer,
     interaction.rotatable.gestureRecognizer,
     interaction.scalable.gestureRecognizer].forEach { $0.delegate = self }
  }

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}