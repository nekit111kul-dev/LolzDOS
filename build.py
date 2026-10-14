#!/usr/bin/env python3
"""Builds disk_manifest.json (used by index.html to assemble the disk in the browser)
and lolzdos.jsdos (static fallback bundle with default settings)."""
import zipfile, os, json
root = os.path.dirname(os.path.abspath(__file__))
os.chdir(root)
files, dirs = [], []
for d, ds, fs in os.walk('disk_c'):
    for x in ds:
        dirs.append(os.path.relpath(os.path.join(d, x), 'disk_c').replace(os.sep, '/'))
    for f in fs:
        files.append(os.path.relpath(os.path.join(d, f), 'disk_c').replace(os.sep, '/'))
files.sort(); dirs.sort()
json.dump({'files': files, 'dirs': dirs}, open('disk_manifest.json', 'w'), indent=1)
with zipfile.ZipFile('lolzdos.jsdos', 'w', zipfile.ZIP_DEFLATED) as z:
    z.write('bundle/.jsdos/dosbox.conf', '.jsdos/dosbox.conf')
    for d in dirs: z.writestr(d + '/', '')
    for f in files: z.write('disk_c/' + f, f)
print('built disk_manifest.json, lolzdos.jsdos:', len(files), 'files')
