import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet { observer?(value) }
    }
    
    
    fileprivate var observer: ((T?) -> ())?
    
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
