//import Foundation
//
//protocol DefaultValueType<T> {
//    associatedtype T
//    
//    static var defaultValue: T { get }
//}
//
//class Matrix<T: DefaultValueType<T>> {
//    struct Size {
//        let width, height: Int
//    }
//    
//    private let size: Size
//    private var data: Array<T>
//    
//    init(size: Size) {
//        self.size = size
//        data = .init(repeating: T.defaultValue, count: size.height * size.width)
//    }
//}
