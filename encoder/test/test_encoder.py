import pathlib

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class EncoderEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.upstream_sequencer = pyuvm.uvm_sequencer('upstream_sequencer', self)
        upstream_interface = pvm.interfaces.data_interface.DataInterface(cocotb.top.clk, (cocotb.top.downstream_word_index, cocotb.top.upstream_word))
        self.upstream_driver = pvm.drivers.driver.Driver('upstream_driver', self, upstream_interface)
        self.upstream_monitor = pvm.monitors.monitor.Monitor('upstream_monitor', self, upstream_interface)
        downstream_interface = pvm.interfaces.data_interface.DataInterface(cocotb.top.clk, cocotb.top.downstream_word)
        self.downstream_monitor = pvm.monitors.monitor.Monitor('downstream_monitor', self, downstream_interface)
        self.model = pvm.models.EncoderModel('model', self)
        self.scoreboard = pvm.scoreboards.scoreboard.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.upstream_driver.seq_item_port.connect(self.upstream_sequencer.seq_item_export)
        self.upstream_monitor.analysis_port.connect(self.model.analysis_export)
        self.downstream_monitor.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)

@pyuvm.test()
class EncoderTest(pyuvm.uvm_test):
    def build_phase(self):
        max_word_index = 2 ** int(cocotb.top.DOWNSTREAM_WORD_INDEX_WIDTH.value)
        max_word = 2 ** int(cocotb.top.UPSTREAM_WORD_WIDTH.value) - 1
        self.env = EncoderEnv('env', self)
        self.upstream_sequence = pvm.sequences.IndexedRandomWordSequence('upstream_sequence', is_word_list = [False, False, False, True], max_word_index = max_word_index, max_word = max_word)

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, unit = 'ns').start())
        await self.upstream_sequence.start(self.env.upstream_sequencer)
        self.drop_objection()

def test_encoder():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_encoder',
                hdl_toplevel = 'encoder_tb',
                hdl_toplevel_library = 'hdl_encoder_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])