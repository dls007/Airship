/* Copyright Airship and Contributors */

/**
 * @note For internal use only. :nodoc:
 */
@objc
public class UASemaphore : NSObject {
    private let semaphore: DispatchSemaphore

    @objc
    public override convenience init() {
        self.init(value: 0)
    }

    @objc
    public init(value: Int = 0) {
        self.semaphore = DispatchSemaphore(value: value)
        super.init()
    }

    @objc
    public func wait() {
        self.semaphore.wait()
    }

    @objc
    @discardableResult
    public func wait(_ timeout: TimeInterval) -> Bool {
        return self.semaphore.wait(timeout: DispatchTime.now() + timeout) == .success
    }

    @objc
    @discardableResult
    public func signal() -> Bool {
        return self.semaphore.signal() != 0
    }
}
