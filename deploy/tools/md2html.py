import json, os, re, glob

ART = "workspace/warpstorm/articles"
OUT = "workspace/warpstorm/deploy/payloads/articles"
BASE_UPLOAD = "/wp-content/uploads/"

CATS = {
    "01-best-warhammer-40k-army-for-beginners": ["Guides"],
    "02-how-to-start-warhammer-40k": ["Guides"],
    "03-best-warhammer-40k-starter-set": ["Guides"],
    "04-space-marines-beginner-army-guide": ["Hære"],
    "05-necrons-beginner-army-guide": ["Hære"],
}

def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

def inline(s):
    s = esc(s)
    s = re.sub(r'!\[([^\]]*)\]\(([^)\s]+)\)',
               lambda m: '<figure class="wp-block-image"><img src="%s%s" alt="%s"/></figure>'
                         % (BASE_UPLOAD, m.group(2), m.group(1)), s)
    s = re.sub(r'\[([^\]]+)\]\(([^)\s]+)\)',
               lambda m: '<a href="%s">%s</a>' % (m.group(2), m.group(1)), s)
    s = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', s)
    s = re.sub(r'(?<!\*)\*([^*]+?)\*(?!\*)', r'<em>\1</em>', s)
    return s

def cell(s):
    return inline(s.strip())

def convert(text):
    lines = text.split("\n")
    out, title, excerpt_src = [], "", ""
    i, n = 0, len(lines)
    while i < n:
        st = lines[i].strip()
        if not st:
            i += 1; continue
        if st.startswith("# ") and not title:
            title = st[2:].strip(); i += 1; continue
        if st.startswith("### "):
            out.append("<h3>%s</h3>" % inline(st[4:])); i += 1; continue
        if st.startswith("## "):
            out.append("<h2>%s</h2>" % inline(st[3:])); i += 1; continue
        if st == "---":
            out.append('<hr class="wp-block-separator"/>'); i += 1; continue
        if st.startswith(">"):
            buf = []
            while i < n and lines[i].strip().startswith(">"):
                buf.append(lines[i].strip().lstrip(">").strip()); i += 1
            out.append('<blockquote class="grim-quote"><p>%s</p></blockquote>' % inline(" ".join(buf)))
            continue
        if st.startswith("|"):
            rows = []
            while i < n and lines[i].strip().startswith("|"):
                rows.append(lines[i].strip()); i += 1
            body = [r for k, r in enumerate(rows) if k != 1]
            if not body: continue
            ncols = len(body[0].strip("|").split("|"))
            t = ['<table class="grim-table">']
            for k, r in enumerate(body):
                cells = [cell(c) for c in r.strip("|").split("|")]
                if len(cells) < ncols: cells += [""] * (ncols - len(cells))
                tag = "th" if k == 0 else "td"
                t.append("<tr>" + "".join("<%s>%s</%s>" % (tag, c, tag) for c in cells[:ncols]) + "</tr>")
            t.append("</table>")
            out.append('<figure class="grim-table-wrap">%s</figure>' % "".join(t)); continue
        if st.startswith("- "):
            buf = []
            while i < n and lines[i].strip().startswith("- "):
                buf.append("<li>%s</li>" % inline(lines[i].strip()[2:])); i += 1
            out.append('<ul class="grim-list">%s</ul>' % "".join(buf)); continue
        buf = [st]; i += 1
        while i < n and lines[i].strip() and not re.match(r'^(#|\||- |>|!\[|---$)', lines[i].strip()):
            buf.append(lines[i].strip()); i += 1
        p = inline(" ".join(buf))
        if "Short answer:" in p and not excerpt_src:
            excerpt_src = re.sub(r'<[^>]+>', '', p).replace("Short answer:", "").strip()
        if p.startswith("<figure") and p.endswith("</figure>"):
            out.append(p)
        else:
            out.append("<p>%s</p>" % p)
    ex = excerpt_src or ""
    if len(ex) > 290:
        ex = ex[:290].rsplit(" ", 1)[0] + " …"
    return title, "\n".join(out), ex

def main(input):
    written = []
    for path in sorted(glob.glob(os.path.join(ART, "0[1-5]*.md"))):
        base = os.path.basename(path)[:-3]
        slug = re.sub(r'^\d+-', '', base)
        text = open(path, encoding="utf-8").read()
        title, html, ex = convert(text)
        payload = {
            "title": title,
            "slug": slug,
            "status": "draft",
            "content": html,
            "excerpt": ex,
            "categories": CATS.get(base, ["Guides"]),
        }
        out = os.path.join(OUT, slug + ".json")
        with open(out, "w", encoding="utf-8") as f:
            json.dump(payload, f, ensure_ascii=False, indent=1)
        written.append({"file": out, "title": title, "html_bytes": len(html)})
    return {"written": written}
