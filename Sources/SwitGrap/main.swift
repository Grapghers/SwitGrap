import Foundation
import SwitGrapLib

let options = SwitGrapArguments.parseOrExit()

do {
    try SwitGrap.run(with: options)
} catch {
    die(error.localizedDescription)
}
