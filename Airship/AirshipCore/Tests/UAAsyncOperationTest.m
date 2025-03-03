/* Copyright Airship and Contributors */

#import "UABaseTest.h"
#import "UAAsyncOperation+Internal.h"

@interface UAAsyncOperationTest : UABaseTest
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation UAAsyncOperationTest

- (void)setUp {
    [super setUp];
    self.queue = [[NSOperationQueue alloc] init];
}

/**
 * Test async block is called for the operation.
 */
- (void)testPerform {
    XCTestExpectation *blockCalled = [self expectationWithDescription:@"Block called"];

    UAAsyncOperation *operation = [UAAsyncOperation operationWithBlock:^(UAAsyncOperation *operation) {
        XCTAssertTrue(operation.isExecuting);
        XCTAssertFalse(operation.isFinished);

        [operation finish];

        XCTAssertTrue(operation.isFinished);
        XCTAssertFalse(operation.isExecuting);

        [blockCalled fulfill];
    }];

    [self.queue addOperation:operation];
    [self waitForTestExpectations];
}

/**
 * Test cancel does not set isFinished or isExecuting if the task is in progress.
 */
- (void)testCancel {
    XCTestExpectation *blockCalled = [self expectationWithDescription:@"Block called"];

    UAAsyncOperation *operation = [UAAsyncOperation operationWithBlock:^(UAAsyncOperation *operation) {
        XCTAssertTrue(operation.isExecuting);
        XCTAssertFalse(operation.isFinished);

        [operation cancel];

        XCTAssertTrue(operation.isExecuting);
        XCTAssertFalse(operation.isFinished);

        [operation finish];


        XCTAssertTrue(operation.isFinished);
        XCTAssertFalse(operation.isExecuting);

        [blockCalled fulfill];
    }];

    [self.queue addOperation:operation];
    [self waitForTestExpectations];
}

@end
