module examples.list;


import std.stdio;
import std.string;
import std.conv;
import libnfc.nfc;
import core.stdc.stdlib;
import core.sys.posix.stdlib;
import core.sys.linux.err;


enum MAX_DEVICE_COUNT = 16;
enum MAX_TARGET_COUNT = 16;

static nfc_device *pnd;

static void print_usage(string progname) {
    writefln("usage: %s [-v] [-t X]\n", progname);
    writeln("  -v\t verbose display
-t X\t poll only for types according to bitfield X:
\t   1: ISO14443A
\t   2: Felica (212 kbps)
\t   4: Felica (424 kbps)
\t   8: ISO14443B
\t  16: ISO14443B'
\t  32: ISO14443B-2 ST SRx
\t  64: ISO14443B-2 ASK CTx
\t 128: ISO14443B iClass
\t 256: ISO14443A-3 Jewel
\t 512: ISO14443A-2 NFC Barcode
\tSo 1023 (default) polls for all types.
\tNote that if 16, 32, 64 or 128 then 8 is selected too.\n");
}

void print_nfc_target(const nfc_target *pnt, bool verbose) {
    char *s;
    str_nfc_target(&s, pnt, verbose);
    writeln(fromStringz(s));
    //nfc_free(s);
}

void main(string[] args) {
    size_t  i;
    bool verbose = false;
    int res = 0;
    int mask = 0x3ff;
    int arg;

    nfc_context *context;
    nfc_init(&context);
    if (context is null) {
        warnx("Unable to init libnfc (malloc)");
        exit(EXIT_FAILURE);
    }

    for (int j = 1; j < args.length; j++) {
        if (args[j] == "-h") {
            print_usage(args[0]);
            exit(EXIT_SUCCESS);
        } else if (args[j] == "-v") {
            verbose = true;
        } else if (args[j] == "-t" && (j + 1 < args.length)) {
            j++;
            mask = to!int(args[j]);
            if ((mask < 1) || (mask > 0x3ff)) {
                warnx(format!"%d is invalid value for type bitfield."(mask).ptr);
                print_usage(args[0]);
                exit(EXIT_FAILURE);
            }
            if (mask & 0xf0) {
                mask |= 0x08;
            }
        } else {
            warnx(format!"%s is not supported option."(args[j]).ptr);
            print_usage(args[0]);
            exit(EXIT_FAILURE);
        }
    }

    if (verbose) {
        auto acLibnfcVersion = nfc_version();
        writefln("%s uses libnfc %s\n", args[0], fromStringz(acLibnfcVersion));
    }

    nfc_connstring[MAX_DEVICE_COUNT] connstrings = void;
    size_t szDeviceFound = nfc_list_devices(context, connstrings.ptr, MAX_DEVICE_COUNT);

    if (szDeviceFound == 0) {
        printf("No NFC device found.\n");
    }

    for (i = 0; i < szDeviceFound; i++) {
        nfc_target[MAX_TARGET_COUNT] ant;
        pnd = nfc_open(context, connstrings[i].ptr);

        if (pnd is null) {
            warnx(format!"Unable to open NFC device: %s"(connstrings[i]).ptr);
            continue;
        }
        if (nfc_initiator_init(pnd) < 0) {
            nfc_perror(pnd, "nfc_initiator_init");
            nfc_exit(context);
            exit(EXIT_FAILURE);
        }

        writefln("NFC device: %s opened", fromStringz(nfc_device_get_name(pnd)));

        nfc_modulation nm;

        if (mask & 0x1) {
            nm.nmt = nfc_modulation_type.NMT_ISO14443A;
            nm.nbr = nfc_baud_rate.NBR_106;
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d ISO14443A passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x02) {
            nm.nmt = nfc_modulation_type.NMT_FELICA;
            nm.nbr = nfc_baud_rate.NBR_212;
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d Felica (212 kbps) passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x04) {
            nm.nmt = nfc_modulation_type.NMT_FELICA;
            nm.nbr = nfc_baud_rate.NBR_424;
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d Felica (424 kbps) passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x08) {
            nm.nmt = nfc_modulation_type.NMT_ISO14443B;
            nm.nbr = nfc_baud_rate.NBR_106;
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d ISO14443B passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x10) {
            nm.nmt = nfc_modulation_type.NMT_ISO14443BI;
            nm.nbr = nfc_baud_rate.NBR_106;
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d ISO14443B' passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x20) {
            nm.nmt = nfc_modulation_type.NMT_ISO14443B2SR;
            nm.nbr = nfc_baud_rate.NBR_106;
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d ISO14443B-2 ST SRx passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x40) {
            nm.nmt = nfc_modulation_type.NMT_ISO14443B2CT;
            nm.nbr = nfc_baud_rate.NBR_106;
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d ISO14443B-2 ASK CTx passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x80) {
            nm.nmt = nfc_modulation_type.NMT_ISO14443BICLASS;
            nm.nbr = nfc_baud_rate.NBR_106;
            // List ISO14443B iClass targets
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d ISO14443B iClass passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x100) {
            nm.nmt = nfc_modulation_type.NMT_JEWEL;
            nm.nbr = nfc_baud_rate.NBR_106;
            // List Jewel targets
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d ISO14443A-3 Jewel passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        if (mask & 0x200) {
            nm.nmt = nfc_modulation_type.NMT_BARCODE;
            nm.nbr = nfc_baud_rate.NBR_106;
            // List NFC Barcode targets
            if ((res = nfc_initiator_list_passive_targets(pnd, nm, ant.ptr, MAX_TARGET_COUNT)) >= 0) {
                int n;
                if (verbose || (res > 0)) {
                    writefln("%d ISO14443A-2 NFC Barcode passive target(s) found%s", res, (res == 0) ? ".\n" : ":");
                }
                for (n = 0; n < res; n++) {
                    print_nfc_target(&ant[n], verbose);
                    writeln();
                }
            }
        }

        nfc_close(pnd);
    }

    nfc_exit(context);
    exit(EXIT_SUCCESS);
}
