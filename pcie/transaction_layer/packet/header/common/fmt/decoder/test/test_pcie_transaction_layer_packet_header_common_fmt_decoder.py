import pathlib

import cocotb
import cocotb.clock
import cocotb_tools.runner

import pyuvm

import pvm

class PCIeTransactionLayerPacketHeaderCommonFmtDecoderModel(pyuvm.uvm_subscriber):
    def build_phase(self):
        self.analysis_port = pyuvm.uvm_analysis_port('analysis_port', self)
        self._valid = False
        self._packet = pvm.protocols.pcie_transaction_layer_packet.PCIeTransactionLayerPacket()

    def write(self, indexed_word):
        word_index, word = indexed_word
        word_index, word = (int(word_index), int(word))
        self._packet.copy_to(word_index, word.to_bytes(1, 'big'))
        tlp_prefix = self._packet.header.common.fmt_tlp_prefix
        data_indicator = self._packet.header.common.fmt_data_indicator
        header_length = self._packet.header.common.fmt_header_length
        error = tlp_prefix and (data_indicator or header_length)
        self.analysis_port.write((tlp_prefix, data_indicator, header_length, error))

class PCIeTransactionLayerPacketHeaderCommonFmtDecoderEnv(pyuvm.uvm_env):
    def build_phase(self):
        self.upstream_sequencer = pyuvm.uvm_sequencer('upstream_sequencer', self)
        upstream_interface = pvm.interfaces.data_interface.DataInterface(cocotb.top.clk, (cocotb.top.upstream_word_index, cocotb.top.upstream_word))
        self.upstream_driver = pvm.drivers.driver.Driver('upstream_driver', self, upstream_interface)
        self.upstream_monitor = pvm.monitors.monitor.Monitor('upstream_monitor', self, upstream_interface)
        downstream_interface = pvm.interfaces.data_interface.DataInterface(cocotb.top.clk, (cocotb.top.fmt_tlp_prefix, cocotb.top.fmt_data_indicator, cocotb.top.fmt_header_length, cocotb.top.fmt_error))
        self.downstream_monitor = pvm.monitors.monitor.Monitor('downstream_monitor', self, downstream_interface)
        self.model = PCIeTransactionLayerPacketHeaderCommonFmtDecoderModel('model', self)
        self.scoreboard = pvm.scoreboards.scoreboard.Scoreboard('scoreboard', self)

    def connect_phase(self):
        self.upstream_driver.seq_item_port.connect(self.upstream_sequencer.seq_item_export)
        self.upstream_monitor.analysis_port.connect(self.model.analysis_export)
        self.downstream_monitor.analysis_port.connect(self.scoreboard.actual_data_analysis_fifo.analysis_export)
        self.model.analysis_port.connect(self.scoreboard.expected_data_analysis_fifo.analysis_export)

@pyuvm.test()
class PCIeTransactionLayerPacketHeaderCommonFmtDecoderTest(pyuvm.uvm_test):
    def build_phase(self):
        max_word_index = 2 ** int(cocotb.top.UPSTREAM_WORD_INDEX_WIDTH.value)
        max_word = 2 ** int(cocotb.top.UPSTREAM_WORD_WIDTH.value) - 1
        self.env = PCIeTransactionLayerPacketHeaderCommonFmtDecoderEnv('env', self)
        self.upstream_sequence = pvm.sequences.IndexedRandomWordSequence('upstream_sequence', is_word_list = [False, False, False, True], max_word_index = max_word_index, max_word = max_word)

    async def run_phase(self):
        self.raise_objection()
        cocotb.start_soon(cocotb.clock.Clock(cocotb.top.clk, 10, unit = 'ns').start())
        await self.upstream_sequence.start(self.env.upstream_sequencer)
        self.drop_objection()

def test_pcie_transaction_layer_packet_header_common_fmt_decoder():
    runner = cocotb_tools.runner.get_runner('ghdl')

    current_dir = pathlib.Path().absolute()

    runner.test(test_module = 'test_pcie_transaction_layer_packet_header_common_fmt_decoder',
                hdl_toplevel = 'pcie_transaction_layer_packet_header_common_fmt_decoder_tb',
                hdl_toplevel_library = 'hdl_pcie_transaction_layer_packet_header_common_fmt_decoder_tb',
                hdl_toplevel_lang = 'vhdl',
                build_dir = current_dir,
                test_dir = current_dir,
                plusargs = ['--fst=waves.fst'])