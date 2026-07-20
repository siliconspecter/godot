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

# Fix the compatability renderer discard the G and B components of non-float custom colors.
GIT_MERGE_AUTOEDIT=no git merge siliconspecter/fix/compatability-non-float-custom-attributes || exit 1

# Add support for webcams on Windows.
git remote add shiena https://github.com/shiena/godot
git fetch shiena || exit 1
GIT_MERGE_AUTOEDIT=no git merge shiena/feature/support-windows-camera || exit 1

# Add a script method so that we can automatically bake lighting.
git remote add vsekai https://github.com/V-Sekai/godot
git fetch vsekai || exit 1
GIT_MERGE_AUTOEDIT=no git merge vsekai/expose_bake_lightmap || exit 1

# Add support for cull masks in LightmapGI.
git remote add oblepikha https://github.com/oblepikha/godot
git fetch oblepikha || exit 1
GIT_MERGE_AUTOEDIT=no git merge oblepikha/lightmapgi-cull-mask || exit 1

git remote add vsekai https://github.com/V-Sekai/godot
git fetch vsekai || exit 1
GIT_MERGE_AUTOEDIT=no git merge vsekai/expose_bake_lightmap || exit 1

# Build the editor.
scons || exit 1

# Build templates needed to export.
scons target=template_release || exit 1

# Copy the build templates to where the editor can find them.
mkdir -p ~/.local/share/godot/export_templates/4.8.dev
cp bin/godot.linuxbsd.template_release.x86_64 ~/.local/share/godot/export_templates/4.8.dev/linux_release_x86_64 || exit 1
cp bin/godot.linuxbsd.template_release.x86_64.console ~/.local/share/godot/export_templates/4.8.dev/linux_release_x86_64_console || exit 1

# Undo all changes so if we need to make more script changes we don't have the commits we just merged.
git reset --hard siliconspecter/customizations || exit 1
