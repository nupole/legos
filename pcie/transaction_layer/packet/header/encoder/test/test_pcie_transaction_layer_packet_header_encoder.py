import pathlib
import random

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class PcieTransactionLayerPacketHeaderEncoderSequence(pvm.sequences.TransactionSequence):
    def __init__(self, name, is_word_list = [True], max_number_of_words = 64, max_word_index = 16):
        super().__init__(name, is_word_list, max_number_of_words)
        self._max_word_index = max_word_index
        self._word_index = 0

    def _get_next_sequence_item(self, is_word):
        word_index = self._word_index
        if is_word:
            self._word_index += 1
            self._word_index %= self._max_word_index
        fmt_tlp_prefix = random.randint(0, 1)
        fmt_data_indicator = random.randint(0, 1)
        fmt_header_length = random.randint(0, 1)
        packet_type = random.randint(0, 31)
        tc = random.randint(0, 7)
        attr_id_based_ordering = random.randint(0, 1)
        attr_relaxed_ordering = random.randint(0, 1)
        attr_no_snoop = random.randint(0, 1)
        th = random.randint(0, 1)
        td = random.randint(0, 1)
        ep = random.randint(0, 1)
        at = random.randint(0, 3)
        length = random.randint(0, 1023)
        requester_id = random.randint(0, 65535)
        tag = random.randint(0, 255)
        return pvm.sequences.data_sequence.DataSequenceItem('pcie_transaction_layer_packet_header_encoder_sequence', (word_index, fmt_tlp_prefix, fmt_data_indicator, fmt_header_length, packet_type, tc, attr_id_based_ordering, attr_relaxed_ordering, attr_no_snoop, th, td, ep, at, length, requester_id, tag))

class PcieTransactionLayerPacketHeaderEncoderEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.upstream_sequencer = pyuvm.uvm_sequencer('upstream_sequencer', self)
        upstream_interface = pvm.interfaces.data_interface.DataInterface(cocotb.top.clk, (cocotb.top.downstream_word_index, cocotb.top.header_common_fmt_tlp_prefix, cocotb.top.header_common_fmt_data_indicator, cocotb.top.header_common_fmt_header_length, cocotb.top.header_common_packet_type, cocotb.top.header_common_tc, cocotb.top.header_common_attr_id_based_ordering, cocotb.top.header_common_attr_relaxed_ordering, cocotb.top.header_common_attr_no_snoop, cocotb.top.header_common_th, cocotb.top.header_common_td, cocotb.top.header_common_ep, cocotb.top.header_common_at, cocotb.top.header_common_length, cocotb.top.header_request_requester_id, cocotb.top.header_request_tag))
        self.upstream_driver = pvm.drivers.driver.Driver('upstream_driver', self, upstream_interface)
        self.upstream_monitor = pvm.monitors.monitor.Monitor('upstream_monitor', self, upstream_interface)
        downstream_interface = pvm.interfaces.data_interface.DataInterface(cocotb.top.clk, cocotb.top.downstream_word)
        self.downstream_monitor = pvm.monitors.monitor.Monitor('downstream_monitor', self, downstream_interface)
        self.model = pvm.models.ProtocolEncoderModel('model', self, pvm.encoders.PcieTransactionLayerPacketHeaderEncoder(int(cocotb.top.DOWNSTREAM_WORD_WIDTH.value)))
        self.scoreboard = pvm.scoreboards.scoreboard.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.upstream_driver.seq_item_port.connect(self.upstream_sequencer.seq_item_export)
        self.upstream_monitor.analysis_port.connect(self.model.analysis_export)
        self.downstream_monitor.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)

@pyuvm.test()
class PcieTransactionLayerPacketHeaderEncoderTest(pyuvm.uvm_test):
    def build_phase(self):
        max_word_index = 2 ** int(cocotb.top.DOWNSTREAM_WORD_INDEX_WIDTH.value)
        self.env = PcieTransactionLayerPacketHeaderEncoderEnv('env', self)
        self.upstream_sequence = PcieTransactionLayerPacketHeaderEncoderSequence('upstream_sequence', is_word_list = [False, False, False, True], max_word_index = max_word_index)

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, unit = 'ns').start())
        await self.upstream_sequence.start(self.env.upstream_sequencer)
        self.drop_objection()

def test_pcie_transaction_layer_packet_header_encoder():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_pcie_transaction_layer_packet_header_encoder',
                hdl_toplevel = 'pcie_transaction_layer_packet_header_encoder_tb',
                hdl_toplevel_library = 'hdl_pcie_transaction_layer_packet_header_encoder_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])