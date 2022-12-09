# libnfc-d
D bindings to [libnfc](https://github.com/nfc-tools/libnfc)

# Usage
Use with `import libnfc.nfc;`

Compile with the contents of src and link with libnfc, for example:

`dmd src/* examples/nfc-list.d -L/lib/x86_64-linux-gnu/libnfc.so.6 -ofnfc-list`

With `dub` add libnfc folder to any source path

# Examples
Translated manually (and most likely poorly) from original C code to D. Original nfc-utils.h and nfc-utils.c were ditched to keep each example fully contained in its own file. Any help with adding more examples, including translating original ones, is welcome.
