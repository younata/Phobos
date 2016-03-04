import Quick
import Nimble

import Phobos

class MathSpec: QuickSpec {
    override func spec() {
        describe("clamp") {
            it("throws if the min is greater than the max") {
                expect(clamp(1, min: 2, max: 0)).to(raiseException())
            }

            it("returns the max if value was greater than max") {
                expect(clamp(2, min: 0, max: 1)) == 1
            }

            it("returns the min if value was less than min") {
                expect(clamp(-1, min: 0, max: 1)) == 0
            }

            it("returns the value if it's between min and max") {
                expect(clamp(0.5, min: 0, max: 1)) ≈ 0.5
            }
        }

        describe("map") {
            it("maps the input value continuously across from min to max") {
                expect(map(0.5, 3, 5)) ≈ 4.0
            }

            it("clamps the output from the min to the max") {
                expect(map(-2, 3, 5)) == 3
                expect(map(6, 3, 5)) == 5
            }
        }

        describe("fequal") {
            it("returns whether or not two floating values are effectively equal") {
                expect(fequal(1e-9, 1e-9)) == true
                expect(fequal(1.4, 1.3)) == false
            }
        }
    }
}
