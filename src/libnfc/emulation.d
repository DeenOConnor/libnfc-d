module libnfc.emulation;


public import libnfc.nfc;
public import core.sys.posix.sys.types;


struct nfc_emulator {
    nfc_target *target;
    nfc_emulation_state_machine *state_machine;
    void *user_data;
}

struct nfc_emulation_state_machine {
    int function (nfc_emulator *emulator, const ubyte *data_in, const size_t data_in_len, ubyte *data_out, const size_t data_out_len) io;
    void *data;
}

version (Posix) {
    extern (C) int nfc_emulate_target(nfc_device *pnd, nfc_emulator *emulator, const int timeout);
}
version (Windows) {
    extern (Windows) int nfc_emulate_target(nfc_device *pnd, nfc_emulator *emulator, const int timeout);
}
