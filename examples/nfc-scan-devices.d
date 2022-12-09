module examples.scan;


import std.stdio;
import std.string;
import libnfc.nfc;
import core.stdc.stdlib;
import core.sys.posix.stdlib;
import core.sys.linux.err;


enum MAX_DEVICE_COUNT = 16;
enum MAX_TARGET_COUNT = 16;

static nfc_device *pnd;

static void print_usage(string[] args) {
    writefln("Usage: %s [OPTIONS]", args[0]);
    writeln("Options:
\t-h\tPrint this help message.
\t-v\tSet verbose display.
\t-i\tAllow intrusive scan.\n");
}

void main(string[] args) {
    size_t i;
    bool verbose = false;

    nfc_context *context;

    for (int j = 1; j < args.length; j++) {
        if (args[j] == "-h") {
            print_usage(args);
            exit(EXIT_SUCCESS);
        } else if (args[j] == "-v") {
            verbose = true;
        } else if (args[j] == "-i") {
            setenv("LIBNFC_INTRUSIVE_SCAN", "yes", 1);
        } else {
            warnx(format!"ERROR: %s is not supported option.\n"(args[j]).ptr);
            print_usage(args);
            exit(EXIT_FAILURE);
        }
    }

    nfc_init(&context);
    if (context is null) {
        warnx("Unable to init libnfc (malloc)\n");
        exit(EXIT_FAILURE);
    }

    auto acLibnfcVersion = nfc_version();
    writefln("%s uses libnfc %s", args[0], fromStringz(acLibnfcVersion));

    nfc_connstring[MAX_DEVICE_COUNT] connstrings = void;
    size_t szDeviceFound = nfc_list_devices(context, connstrings.ptr, MAX_DEVICE_COUNT);
    if (szDeviceFound == 0) {
        writefln("No NFC device found.");
        nfc_exit(context);
        exit(EXIT_FAILURE);
    }

    writefln("%d NFC device(s) found:", cast(int)szDeviceFound);
    char* strinfo;
    for (i = 0; i < szDeviceFound; i++) {
        auto connstring = connstrings[i];
        pnd = nfc_open(context, connstrings[i].ptr);
        if (pnd !is null) {
            writefln("- %s:\n    %s", fromStringz(nfc_device_get_name(pnd)), fromStringz(nfc_device_get_connstring(pnd)));
            if (verbose) {
                if (nfc_device_get_information_about(pnd, &strinfo) >= 0) {
                    writefln("%s", fromStringz(strinfo));
                    //nfc_free(strinfo.ptr);
                }
            }
            nfc_close(pnd);
        } else {
            writefln("nfc_open failed for %s", connstrings[i]);
        }
    }
    nfc_exit(context);
    exit(EXIT_SUCCESS);
}
