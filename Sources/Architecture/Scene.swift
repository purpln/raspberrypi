public protocol Scene {
    init() async throws
    func execute() async throws
}
