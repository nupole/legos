import pathlib
import random

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class DeserializerValidDataSequence(pvm.sequences.ValidDataSequence):
    def __init__(self, name):
        super().__init__(name)
        operand_data_width = int(cocotb.top.OPERAND_DATA_WIDTH.value)
        result_width = int(cocotb.top.RESULT_WIDTH.value)
        self._max_operand_number_of_words = int(result_width / operand_data_width) - 1
        self._max_operand_data = (2 ** operand_data_width) - 1

    def _get_data(self):
        return self._get_random_data()

    def _get_random_data(self):
        operand_number_of_words = 3 # random.randint(0, self._max_operand_number_of_words)
        operand_data = random.randint(0, self._max_operand_data)
        return (operand_number_of_words, operand_data)

class DeserializerModel(pyuvm.uvm_subscriber):
    def build_phase(self):
        self.analysis_port = pyuvm.uvm_analysis_port('analysis_port', self)
        self._operand_data_width = int(cocotb.top.OPERAND_DATA_WIDTH.value)
        self._number_of_words_deserialized = 0
        self._result = 0

    def write(self, item):
        number_of_words, data = item
        number_of_words, data = int(number_of_words) + 1, int(data)
        self._result = (self._result << self._operand_data_width) | data
        self._number_of_words_deserialized += 1
        if self._number_of_words_deserialized == number_of_words:
            self.analysis_port.write(self._result)
            self._number_of_words_deserialized = 0
            self._result = 0

class DeserializerEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.reset_sequencer = pyuvm.uvm_sequencer('reset_sequencer', self)
        self.reset_interface = pvm.interfaces.DataInterface(cocotb.top.clk, cocotb.top.rst)
        self.reset_driver = pvm.drivers.Driver('reset_driver', self, self.reset_interface)
        self.ready_valid_operand_sequencer = pyuvm.uvm_sequencer('ready_valid_operand_sequencer', self)
        pyuvm.ConfigDB().set(None, '*', 'VALID_DATA_SEQUENCER', self.ready_valid_operand_sequencer)
        self.ready_valid_operand_interface = pvm.interfaces.ReadyValidDataInterface(cocotb.top.clk, cocotb.top.ready_operand, cocotb.top.valid_operand, (cocotb.top.operand_number_of_words, cocotb.top.operand_data))
        self.ready_valid_operand_driver = pvm.drivers.Driver('ready_valid_operand_driver', self, self.ready_valid_operand_interface)
        self.ready_valid_operand_monitor = pvm.monitors.Monitor('ready_valid_operand_monitor', self, self.ready_valid_operand_interface)
        self.ready_valid_result_sequencer = pyuvm.uvm_sequencer('ready_valid_result_sequencer', self)
        pyuvm.ConfigDB().set(None, '*', 'READY_SEQUENCER', self.ready_valid_result_sequencer)
        self.ready_valid_result_interface = pvm.interfaces.ReadyValidDataInterface(cocotb.top.clk, cocotb.top.ready_result, cocotb.top.valid_result, cocotb.top.result)
        self.ready_valid_result_driver = pvm.drivers.Driver('ready_valid_result_driver', self, self.ready_valid_result_interface)
        self.ready_valid_result_monitor = pvm.monitors.Monitor('ready_valid_result_monitor', self, self.ready_valid_result_interface)
        self.model = DeserializerModel('model', self)
        self.scoreboard = pvm.scoreboards.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.reset_driver.seq_item_port.connect(self.reset_sequencer.seq_item_export)
        self.ready_valid_operand_driver.seq_item_port.connect(self.ready_valid_operand_sequencer.seq_item_export)
        self.ready_valid_operand_monitor.analysis_port.connect(self.model.analysis_export)
        self.ready_valid_result_driver.seq_item_port.connect(self.ready_valid_result_sequencer.seq_item_export)
        self.ready_valid_result_monitor.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)

@pyuvm.test()
class DeserializerTest(pyuvm.uvm_test):
    def build_phase(self):
        operand_data_width = int(cocotb.top.OPERAND_DATA_WIDTH.value)
        result_width = int(cocotb.top.RESULT_WIDTH.value)
        number_of_valid_data_transactions_per_ready_transaction = int(result_width / operand_data_width)
        max_number_of_ready_transactions = 16
        max_number_of_valid_data_transactions = number_of_valid_data_transactions_per_ready_transaction * max_number_of_ready_transactions
        pyuvm.ConfigDB().set(None, '*', 'MAX_NUMBER_OF_VALID_DATA_TRANSACTIONS', max_number_of_valid_data_transactions)
        pyuvm.ConfigDB().set(None, '*', 'MAX_NUMBER_OF_READY_TRANSACTIONS', max_number_of_ready_transactions)
        pyuvm.uvm_factory().set_type_override_by_type(pvm.sequences.ValidDataSequence, DeserializerValidDataSequence)
        self.env = DeserializerEnv('env', self)
        self.reset_sequence = pvm.sequences.IterableDataSequence('reset_sequence', [True, False])
        self.transmitter_receiver_sequence = pvm.sequences.TransmitterReceiverSequence('transmitter_receiver_sequence')

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, units = 'ns').start())
        await self.reset_sequence.start(self.env.reset_sequencer)
        await self.transmitter_receiver_sequence.start()
        self.drop_objection()

def test_deserializer_tb_runner():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_deserializer',
                hdl_toplevel = 'deserializer_tb',
                hdl_toplevel_library = 'hdl_deserializer_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])