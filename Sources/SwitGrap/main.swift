import Foundation
import SwitGrapLib

let options = SwitGrapherArguments.parseOrExit()

do {
    try SwitGrapher.run(with: options)
} catch {
    die(error.localizedDescription)
}
