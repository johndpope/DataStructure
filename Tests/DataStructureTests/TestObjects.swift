//
//struct SharedTestValueType {
//    var _0 = 0
//    var _1 = 0
//    var _2 = 0
//    var _3 = 0
//    var _4 = 0
//    var _5 = 0
//    var _6 = 0
//    var _7 = 0
//    var _8 = 0
//
//    var i : Int {
//        return _0
//    } 
//
//    init() {}
//
//    init(_ val: Int) {
//        self._0 = val
//    }
//}
//
//class SharedTestRefType {
//    var _0 = SharedTestValueType()
//
//    var i: Int {
//        return _0.i
//    }
//
//    init() {}
//    init(_ v: Int) {
//        self._0 = SharedTestValueType(v)
//    }
//
//    deinit {
//
//    }
//}
