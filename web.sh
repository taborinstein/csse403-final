nim c \
    --mm:refc \
    --cc:clang \
    --cpu:i386 \
    --clang.linkerexe:/usr/lib/emscripten/emcc \
    --clang.exe:/usr/lib/emscripten/emcc \
    '--passC: \
        "-Dsyscall(a,b,c,d)=0" \
        -s WASM=1 \
        -Iemscripten \
        -pthread -s PTHREAD_POOL_SIZE=4 ' \
    "--passL: \
        -s USE_SDL=2 \
       -s USE_SDL_GFX=2 \
       -s USE_SDL_IMAGE=2 \
       -s USE_SDL_TTF=2 \
       -s USE_SDL_MIXER=2 \
        -s WASM=1 -Lemscripten -o index.html" \
    --dynlibOverride:"SDL2" \
    --dynlibOverride:"SDL2_gfx" \
    --dynlibOverride:"SDL2_image" \
    --dynlibOverride:"SDL2_mixer" \
    --dynlibOverride:"SDL2_ttf" \
    --dynlibOverride:"SDL2_net" \
    src/maze.nim 


#  ./web_objs/libSDL2_gfx.o \
#     ./web_objs/libSDL2_image-png.o \
#     ./web_objs/libSDL2_ttf.o \
