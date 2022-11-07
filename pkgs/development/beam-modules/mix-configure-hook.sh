# shellcheck shell=bash
# this hook will symlink all dependencies found in ERL_LIBS
# since Elixir 1.12.2 elixir does not look into ERL_LIBS for
# elixir depencencies anymore, so those have to be symlinked to the _build directory
mkdir -p _build/"$MIX_ENV"/lib
deps=()
while read -r -d ':' lib; do
    for dir in "$lib"/*; do
        # Strip version number for directory name if it exists, so naming of
        # all libs matches what mix's expectation.
        dest=$(basename "$dir" | cut -d '-' -f1)
        if ! [[ " ${deps[*]} " =~ " $dest " ]]; then
            build_dir="_build/$MIX_ENV/lib/$dest"
            ((MIX_DEBUG == 1)) && echo "Linking $dir to $build_dir"
            # Symlink libs to _build so that mix can find them when compiling.
            # This is what allows mix to compile the package without searching
            # for dependencies over the network.
            ln -s "$dir" "$build_dir"
            deps+=("$dest")
        fi
    done
done <<< "$ERL_LIBS:"
