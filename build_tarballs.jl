# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "FastJetBuilder"
version = v"0.1.0"

# Collection of sources required to build FastJetBuilder
sources = [
    "http://fastjet.fr/repository/snapshots/fastjet-3.3.2-devel-20180927-rev4379.tar.gz" =>
    "6e8aca6d15a647fcc4a2bda6144a40f5b5ea203a459a5893263d1978b87c6402",

]

# Bash recipe for building across all platforms
# FIXME
# because the libs don't have their dependencies specified properly, 
# we're hacking the libs together into a single one for the time being
script = raw"""
cd $WORKSPACE/srcdir/fastjet-*/
./configure --prefix=$prefix --host=$target
make
make install
cd ${prefix}/lib
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)),
]

#platforms = expand_gcc_versions(platforms)

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libsiscone", :libsiscone),
    LibraryProduct(prefix, "libfastjet", :libfastjet),
    LibraryProduct(prefix, "libfastjettools", :libfastjettools),
    LibraryProduct(prefix, "libsiscone_spherical", :libsisconeSpherical),
    LibraryProduct(prefix, "libfastjetplugins", :libfastjetplugins)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

