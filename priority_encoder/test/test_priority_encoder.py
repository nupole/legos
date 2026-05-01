import pathlib

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class PriorityEncoderModel(pyuvm.uvm_subscriber):
    def build_phase(self):
        self.analysis_port = pyuvm.uvm_analysis_port('analysis_port', self)

    def start_of_simulation_phase(self):
        self._request_width = int(cocotb.top.REQUEST_WIDTH)
        self._request_mask = 1

    def write(self, item):
        data = int(item)
        grant_index = 0
        for index in range(self._request_width):
            if((data >> index) & self._request_mask):
                grant_index = index
                break
        self.analysis_port.write(grant_index)

class PriorityEncoderEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.request_sequencer = pyuvm.uvm_sequencer('request_sequencer', self)
        request_interface = pvm.interfaces.DataInterface(cocotb.top.clk, cocotb.top.request)
        self.request_driver = pvm.drivers.Driver('request_driver', self, request_interface)
        self.request_monitor = pvm.monitors.Monitor('request_monitor', self, request_interface)
        grant_index_interface = pvm.interfaces.DataInterface(cocotb.top.clk, cocotb.top.grant_index)
        self.grant_index_monitor = pvm.monitors.Monitor('grant_index_monitor', self, grant_index_interface)
        self.model = PriorityEncoderModel('model', self)
        self.scoreboard = pvm.scoreboards.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.request_driver.seq_item_port.connect(self.request_sequencer.seq_item_export)
        self.request_monitor.analysis_port.connect(self.model.analysis_export)
        self.grant_index_monitor.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)

@pyuvm.test()
class PriorityEncoderTest(pyuvm.uvm_test):
    def build_phase(self):
        self.env = PriorityEncoderEnv('env', self)
        self.request_sequence = pvm.sequences.RandomDataSequence('request_sequence', 15)

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, unit = 'ns').start())
        await self.request_sequence.start(self.env.request_sequencer)
        self.drop_objection()

def test_priority_encoder():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_priority_encoder',
                hdl_toplevel = 'priority_encoder_tb',
                hdl_toplevel_library = 'hdl_priority_encoder_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])