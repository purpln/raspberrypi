import Architecture

@main
struct App: Application {
    var scenes: [any Scene] { [
        Service()
    ] }
}
