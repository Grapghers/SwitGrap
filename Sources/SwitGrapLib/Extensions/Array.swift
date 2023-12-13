import Foundation

//이해완
extension Array {
    
    //새로운 배열을 추가
    func appending(_ element: Element) -> [Element] {
        self + [element]
    }
}

extension Array where Element: Hashable {

    // 배열의 중복을 제거
    func unique() -> [Element] {
        Array(Set(self))
    }

}

extension Array where Element == String {

    // 대소문자 무시하고 오름차순으로 바꾸기
    func sortedAscendingCaseInsensitively() -> [String] {
        sorted { a, b -> Bool in
            let _a = a.lowercased()
            let _b = b.lowercased()
            return _a == _b ? a < b : _a < _b
        }
    }

}
