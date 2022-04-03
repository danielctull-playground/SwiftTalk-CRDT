
import Foundation

extension Int {

    static var random: Int {
        .random(in: Int.min..<Int.max)
    }
}
