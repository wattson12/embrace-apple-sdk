//
//  Copyright © 2023 Embrace Mobile, Inc. All rights reserved.
//
#if canImport(UIKit)

import UIKit
import EmbraceCommon

extension UIViewController {
    var embViewName: String {
        var title: String?

        if let customized = self as? EmbraceViewControllerCustomization {
            title = customized.nameForViewControllerInEmbrace()
        } else {
            title = self.title
        }

        return title ?? ""
    }

    var embViewIgnored: Bool {
        // TODO: if automatic view capture is disabled, return true

        return false
    }
}

#endif
