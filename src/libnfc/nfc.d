module libnfc.nfc;


public import libnfc.types;


version (Posix) {
    extern (C) void nfc_init(nfc_context **context);
    extern (C) void nfc_exit(nfc_context *context);
    extern (C) int nfc_register_driver(const nfc_driver *driver);

    extern (C) nfc_device *nfc_open(nfc_context *context, const char* connstring);
    extern (C) void nfc_close(nfc_device *pnd);
    extern (C) int nfc_abort_command(nfc_device *pnd);
    extern (C) size_t nfc_list_devices(nfc_context *context, nfc_connstring* connstrings, size_t connstrings_len);
    extern (C) int nfc_idle(nfc_device *pnd);

    extern (C) int nfc_initiator_init(nfc_device *pnd);
    extern (C) int nfc_initiator_init_secure_element(nfc_device *pnd);
    extern (C) int nfc_initiator_select_passive_target(nfc_device *pnd, const nfc_modulation nm, const ubyte *pbtInitData, const size_t szInitData, nfc_target *pnt);
    extern (C) int nfc_initiator_list_passive_targets(nfc_device *pnd, const nfc_modulation nm, nfc_target* ant, const size_t szTargets);
    extern (C) int nfc_initiator_poll_target(nfc_device *pnd, const nfc_modulation *pnmTargetTypes, const size_t szTargetTypes, const ubyte uiPollNr, const ubyte uiPeriod, nfc_target *pnt);
    extern (C) int nfc_initiator_select_dep_target(nfc_device *pnd, const nfc_dep_mode ndm, const nfc_baud_rate nbr, const nfc_dep_info *pndiInitiator, nfc_target *pnt, const int timeout);
    extern (C) int nfc_initiator_poll_dep_target(nfc_device *pnd, const nfc_dep_mode ndm, const nfc_baud_rate nbr, const nfc_dep_info *pndiInitiator, nfc_target *pnt, const int timeout);
    extern (C) int nfc_initiator_deselect_target(nfc_device *pnd);
    extern (C) int nfc_initiator_transceive_bytes(nfc_device *pnd, const ubyte *pbtTx, const size_t szTx, ubyte *pbtRx, const size_t szRx, int timeout);
    extern (C) int nfc_initiator_transceive_bits(nfc_device *pnd, const ubyte *pbtTx, const size_t szTxBits, const ubyte *pbtTxPar, ubyte *pbtRx, const size_t szRx, ubyte *pbtRxPar);
    extern (C) int nfc_initiator_transceive_bytes_timed(nfc_device *pnd, const ubyte *pbtTx, const size_t szTx, ubyte *pbtRx, const size_t szRx, uint *cycles);
    extern (C) int nfc_initiator_transceive_bits_timed(nfc_device *pnd, const ubyte *pbtTx, const size_t szTxBits, const ubyte *pbtTxPar, ubyte *pbtRx, const size_t szRx, ubyte *pbtRxPar, uint *cycles);
    extern (C) int nfc_initiator_target_is_present(nfc_device *pnd, const nfc_target *pnt);

    extern (C) int nfc_target_init(nfc_device *pnd, nfc_target *pnt, ubyte *pbtRx, const size_t szRx, int timeout);
    extern (C) int nfc_target_send_bytes(nfc_device *pnd, const ubyte *pbtTx, const size_t szTx, int timeout);
    extern (C) int nfc_target_receive_bytes(nfc_device *pnd, ubyte *pbtRx, const size_t szRx, int timeout);
    extern (C) int nfc_target_send_bits(nfc_device *pnd, const ubyte *pbtTx, const size_t szTxBits, const ubyte *pbtTxPar);
    extern (C) int nfc_target_receive_bits(nfc_device *pnd, ubyte *pbtRx, const size_t szRx, ubyte *pbtRxPar);

    extern (C) const(char)* nfc_strerror(const nfc_device *pnd);
    extern (C) int nfc_strerror_r(const nfc_device *pnd, char *buf, size_t buflen);
    extern (C) void nfc_perror(const nfc_device *pnd, const char *s);
    extern (C) int nfc_device_get_last_error(const nfc_device *pnd);

    extern (C) const(char)* nfc_device_get_name(nfc_device *pnd);
    extern (C) const(char)* nfc_device_get_connstring(nfc_device *pnd);
    extern (C) int nfc_device_get_supported_modulation(nfc_device *pnd, const nfc_mode mode,  const(nfc_modulation_type)** supported_mt);
    extern (C) int nfc_device_get_supported_baud_rate(nfc_device *pnd, const nfc_modulation_type nmt, const(nfc_baud_rate)** supported_br);
    extern (C) int nfc_device_get_supported_baud_rate_target_mode(nfc_device *pnd, const nfc_modulation_type nmt, const(nfc_baud_rate)** supported_br);

    extern (C) int nfc_device_set_property_int(nfc_device *pnd, const nfc_property property, const int value);
    extern (C) int nfc_device_set_property_bool(nfc_device *pnd, const nfc_property property, const bool bEnable);

    extern (C) void iso14443a_crc(ubyte *pbtData, size_t szLen, ubyte *pbtCrc);
    extern (C) void iso14443a_crc_append(ubyte *pbtData, size_t szLen);
    extern (C) void iso14443b_crc(ubyte *pbtData, size_t szLen, ubyte *pbtCrc);
    extern (C) void iso14443b_crc_append(ubyte *pbtData, size_t szLen);
    extern (C) ubyte *iso14443a_locate_historical_bytes(ubyte *pbtAts, size_t szAts, size_t *pszTk);

    extern (C) void nfc_free(void *p);
    extern (C) const(char)* nfc_version();
    extern (C) int nfc_device_get_information_about(nfc_device *pnd, char **buf);

    extern (C) const(char)* str_nfc_modulation_type(const nfc_modulation_type nmt);
    extern (C) const(char)* str_nfc_baud_rate(const nfc_baud_rate nbr);
    extern (C) int str_nfc_target(char **buf, const nfc_target *pnt, bool verbose);
}

version (Windows) {
    extern (Windows) void nfc_init(nfc_context **context);
    extern (Windows) void nfc_exit(nfc_context *context);
    extern (Windows) int nfc_register_driver(const nfc_driver *driver);

    extern (Windows) nfc_device *nfc_open(nfc_context *context, const char* connstring);
    extern (Windows) void nfc_close(nfc_device *pnd);
    extern (Windows) int nfc_abort_command(nfc_device *pnd);
    extern (Windows) size_t nfc_list_devices(nfc_context *context, nfc_connstring* connstrings, size_t connstrings_len);
    extern (Windows) int nfc_idle(nfc_device *pnd);

    extern (Windows) int nfc_initiator_init(nfc_device *pnd);
    extern (Windows) int nfc_initiator_init_secure_element(nfc_device *pnd);
    extern (Windows) int nfc_initiator_select_passive_target(nfc_device *pnd, const nfc_modulation nm, const ubyte *pbtInitData, const size_t szInitData, nfc_target *pnt);
    extern (Windows) int nfc_initiator_list_passive_targets(nfc_device *pnd, const nfc_modulation nm, nfc_target* ant, const size_t szTargets);
    extern (Windows) int nfc_initiator_poll_target(nfc_device *pnd, const nfc_modulation *pnmTargetTypes, const size_t szTargetTypes, const ubyte uiPollNr, const ubyte uiPeriod, nfc_target *pnt);
    extern (Windows) int nfc_initiator_select_dep_target(nfc_device *pnd, const nfc_dep_mode ndm, const nfc_baud_rate nbr, const nfc_dep_info *pndiInitiator, nfc_target *pnt, const int timeout);
    extern (Windows) int nfc_initiator_poll_dep_target(nfc_device *pnd, const nfc_dep_mode ndm, const nfc_baud_rate nbr, const nfc_dep_info *pndiInitiator, nfc_target *pnt, const int timeout);
    extern (Windows) int nfc_initiator_deselect_target(nfc_device *pnd);
    extern (Windows) int nfc_initiator_transceive_bytes(nfc_device *pnd, const ubyte *pbtTx, const size_t szTx, ubyte *pbtRx, const size_t szRx, int timeout);
    extern (Windows) int nfc_initiator_transceive_bits(nfc_device *pnd, const ubyte *pbtTx, const size_t szTxBits, const ubyte *pbtTxPar, ubyte *pbtRx, const size_t szRx, ubyte *pbtRxPar);
    extern (Windows) int nfc_initiator_transceive_bytes_timed(nfc_device *pnd, const ubyte *pbtTx, const size_t szTx, ubyte *pbtRx, const size_t szRx, uint *cycles);
    extern (Windows) int nfc_initiator_transceive_bits_timed(nfc_device *pnd, const ubyte *pbtTx, const size_t szTxBits, const ubyte *pbtTxPar, ubyte *pbtRx, const size_t szRx, ubyte *pbtRxPar, uint *cycles);
    extern (Windows) int nfc_initiator_target_is_present(nfc_device *pnd, const nfc_target *pnt);

    extern (Windows) int nfc_target_init(nfc_device *pnd, nfc_target *pnt, ubyte *pbtRx, const size_t szRx, int timeout);
    extern (Windows) int nfc_target_send_bytes(nfc_device *pnd, const ubyte *pbtTx, const size_t szTx, int timeout);
    extern (Windows) int nfc_target_receive_bytes(nfc_device *pnd, ubyte *pbtRx, const size_t szRx, int timeout);
    extern (Windows) int nfc_target_send_bits(nfc_device *pnd, const ubyte *pbtTx, const size_t szTxBits, const ubyte *pbtTxPar);
    extern (Windows) int nfc_target_receive_bits(nfc_device *pnd, ubyte *pbtRx, const size_t szRx, ubyte *pbtRxPar);

    extern (Windows) const(char)* nfc_strerror(const nfc_device *pnd);
    extern (Windows) int nfc_strerror_r(const nfc_device *pnd, char *buf, size_t buflen);
    extern (Windows) void nfc_perror(const nfc_device *pnd, const char *s);
    extern (Windows) int nfc_device_get_last_error(const nfc_device *pnd);

    extern (Windows) const(char)* nfc_device_get_name(nfc_device *pnd);
    extern (Windows) const(char)* nfc_device_get_connstring(nfc_device *pnd);
    extern (Windows) int nfc_device_get_supported_modulation(nfc_device *pnd, const nfc_mode mode,  const(nfc_modulation_type)** supported_mt);
    extern (Windows) int nfc_device_get_supported_baud_rate(nfc_device *pnd, const nfc_modulation_type nmt, const(nfc_baud_rate)** supported_br);
    extern (Windows) int nfc_device_get_supported_baud_rate_target_mode(nfc_device *pnd, const nfc_modulation_type nmt, const(nfc_baud_rate)** supported_br);

    extern (Windows) int nfc_device_set_property_int(nfc_device *pnd, const nfc_property property, const int value);
    extern (Windows) int nfc_device_set_property_bool(nfc_device *pnd, const nfc_property property, const bool bEnable);

    extern (Windows) void iso14443a_crc(ubyte *pbtData, size_t szLen, ubyte *pbtCrc);
    extern (Windows) void iso14443a_crc_append(ubyte *pbtData, size_t szLen);
    extern (Windows) void iso14443b_crc(ubyte *pbtData, size_t szLen, ubyte *pbtCrc);
    extern (Windows) void iso14443b_crc_append(ubyte *pbtData, size_t szLen);
    extern (Windows) ubyte *iso14443a_locate_historical_bytes(ubyte *pbtAts, size_t szAts, size_t *pszTk);

    extern (Windows) void nfc_free(void *p);
    extern (Windows) const(char)* nfc_version();
    extern (Windows) int nfc_device_get_information_about(nfc_device *pnd, char **buf);

    extern (Windows) const(char)* str_nfc_modulation_type(const nfc_modulation_type nmt);
    extern (Windows) const(char)* str_nfc_baud_rate(const nfc_baud_rate nbr);
    extern (Windows) int str_nfc_target(char **buf, const nfc_target *pnt, bool verbose);
}

enum NFC_SUCCESS = 0;

enum NFC_EIO = -1;

enum NFC_EINVARG = -2;

enum NFC_EDEVNOTSUPP = -3;

enum NFC_ENOTSUCHDEV = -4;

enum NFC_EOVFLOW = -5;

enum NFC_ETIMEOUT = -6;

enum NFC_EOPABORTED = -7;

enum NFC_ENOTIMPL = -8;

enum NFC_ETGRELEASED = -10;

enum NFC_ERFTRANS = -20;

enum NFC_EMFCAUTHFAIL = -30;

enum NFC_ESOFT = -80;

enum NFC_ECHIP = -90;
