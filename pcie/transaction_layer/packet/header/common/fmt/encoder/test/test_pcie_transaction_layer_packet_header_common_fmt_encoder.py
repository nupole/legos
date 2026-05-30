import pathlib
import random

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class PCIeTransactionLayerPacketHeaderCommonFmtEncoderSequence(pvm.sequences.TransactionSequence):
    def __init__(self, name, is_word_list = [True], max_number_of_words = 64, max_word_index = 16):
        super().__init__(name, is_word_list, max_number_of_words)
        self._max_word_index = max_word_index
        self._word_index = 0

    def _get_next_sequence_item(self, is_word):
        word_index = self._word_index
        if is_word:
            self._word_index += 1
            self._word_index %= self._max_word_index
        tlp_prefix = random.randint(0, 1)
        data_indicator = random.randint(0, 1)
        header_length = random.randint(0, 1)
        return pvm.sequences.data_sequence.DataSequenceItem('pcie_transaction_layer_packet_header_common_fmt_encoder_sequence', (word_index, tlp_prefix, data_indicator, header_length))

class PCIeTransactionLayerPacketHeaderCommonFmtEncoderModel(pyuvm.uvm_subscriber):
    def build_phase(self):
        self.analysis_port = pyuvm.uvm_analysis_port('analysis_port', self)
        self.bytes_per_word = int(int(cocotb.top.DOWNSTREAM_WORD_WIDTH.value) / 8)

    def write(self, indexed_word):
        indexed_word = tuple(int(x) for x in indexed_word)
        word_index, tlp_prefix, data_indicator, header_length = indexed_word
        packet = pvm.protocols.pcie_transaction_layer_packet.PCIeTransactionLayerPacket()
        packet.header.common.fmt_tlp_prefix = tlp_prefix
        packet.header.common.fmt_data_indicator = data_indicator
        packet.header.common.fmt_header_length = header_length
        offset = self.bytes_per_word * word_index
        downstream_word = int.from_bytes(packet.get_bytes(offset, self.bytes_per_word))
        self.analysis_port.write(downstream_word)

class PCIeTransactionLayerPacketHeaderCommonFmtEncoderEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.upstream_sequencer = pyuvm.uvm_sequencer('upstream_sequencer', self)
        upstream_interface = pvm.interfaces.data_interface.DataInterface(cocotb.top.clk, (cocotb.top.downstream_word_index, cocotb.top.fmt_tlp_prefix, cocotb.top.fmt_data_indicator, cocotb.top.fmt_header_length))
        self.upstream_driver = pvm.drivers.driver.Driver('upstream_driver', self, upstream_interface)
        self.upstream_monitor = pvm.monitors.monitor.Monitor('upstream_monitor', self, upstream_interface)
        downstream_interface = pvm.interfaces.data_interface.DataInterface(cocotb.top.clk, cocotb.top.downstream_word)
        self.downstream_monitor = pvm.monitors.monitor.Monitor('downstream_monitor', self, downstream_interface)
        self.model = PCIeTransactionLayerPacketHeaderCommonFmtEncoderModel('model', self)
        self.scoreboard = pvm.scoreboards.scoreboard.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.upstream_driver.seq_item_port.connect(self.upstream_sequencer.seq_item_export)
        self.upstream_monitor.analysis_port.connect(self.model.analysis_export)
        self.downstream_monitor.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)

@pyuvm.test()
class PCIeTransactionLayerPacketHeaderCommonFmtEncoderTest(pyuvm.uvm_test):
    def build_phase(self):
        max_word_index = 2 ** int(cocotb.top.DOWNSTREAM_WORD_INDEX_WIDTH.value)
        self.env = PCIeTransactionLayerPacketHeaderCommonFmtEncoderEnv('env', self)
        self.upstream_sequence = PCIeTransactionLayerPacketHeaderCommonFmtEncoderSequence('upstream_sequence', is_word_list = [False, False, False, True], max_word_index = max_word_index)

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, unit = 'ns').start())
        await self.upstream_sequence.start(self.env.upstream_sequencer)
        self.drop_objection()

def test_pcie_transaction_layer_packet_header_common_fmt_encoder():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_pcie_transaction_layer_packet_header_common_fmt_encoder',
                hdl_toplevel = 'pcie_transaction_layer_packet_header_common_fmt_encoder_tb',
                hdl_toplevel_library = 'hdl_pcie_transaction_layer_packet_header_common_fmt_encoder_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])