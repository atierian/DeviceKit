import XCTest
import DeviceKit

final class DeviceKitTests: XCTestCase {
    func testExample() throws {
        print(Device.current)
        print(Device.current.userFriendlyName)
    }
}
