// Seed recursive disassembly from evidence-backed bank-qualified code entries.
//@category Doraemon

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.mem.MemoryBlock;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class ApplyKnownCode extends GhidraScript {
    private MemoryBlock findPrg() {
        for (MemoryBlock block : currentProgram.getMemory().getBlocks()) {
            if (block.isInitialized() && block.isExecute() && block.getSize() == 0x8000 &&
                block.getStart().getOffset() == 0x8000) {
                return block;
            }
        }
        return null;
    }

    @Override
    public void run() throws Exception {
        String[] args = getScriptArgs();
        if (args.length != 1) {
            throw new IllegalArgumentException("expected PRG code entries path");
        }
        List<String> lines = Files.readAllLines(
            Path.of(args[0]).toAbsolutePath(), StandardCharsets.UTF_8
        );
        MemoryBlock prg = findPrg();
        if (prg == null) {
            throw new IllegalStateException("initialized 32 KiB PRG block not found");
        }
        int count = 0;
        for (String raw : lines) {
            String line = raw.trim();
            if (line.isEmpty() || line.startsWith("#")) {
                continue;
            }
            String[] fields = line.split("\\s+");
            if (fields.length != 2) {
                throw new IllegalArgumentException("invalid PRG code entry: " + raw);
            }
            long offset = Long.parseLong(fields[0], 16);
            Address address = prg.getStart().getAddressSpace().getAddress(offset);
            if (!prg.contains(address)) {
                throw new IllegalArgumentException("PRG code entry outside bank: " + raw);
            }
            if (!disassemble(address)) {
                throw new IllegalStateException("cannot disassemble PRG code entry: " + raw);
            }
            Function function = getFunctionAt(address);
            if (function == null) {
                function = createFunction(address, fields[1]);
            } else {
                function.setName(fields[1], ghidra.program.model.symbol.SourceType.USER_DEFINED);
            }
            count++;
        }
        analyzeChanges(currentProgram);
        println("[OK] applied " + count + " evidence-backed PRG code entries");
    }
}
