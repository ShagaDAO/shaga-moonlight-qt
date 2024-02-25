#Build on MacOS

accordign to `generate-dmg.sh`:
> # This script requires create-dmg to be installed from https://github.com/sindresorhus/create-dmg
create-dmg should be installed using this command:
```
npm install --global create-dmg
```
!!!do not use homebrew for installing create-dmg!!!


To build dmg file you should get all submodules:
```
git submodule update --init --recursive
```
And run this command:
```
./scripts/generate-dmg.sh Debug
```
or
```
./scripts/generate-dmg.sh Release
```

Note that iroh_net_ffi.dylib is already pushed to repository 
in the directory `libs_shaga/mac/lib`.
Also note that libs_shaga is choosed, because libs is a submodule.
And modifying `libs` will need to fork additional repository.
So adding `libs_shaga` is easier.

Apple use "fat" binaries. A binaries that can run on both arm64 and x86_64 
If you want to rebuild iroh_net_ffi.dylib and want to to be a "fat" binary, 
please use this instructions:

##Generate iroh_net_ffi.dylib for MacOS

Run twice on Apple Silicon computer and on Intel computer:

```
git clone git@github.com:n0-computer/iroh-net-ffi.git

cargo build
cc -o main{,.c} -L target/debug -l iroh_net_ffi -lc -lm
```

rename result depending on Apple Silicon or Intel computer was used:
```
mv libiroh_net_ffi.dylib libiroh_net_ffi.x86_64.dylib
```
or
```
mv libiroh_net_ffi.dylib libiroh_net_ffi.arm64.dylib
```

Combine them in one "fat" binary using lipo tool:
```
lipo libiroh_net_ffi.x86_64.dylib libiroh_net_ffi.arm64.dylib -create -output libiroh_net_ffi.dylib 
```

Quick check:
```
lipo -archs libiroh_net_ffi.dylib
```
Output should contain both arm64 and x86_64 architectures:
```
arm64 x86_64
```

----

Unfortunatelly `cargo` unable to build "fat" binaries and is you want to rebuild iroh_net_ffi
during building of .dmg file. You should note that `cargo build` command will be able to 
produce binary for the current architecture only. So, if you run it on x86_64 the whole moonlight build
will be x86_64 only.
If you want to do this way, you can run:
```
./scripts/generate-dmg.sh Debug rebuild.iroh
```
