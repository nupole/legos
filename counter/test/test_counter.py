import pathlib
import enum
import random

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class CounterInstruction:
    class Opcode(enum.Enum):
        NOOP = 0
        DECR = 1
        INCR = 2
        LOAD = 3

    def __init__(self, opcode, operand):
        self.opcode = opcode
        self.operand = operand

class CounterInstructionSequence(pvm.sequences.InstructionIteratorSequence):
    def __init__(self, name):
        super().__init__(name, reversed(CounterInstruction.Opcode), len(CounterInstruction.Opcode))
        self._max_operand = (2 ** int(cocotb.top.RESULT_WIDTH.value)) - 1

    def _get_next_instruction(self, opcode):
        operand = random.randint(0, self._max_operand)
        return CounterInstruction(opcode, operand)

class CounterModel(pyuvm.uvm_subscriber):
    def build_phase(self):
        self.analysis_port = pyuvm.uvm_analysis_port('analysis_port', self)

    def start_of_simulation_phase(self):
        self._result = 0
        self._max_result = (2 ** int(cocotb.top.RESULT_WIDTH)) - 1

    def write(self, item):
        opcode, operand = item
        instruction = CounterInstruction(CounterInstruction.Opcode(opcode), int(operand))
        self._update(instruction)
        self.analysis_port.write(self._result)

    def _update(self, instruction):
        if instruction.opcode is CounterInstruction.Opcode.DECR:
            self._result = ((self._result - 1) % self._max_result)
        elif instruction.opcode is CounterInstruction.Opcode.INCR:
            self._result = ((self._result + 1) % self._max_result)
        elif instruction.opcode is CounterInstruction.Opcode.LOAD:
            self._result = instruction.operand

class CounterEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.instruction_sequencer = pyuvm.uvm_sequencer('instruction_sequencer', self)
        instruction_interface = pvm.interfaces.InstructionInterface(cocotb.top.clk, cocotb.top.instruction_opcode, cocotb.top.instruction_operand)
        self.instruction_driver = pvm.drivers.Driver('instruction_driver', self, instruction_interface)
        self.instruction_monitor = pvm.monitors.Monitor('instruction_monitor', self, instruction_interface)
        result_interface = pvm.interfaces.DataInterface(cocotb.top.clk, cocotb.top.result)
        self.result_monitor = pvm.monitors.Monitor('result_monitor', self, result_interface)
        self.model = CounterModel('model', self)
        self.scoreboard = pvm.scoreboards.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.instruction_driver.seq_item_port.connect(self.instruction_sequencer.seq_item_export)
        self.instruction_monitor.analysis_port.connect(self.model.analysis_export)
        self.result_monitor.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)

@pyuvm.test()
class CounterTest(pyuvm.uvm_test):
    def build_phase(self):
        self.env = CounterEnv('env', self)
        self.instruction_sequence = CounterInstructionSequence('counter_instruction_sequence')

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, unit = 'ns').start())
        await self.instruction_sequence.start(self.env.instruction_sequencer)
        self.drop_objection()

def test_counter():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_counter',
                hdl_toplevel = 'counter_tb',
                hdl_toplevel_library = 'hdl_counter_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])