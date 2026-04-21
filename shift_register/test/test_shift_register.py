import pathlib
import enum
import random

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class ShiftRegisterInstruction:
    class Opcode(enum.Enum):
        NOOP = 0
        SLL = 1
        SRL = 2
        LOAD = 3

    def __init__(self, opcode, operand):
        self.opcode = opcode
        self.operand = operand

class ShiftRegisterInstructionSequence(pvm.sequences.InstructionIteratorSequence):
    def __init__(self, name):
        super().__init__(name, reversed(ShiftRegisterInstruction.Opcode), len(ShiftRegisterInstruction.Opcode))
        self._max_operand = (2 ** int(cocotb.top.RESULT_WIDTH.value)) - 1

    def _get_next_instruction(self, opcode):
        operand = random.randint(0, self._max_operand)
        return ShiftRegisterInstruction(opcode, operand)

class ShiftRegisterModel(pyuvm.uvm_subscriber):
    def build_phase(self):
        self.analysis_port = pyuvm.uvm_analysis_port('analysis_port', self)

    def start_of_simulation_phase(self):
        self._result = 0
        self._result_width = int(cocotb.top.RESULT_WIDTH.value)
        self._result_mask = (2 ** self._result_width) - 1
        self._number_of_shifts_per_instruction = int(cocotb.top.NUMBER_OF_SHIFTS_PER_INSTRUCTION.value)
        self._number_of_shifts_per_instruction_mask = (2 ** self._number_of_shifts_per_instruction) - 1

    def write(self, item):
        opcode, operand = item
        operand = int(operand)
        instruction = ShiftRegisterInstruction(ShiftRegisterInstruction.Opcode(opcode), operand)
        self._update(instruction)
        self.analysis_port.write(self._result)

    def _update(self, instruction):
        if instruction.opcode is ShiftRegisterInstruction.Opcode.SLL:
            self._result = (instruction.operand & self._number_of_shifts_per_instruction_mask) | ((self._result << self._number_of_shifts_per_instruction) & self._result_mask)
        elif instruction.opcode is ShiftRegisterInstruction.Opcode.SRL:
            self._result = (instruction.operand & (self._number_of_shifts_per_instruction_mask << (self._result_width - self._number_of_shifts_per_instruction_mask))) | (self._result >> self._number_of_shifts_per_instruction)
        elif instruction.opcode is ShiftRegisterInstruction.Opcode.LOAD:
            self._result = instruction.operand

class ShiftRegisterEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.instruction_sequencer = pyuvm.uvm_sequencer('instruction_sequencer', self)
        instruction_interface = pvm.interfaces.InstructionInterface(cocotb.top.clk, cocotb.top.instruction_opcode, cocotb.top.instruction_operand)
        self.instruction_driver = pvm.drivers.Driver('instruction_driver', self, instruction_interface)
        self.instruction_monitor = pvm.monitors.Monitor('instruction_monitor', self, instruction_interface)
        result_interface = pvm.interfaces.DataInterface(cocotb.top.clk, cocotb.top.result)
        self.result_monitor = pvm.monitors.Monitor('result_monitor', self, result_interface)
        self.model = ShiftRegisterModel('model', self)
        self.scoreboard = pvm.scoreboards.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.instruction_driver.seq_item_port.connect(self.instruction_sequencer.seq_item_export)
        self.instruction_monitor.analysis_port.connect(self.model.analysis_export)
        self.result_monitor.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)

@pyuvm.test()
class ShiftRegisterTest(pyuvm.uvm_test):
    def build_phase(self):
        self.env = ShiftRegisterEnv('env', self)
        self.instruction_sequence = ShiftRegisterInstructionSequence('shift_register_instruction_sequence')

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, unit = 'ns').start())
        await self.instruction_sequence.start(self.env.instruction_sequencer)
        self.drop_objection()

def test_shift_register():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_shift_register',
                hdl_toplevel = 'shift_register_tb',
                hdl_toplevel_library = 'hdl_shift_register_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])