import base64, json, os

ROOT = "workspace/warpstorm/deploy"
FILES = [
    ("deploy.sh", "utf8"), ("README.md", "utf8"), ("RUNBOOK.md", "utf8"),
    ("css/grimdark-v1.css", "utf8"), ("css/grimdark-v1.1.css", "utf8"),
    ("plugin/warpstorm-setup/warpstorm-setup.php", "utf8"),
    ("plugin/warpstorm-setup/grimdark-v1.css", "utf8"),
    ("plugin/warpstorm-setup.zip", "b64"),
    ("tools/md2html.py", "utf8"), ("tools/mkzip.py", "utf8"),
    ("payloads/articles/best-warhammer-40k-army-for-beginners.json", "utf8"),
    ("payloads/articles/how-to-start-warhammer-40k.json", "utf8"),
    ("payloads/articles/best-warhammer-40k-starter-set.json", "utf8"),
    ("payloads/articles/space-marines-beginner-army-guide.json", "utf8"),
    ("payloads/articles/necrons-beginner-army-guide.json", "utf8"),
    ("payloads/pages/forside.json", "utf8"), ("payloads/pages/start-her.json", "utf8"),
    ("payloads/pages/om.json", "utf8"), ("payloads/pages/kontakt.json", "utf8"),
    ("payloads/pages/privatlivspolitik.json", "utf8"),
    ("payloads/pages/affiliate-disclosure.json", "utf8"),
]

def main(input):
    upserts = []
    for rel, mode in FILES:
        p = os.path.join(ROOT, rel)
        if not os.path.exists(p):
            return {"error": "missing", "path": p}
        data = open(p, "rb").read()
        if mode == "b64":
            upserts.append({"path": "deploy/" + rel, "content": base64.b64encode(data).decode(), "encoding": "base64"})
        else:
            upserts.append({"path": "deploy/" + rel, "content": data.decode("utf-8"), "encoding": "utf-8"})
    body = {
        "owner": "humle93", "repo": "warpstorm-site", "branch": "main",
        "message": "Grimdark Pakke v1: deploy-runbook, payloads (5 artikler + 6 sider), CSS v1.1, helper-plugin",
        "upserts": upserts,
    }
    out = os.path.join(ROOT, "lib/commit-body.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(body, f, ensure_ascii=False)
    return {"written": out, "files": len(upserts), "bytes": os.path.getsize(out)}
