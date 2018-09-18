# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "FastJetBuilder"
version = v"0.1.0"

# Collection of sources required to build FastJetBuilder
sources = [
    "http://www.fastjet.fr/repo/fastjet-3.3.1.tar.gz" =>
    "76bfed9b87e5efdb93bcd0f7779e27427fbe38e05fe908c2a2e80a9ca0876c53",

]

# Bash recipe for building across all platforms
# FIXME
# because the libs don't have their dependencies specified properly, 
# we're hacking the libs together into a single one for the time being
script = raw"""
cd $WORKSPACE/srcdir/fastjet-3.3.1/
./configure --prefix=$prefix --host=$target
make
make install
cd ${prefix}/lib
if [ "$target" = "x86_64-linux-gnu" ]
then
	g++ -fPIC -shared -o libfastjetall.so -Wl,--whole-archive *.so -Wl,--no-whole-archive
elif [ "$target" = "x86_64-apple-darwin14" ]
then
	echo "$target is currently not supported"
fi
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64),
#    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libfastjetall", :libfastjetall),
#    LibraryProduct(prefix, "libsiscone", :libsiscone),
#    LibraryProduct(prefix, "libfastjet", :libfastjet),
#    LibraryProduct(prefix, "libfastjettools", :libfastjettools),
#    LibraryProduct(prefix, "libsiscone_spherical", :libsisconeSpherical),
#    LibraryProduct(prefix, "libfastjetplugins", :libfastjetplugins)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

