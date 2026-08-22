# Delete all local changes.
git remote add siliconspecter https://github.com/siliconspecter/godot
git fetch siliconspecter || exit 1
git reset --hard siliconspecter/customizations || exit 1

# Apply latest updates.
git remote add godotengine https://github.com/godotengine/godot
git fetch godotengine || exit 1
GIT_MERGE_AUTOEDIT=no git merge godotengine/master || exit 1

# Add some missing LightmapGIData methods.
GIT_MERGE_AUTOEDIT=no git merge siliconspecter/expose-lightmap-gi-data-functions-to-gdscript || exit 1

# Add multiple features which conflict.
GIT_MERGE_AUTOEDIT=no git merge siliconspecter/lightmap-gi-features || exit 1

# Fix depth-draw-never being broken.
GIT_MERGE_AUTOEDIT=no git merge siliconspecter/test-depth-draw-never-fix || exit 1

# Add support for webcams on Windows.
git remote add shiena https://github.com/shiena/godot
git fetch shiena || exit 1
GIT_MERGE_AUTOEDIT=no git merge shiena/feature/support-windows-camera || exit 1

# Add support for decals.
git remote add bastiaanolij https://github.com/bastiaanolij/godot
git fetch bastiaanolij || exit 1
GIT_MERGE_AUTOEDIT=no git merge bastiaanolij/add_compatibility_decals || exit 1

# Fix a lot of errors in the console.
git remote add cixil https://github.com/cixil/godot
git fetch cixil || exit 1
GIT_MERGE_AUTOEDIT=no git merge cixil/avoid-saving-connections-twice || exit 1

# Build the editor.
scons || exit 1

# Build templates needed to export.
scons target=template_release lto=full build_profile="../carpathia/engine_compilation_profile.gdbuild" || exit 1

# Copy the build templates to where the editor can find them.
mkdir -p ~/.local/share/godot/export_templates/4.8.dev
cp bin/godot.linuxbsd.template_release.x86_64 ~/.local/share/godot/export_templates/4.8.dev/linux_release_x86_64 || exit 1
cp bin/godot.linuxbsd.template_release.x86_64.console ~/.local/share/godot/export_templates/4.8.dev/linux_release_x86_64_console || exit 1

# Undo all changes so if we need to make more script changes we don't have the commits we just merged.
git reset --hard siliconspecter/customizations || exit 1
