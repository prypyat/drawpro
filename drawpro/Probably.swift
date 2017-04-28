//
//  Probably.swift
//
//
//  Created by Harlan Haskins on 07/10/2016.
//  Copyright © 2016 Harlan Haskins. All rights reserved.
//

import Foundation

enum Relation<T> where T: Strideable {
    case equal(T)
    case greater(T)
    case greaterOrEqual(T)
    case less(T)
    case lessOrEqual(T)
    case between(T, T)
    func range(min: T, max: T) -> Range<T> {
        switch self {
        case let .equal(x):
            return x..<x.advanced(by: 1)
        case let .greater(x):
            return x..<max
        case let .greaterOrEqual(x):
            return x..<max.advanced(by: 1)
        case let .less(x):
            return min..<x
        case let .lessOrEqual(x):
            return min..<x.advanced(by: 1)
        case let .between(x, y):
            return x..<y
        }
    }
}
protocol Distribution {
    associatedtype Interval
    var min: Interval { get }
    var max: Interval { get }
    func probability(of x: Interval) -> Double
    func expected() -> Double
    func variance() -> Double
    func standardDeviation() -> Double
}
extension Distribution
    where Interval: IntegerArithmetic,
    Interval: ExpressibleByIntegerLiteral,
Interval: Strideable, Interval.Stride: SignedInteger {
    func distribution(_ relation: Relation<Interval>) -> Double {
        return CountableRange(relation.range(min: min, max: max)).reduce(0) { d, x in
            d + probability(of: x)
        }
    }
}
extension Distribution {
    func standardDeviation() -> Double {
        return sqrt(variance())
    }
}
extension Int {
    func choose(_ k: Int) -> Int {
        var result = 1
        for i in 0..<k {
            result *= (self - i)
            result /= (i + 1)
        }
        return result
    }
    var factorial: Int {
        if self == 0 {
            return 1
        }
        return (1..<self).reduce(1, *)
    }
}
struct NegativeBinomial: Distribution {
    func variance() -> Double {
        return (Double(requiredSuccesses) * (1.0 - p)) / pow(p, 2)
    }
    func expected() -> Double {
        return (Double(requiredSuccesses) * (1.0 - p)) / p
    }
    let min = 0
    var max: Int {
        return requiredSuccesses
    }
    typealias Interval = Int
    let requiredSuccesses: Int
    let p: Double
    func probability(of x: Int) -> Double {
        return Double((x + requiredSuccesses - 1).choose(requiredSuccesses-1)) *
            pow(p, Double(x)) *
            pow(1-p, Double(x))
    }
}
struct Continuous: Distribution {
    let min = 0.0
    let max = DBL_MAX
    let function: (Double) -> Double
    typealias Interval = Double
    func probability(of x: Interval) -> Double {
        return 0
    }
    func distribution(_ relation: Relation<Double>, riemannInterval: Double = 0.01) -> Double {
        let range = relation.range(min: min, max: max)
        return riemannSum(range: range, interval: riemannInterval)
    }
    func expected() -> Double {
        return 0
    }
    func variance() -> Double {
        return 0
    }
    func riemannSum(range: Range<Double>, interval: Double) -> Double {
        var sum = 0.0
        var lower = range.lowerBound
        while lower <= range.upperBound {
            sum += function(lower) * interval
            lower += interval
        }
        return sum
    }
}
struct Poisson: Distribution {
    typealias Interval = Int
    let min = 0
    let max = Int.max - 1
    static let e = 2.7182818284590452353602
    let mu: Double
    init(mu: Double) {
        self.mu = mu
    }
    func probability(of x: Interval) -> Double {
        // E(X) =
        return (pow(Poisson.e, -mu) * pow(mu, Double(x))) / Double(x.factorial)
    }
    func expected() -> Double {
        return mu
    }
    func variance() -> Double {
        return mu
    }
}
struct Hypergeometric: Distribution {
    let numberOfTrials: Int
    let requiredSuccesses: Int
    let population: Int
    let min: Int = 0
    var max: Int {
        return numberOfTrials
    }
    func probability(of x: Int) -> Double {
        let numer = Double(requiredSuccesses.choose(x) *
            (population - requiredSuccesses).choose(numberOfTrials - x))
        let denom = Double(population.choose(numberOfTrials))
        return numer / denom
    }
    func expected() -> Double {
        return Double(numberOfTrials) * (Double(requiredSuccesses) / Double(population))
    }
    func variance() -> Double {
        let M = Double(requiredSuccesses)
        let n = Double(numberOfTrials)
        let N = Double(population)
        return ((N-n)/(N-1)) * n * (1 - (M/N))
    }
}
struct Standard: Distribution {
    let values: [Double]
    let min = 0
    var max: Int {
        return values.count - 1
    }
    func probability(of x: Int) -> Double {
        return values[x]
    }
    func expected() -> Double {
        return expected { $0 }
    }
    func expected(_ h: ((Double) -> Double)) -> Double {
        // E(h(X)) = sum 0-n of h(x) * p(x)
        return values
            .enumerated()
            .reduce(0) { d, pair in
                d + (h(Double(pair.offset)) * pair.element)
        }
    }
    func variance() -> Double {
        // V(X) = E(X²) - E(X)²
        let exp = expected()
        let squared = expected { pow($0, 2) }
        return squared - (exp*exp)
    }
}
