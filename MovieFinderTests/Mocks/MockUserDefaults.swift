import Foundation
@testable import MovieFinder

class MockUserDefaults: UserDefaultsProtocol {
    private var storage: [String: Any] = [:]
    var mockData: Data?
    var setCalled = false
    var removeObjectCalled = false
    var shouldFailSet = false
    
    func data(forKey defaultName: String) -> Data? {
        return mockData ?? storage[defaultName] as? Data
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        setCalled = true
        if shouldFailSet {
            // Simulate encoding failure
            return
        }
        storage[defaultName] = value
    }
    
    func removeObject(forKey defaultName: String) {
        removeObjectCalled = true
        mockData = nil
        storage.removeValue(forKey: defaultName)
    }
    
    // Helper methods for testing
    func clear() {
        storage.removeAll()
        mockData = nil
        setCalled = false
        removeObjectCalled = false
        shouldFailSet = false
    }
    
    func getStorage() -> [String: Any] {
        return storage
    }
} 