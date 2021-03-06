// Copyright 2017 IBM RESEARCH. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =============================================================================

import Foundation

/**
 Hadamard gate.
 */
public final class HGate: Gate, CopyableInstruction {

    public let instructionComponent: InstructionComponent

    fileprivate init(_ qreg: QuantumRegisterTuple, _ circuit: QuantumCircuit) {
        self.instructionComponent = InstructionComponent("h", [], [qreg], circuit)
    }

    private init(_ name: String, _ params: [Double], _ args: [RegisterArgument], _ circuit: QuantumCircuit) {
        self.instructionComponent = InstructionComponent(name, params, args, circuit)
    }

    func copy(_ c: QuantumCircuit) -> Instruction {
        return HGate(self.name, self.params, self.args, c)
    }

    public var description: String {
        return self._qasmif("\(name) \(self.args[0].identifier)")
    }

    /**
     Invert this gate.
     */
    @discardableResult
    public func inverse() -> HGate {
        return self
    }

    /**
     Reapply this gate to corresponding qubits in circ.
     */
    public func reapply(_ circ: QuantumCircuit) throws {
        try self._modifiers(circ.h(self.args[0] as! QuantumRegisterTuple))
    }
}

extension QuantumCircuit {

    /**
     Apply H to q.
     */
    @discardableResult
    public func h(_ q: QuantumRegister) throws -> InstructionSet {
        let gs = InstructionSet()
        for j in 0..<q.size {
            gs.add(try self.h(QuantumRegisterTuple(q,j)))
        }
        return gs
    }

    /**
     Apply H to q.
     */
    @discardableResult
    public func h(_ q: QuantumRegisterTuple) throws -> HGate {
        try  self._check_qubit(q)
        return self._attach(HGate(q, self)) as! HGate
    }
}

extension CompositeGate {

    /**
     Apply H to q.
     */
    public func h(_ q: QuantumRegister) throws -> InstructionSet {
        let gs = InstructionSet()
        for j in 0..<q.size {
            gs.add(try self.h(QuantumRegisterTuple(q,j)))
        }
        return gs
    }

    /**
     Apply H to q.
     */
    @discardableResult
    public func h(_ q: QuantumRegisterTuple) throws -> HGate {
        try  self._check_qubit(q)
        return self._attach(HGate(q, self.circuit)) as! HGate
    }
}
