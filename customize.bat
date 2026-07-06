@REM Don't interrupt the script to ask for comments.
set GIT_MERGE_AUTOEDIT=no

@REM Delete all local changes.
git remote add siliconspecter https://github.com/siliconspecter/godot
git fetch siliconspecter || exit 1
git reset --hard siliconspecter/customizations || exit 1

@REM Apply latest updates.
git remote add godotengine https://github.com/godotengine/godot
git fetch godotengine || exit 1
git merge godotengine/master || exit 1

@REM Add support for webcams on Windows.
git remote add shiena https://github.com/shiena/godot
git fetch shiena || exit 1
git merge shiena/feature/support-windows-camera || exit 1

@REM Add a script method so that we can automatically bake lighting.
git remote add vsekai https://github.com/V-Sekai/godot
git fetch vsekai || exit 1
git merge vsekai/expose_bake_lightmap || exit 1

@REM Build the editor.
scons || exit 1

@REM Build templates needed to export.
scons target=template_release || exit 1

@REM Copy the build templates to where the editor can find them.
cp bin/godot.windows.template_release.x86_64.exe %APPDATA%/Godot/export_templates/4.8.dev/windows_release_x86_64.exe || exit 1
cp bin/godot.windows.template_release.x86_64.console.exe %APPDATA%/Godot/export_templates/4.8.dev/windows_release_x86_64_console.exe || exit 1
