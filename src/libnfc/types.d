module libnfc.types;


enum NFC_BUFSIZE_CONNSTRING = 1024;

struct nfc_context;

struct nfc_device;

struct nfc_driver;

alias nfc_connstring = char[1024];

enum nfc_property {
    NP_TIMEOUT_COMMAND,
    NP_TIMEOUT_ATR,
    NP_TIMEOUT_COM,
    NP_HANDLE_CRC,
    NP_HANDLE_PARITY,
    NP_ACTIVATE_FIELD,
    NP_ACTIVATE_CRYPTO1,
    NP_INFINITE_SELECT,
    NP_ACCEPT_INVALID_FRAMES,
    NP_ACCEPT_MULTIPLE_FRAMES,
    NP_AUTO_ISO14443_4,
    NP_EASY_FRAMING,
    NP_FORCE_ISO14443_A,
    NP_FORCE_ISO14443_B,
    NP_FORCE_SPEED_106,
}

enum nfc_dep_mode {
    NDM_UNDEFINED = 0,
    NDM_PASSIVE,
    NDM_ACTIVE,
}

struct nfc_dep_info {
    ubyte[10] abtNFCID3;
    ubyte btDID;
    ubyte btBS;
    ubyte btBR;
    ubyte btTO;
    ubyte btPP;
    ubyte[48] abtGB;
    size_t szGB;
    nfc_dep_mode ndm;
}

struct nfc_iso14443a_info {
    ubyte[2] abtAtqa;
    ubyte btSak;
    size_t szUidLen;
    ubyte[10] abtUid;
    size_t szAtsLen;
    ubyte[254] abtAts;
}

struct nfc_felica_info {
    size_t szLen;
    ubyte btResCode;
    ubyte[8] abtId;
    ubyte[8] abtPad;
    ubyte[2] abtSysCode;
}

struct nfc_iso14443b_info {
    ubyte[4] abtPupi;
    ubyte[4] abtApplicationData;
    ubyte[3] abtProtocolInfo;
    ubyte ui8CardIdentifier;
}

struct nfc_iso14443bi_info {
    ubyte[4] abtDIV;
    ubyte btVerLog;
    ubyte btConfig;
    size_t szAtrLen;
    ubyte[33] abtAtr;
}

struct nfc_iso14443biclass_info {
    ubyte[8] abtUID;
}

struct nfc_iso14443b2sr_info {
    ubyte[8] abtUID;
}

struct nfc_iso14443b2ct_info {
    ubyte[4] abtUID;
    ubyte btProdCode;
    ubyte btFabCode;
}

struct nfc_jewel_info {
    ubyte[2] btSensRes;
    ubyte[4] btId;
}

struct nfc_barcode_info {
    size_t szDataLen;
    ubyte[32] abtData;
}

union nfc_target_info {
    nfc_iso14443a_info nai;
    nfc_felica_info nfi;
    nfc_iso14443b_info nbi;
    nfc_iso14443bi_info nii;
    nfc_iso14443b2sr_info nsi;
    nfc_iso14443b2ct_info nci;
    nfc_jewel_info nji;
    nfc_dep_info ndi;
    nfc_barcode_info nti;
    nfc_iso14443biclass_info nhi;
}

enum nfc_baud_rate {
    NBR_UNDEFINED = 0,
    NBR_106,
    NBR_212,
    NBR_424,
    NBR_847,
}

enum nfc_modulation_type {
    NMT_ISO14443A = 1,
    NMT_JEWEL,
    NMT_ISO14443B,
    NMT_ISO14443BI,
    NMT_ISO14443B2SR,
    NMT_ISO14443B2CT,
    NMT_FELICA,
    NMT_DEP,
    NMT_BARCODE,
    NMT_ISO14443BICLASS,
    NMT_END_ENUM = NMT_ISO14443BICLASS,
}

enum nfc_mode {
    N_TARGET,
    N_INITIATOR,
}

struct nfc_modulation {
    nfc_modulation_type nmt;
    nfc_baud_rate nbr;
}

struct nfc_target {
    nfc_target_info nti;
    nfc_modulation nm;
}
