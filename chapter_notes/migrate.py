import os, re, pathlib, shlex

for file_path in pathlib.Path(".").glob("*.tex"):
    tmp_path = file_path.with_name("tmp_" + file_path.name)
    qmd_path = file_path.with_suffix(".qmd")
    if qmd_path.exists(): continue
    try:
        with open(file_path, "r") as fd:
            content = fd.read()
    except:
        print(f"ERROR READING {file_path}")
        continue
    with open(tmp_path, "w") as fd:
        fd.write(content.replace("{list}", "{itemize}").replace("Invchi2", "Invchitwo"))
    os.system(f"pandoc {tmp_path} -t markdown --lua-filter=migrate.lua -o {qmd_path}")
    os.system(f"rm {tmp_path}")
    with open(qmd_path, "r") as fd:
        content = fd.read()
    with open(qmd_path, "w") as fd:
        fd.write(re.sub("""^\s*(.+)\s*\*\*Aki Vehtari\*\*""", r"""---
title: \1
---""", content))
