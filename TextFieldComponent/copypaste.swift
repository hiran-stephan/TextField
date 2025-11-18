class ActionItemsHelperSpec: QuickSpec {
    override func spec() {

        describe("ActionItemsHelper.fetchAndCacheKYCContent") {

            var mockWorker: BKKYCContentWorkerMock!

            beforeEach {
                BKServiceCache.shared.removeCachedKycContent()
                mockWorker = BKKYCContentWorkerMock()
            }

            it("returns true if KYC content is already cached") {
                // Arrange
                let mockContent = KYCResponse(responses: ["content": [:]])
                BKServiceCache.shared.setCachedKycContent(mockContent)

                // Act / Assert
                waitUntil { done in
                    ActionItemsHelper.fetchAndCacheKYCContent(worker: mockWorker) { result in
                        expect(result).to(beTrue())
                        done()
                    }
                }
            }

            it("returns true if KYC content fetch succeeds") {
                // Arrange
                mockWorker.simulateSuccess()

                // Act / Assert
                waitUntil { done in
                    ActionItemsHelper.fetchAndCacheKYCContent(worker: mockWorker) { result in
                        expect(result).to(beTrue())
                        expect(mockWorker.getKycContentCalled).to(beTrue())
                        done()
                    }
                }
            }

            it("returns false if KYC content fetch fails") {
                // Arrange
                mockWorker.simulateFailure()

                // Act / Assert
                waitUntil { done in
                    ActionItemsHelper.fetchAndCacheKYCContent(worker: mockWorker) { result in
                        expect(result).to(beFalse())
                        expect(mockWorker.getKycContentCalled).to(beTrue())
                        done()
                    }
                }
            }
        }
    }
}
