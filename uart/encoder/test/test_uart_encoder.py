import pathlib
import enum

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class UArtEncoderModel(pyuvm.uvm_subscriber):
    class UArtEncoderModelState(enum.Enum):
        START_BIT = enum.auto()
        DATA_BITS = enum.auto()
        STOP_BIT = enum.auto()

    def build_phase(self):
        self.analysis_port = pyuvm.uvm_analysis_port('analysis_port', self)
        clk_frequency = int(cocotb.top.CLK_FREQUENCY.value)
        baud_rate = int(cocotb.top.BAUD_RATE.value)
        self._frame_width = int(cocotb.top.FRAME_WIDTH.value)
        self._clks_per_baud_rate_beat = int(clk_frequency / baud_rate)
        self._baud_rate_beat_counter = 0
        self._tx_r = 1
        self._frame_index = 0
        self._frame = 0
        self._state = UArtEncoderModel.UArtEncoderModelState.START_BIT

    def write(self, item):
        if self._baud_rate_beat_counter == (self._clks_per_baud_rate_beat - 1):
            tx = int(item)
            match self._state:
                case UArtEncoderModel.UArtEncoderModelState.START_BIT:
                    if (not tx) and self.tx_r:
                        self._state = UArtEncoderModel.UArtEncoderModelState.DATA_BITS
                case UArtEncoderModel.UArtEncoderModelState.DATA_BITS:
                    self._frame = (tx << (self._frame_width - 1)) | (self._frame >> 1)
                    if self._frame_index == (self._frame_width - 1):
                        self._state = UArtEncoderModel.UArtEncoderModelState.STOP_BIT
                    self._frame_index = (self._frame_index + 1) % self._frame_width
                case UArtEncoderModel.UArtEncoderModelState.STOP_BIT:
                    self._state = UArtEncoderModel.UArtEncoderModelState.START_BIT
                    if tx:
                        self.analysis_port.write(self._frame)
            self.tx_r = tx
        self._baud_rate_beat_counter = (self._baud_rate_beat_counter + 1) % self._clks_per_baud_rate_beat

class UArtEncoderEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.reset_sequencer = pyuvm.uvm_sequencer('reset_sequencer', self)
        self.reset_interface = pvm.interfaces.DataInterface(cocotb.top.clk, cocotb.top.rst)
        self.reset_driver = pvm.drivers.Driver('reset_driver', self, self.reset_interface)
        self.ready_valid_frame_sequencer = pyuvm.uvm_sequencer('ready_valid_frame_sequencer', self)
        self.ready_valid_frame_interface = pvm.interfaces.ReadyValidDataInterface(cocotb.top.clk, cocotb.top.ready_frame, cocotb.top.valid_frame, cocotb.top.frame)
        self.ready_valid_frame_driver = pvm.drivers.Driver('ready_valid_frame_driver', self, self.ready_valid_frame_interface)
        self.ready_valid_frame_monitor = pvm.monitors.Monitor('ready_valid_frame_monitor', self, self.ready_valid_frame_interface)
        self.tx_interface = pvm.interfaces.DataInterface(cocotb.top.clk, cocotb.top.tx)
        self.tx_monitor = pvm.monitors.Monitor('tx_monitor', self, self.tx_interface)
        self.model = UArtEncoderModel('model', self)
        self.scoreboard = pvm.scoreboards.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.reset_driver.seq_item_port.connect(self.reset_sequencer.seq_item_export)
        self.ready_valid_frame_driver.seq_item_port.connect(self.ready_valid_frame_sequencer.seq_item_export)
        self.ready_valid_frame_monitor.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)
        self.tx_monitor.analysis_port.connect(self.model.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)

@pyuvm.test()
class UArtEncoderTest(pyuvm.uvm_test):
    def build_phase(self):
        frame_width = int(cocotb.top.FRAME_WIDTH.value)
        max_frame = (2 ** frame_width) - 1
        self.env = UArtEncoderEnv('env', self)
        self.reset_sequence = pvm.sequences.IterableDataSequence('reset_sequence', [True, False])
        self.fast_transmitter_sequence = pvm.sequences.RandomValidDataSequence('fast_transmitter_sequence', max_data = max_frame)
        self.slow_transmitter_sequence = pvm.sequences.RandomValidDataSequence('slow_transmitter_sequence', max_data = max_frame, is_transaction_list = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, True])

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, units = 'ns').start())
        await self.reset_sequence.start(self.env.reset_sequencer)
        await self.fast_transmitter_sequence.start(self.env.ready_valid_frame_sequencer)
        await self.slow_transmitter_sequence.start(self.env.ready_valid_frame_sequencer)
        self.drop_objection()

def test_uart_encoder_tb_runner():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_uart_encoder',
                hdl_toplevel = 'uart_encoder_tb',
                hdl_toplevel_library = 'hdl_uart_encoder_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])