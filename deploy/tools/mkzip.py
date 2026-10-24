import os, zipfile

SRC = "workspace/warpstorm/deploy/plugin/warpstorm-setup"
OUT = "workspace/warpstorm/deploy/plugin/warpstorm-setup.zip"

def main(input):
    if os.path.exists(OUT):
        os.remove(OUT)
    with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
        for fn in sorted(os.listdir(SRC)):
            z.write(os.path.join(SRC, fn), "warpstorm-setup/" + fn)
    with zipfile.ZipFile(OUT) as z:
        names = z.namelist()
        bad = z.testzip()
        php = z.read("warpstorm-setup/warpstorm-setup.php").decode("utf-8")[:60]
    return {"files": names, "testzip": bad, "php_head": php, "bytes": os.path.getsize(OUT)}
