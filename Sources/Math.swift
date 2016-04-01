public func clamp(value: Double, min minValue: Double, max maxValue: Double) -> Double {
    precondition(minValue <= maxValue)
    return max(minValue, min(value, maxValue))
}

public func map(value: Double, min minValue: Double, max maxValue: Double) -> Double {
    let difference = maxValue - minValue
    return clamp((value * difference) + minValue, min: minValue, max: maxValue)
}

public func fequal(lhs: Double, _ rhs: Double, epsilon: Double = 1e-6) -> Bool {
    return abs(lhs - rhs) < 1e-6
}
