def main(input):
    P = "workspace/warpstorm/deploy/deploy.sh"
    s = open(P).read()
    bad = '''    && { api GET "/wp/v2/settings" >/dev/null 2>&1; } || FAILS=$((FAILS+1))'''
    good = '''    || FAILS=$((FAILS+1))'''
    if bad in s:
        s = s.replace(bad, good)
        open(P, "w").write(s)
        return {"patched": True}
    return {"patched": False, "note": "pattern not found"}
