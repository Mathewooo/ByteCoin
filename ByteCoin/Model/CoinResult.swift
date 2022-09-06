struct CoinResult {
    private let value: Float
    
    var getValue: String {
        String(format: "%.3f", value)
    }
    
    init(rate: Float) {
        value = rate
    }
}
