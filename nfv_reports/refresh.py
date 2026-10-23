"""Refresh the read-only LiteBox NFV dashboard from published GitHub evidence."""

import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
import html
import json
from pathlib import Path
import re
import subprocess


REPOSITORY = "shuvendu-lahiri/litebox"
WEB = f"https://github.com/{REPOSITORY}"
DIRECTORY = Path(__file__).resolve().parent
STATUSES = ("refuted", "verified", "resources exhausted", "type-check/audit failure")
COUNTS = re.compile(
    r"^refuted: (\d+) \u00b7 verified: (\d+) \u00b7 "
    r"resources exhausted: (\d+) \u00b7 type-check/audit failure: (\d+)$", re.M)


def prose(body):
    result, fence = [], None
    for line in body.splitlines():
        match = re.match(r"^\s*(`{3,}|~{3,})(.*)$", line)
        if match:
            marker, suffix = match.groups()
            if fence is None:
                fence = marker
            elif marker[0] == fence[0] and len(marker) >= len(fence) and not suffix.strip():
                fence = None
            continue
        if fence is None:
            result.append(line)
    return "\n".join(result)


def plain(value):
    return re.sub(r"\\([^\w\s]|_)", r"\1", html.unescape(value))


def paragraph(block, label):
    match = re.search(rf"^\*\*{label}:\*\* (.*)$", block, re.M)
    return plain(match[1]) if match else None


def parse_report(comment):
    body = prose(comment["body"])
    heading = re.search(r"^# NFV: (\d+) refuted, (\d+) verified in PR #(\d+)$", body, re.M)
    if not heading:
        return None
    number = int(comment["issue_url"].rsplit("/", 1)[1])
    if int(heading[3]) != number:
        raise ValueError(f"Comment {comment['id']}: PR identity mismatch")
    if comment["user"]["login"] not in (REPOSITORY.split("/")[0], "github-actions[bot]"):
        raise ValueError(f"Comment {comment['id']}: unrecognized NFV publisher")
    summaries = COUNTS.findall(body)
    if len(summaries) != 1:
        raise ValueError(f"Comment {comment['id']}: missing or ambiguous outcome summary")
    counts = dict(zip(STATUSES, map(int, summaries[0])))
    if (counts["refuted"], counts["verified"]) != (int(heading[1]), int(heading[2])):
        raise ValueError(f"Comment {comment['id']}: inconsistent heading")
    snapshot = re.search(r"^PR head `([0-9a-f]{12,40})`, base `([0-9a-f]{12,40})`", body, re.M)
    run = re.search(re.escape(WEB) + r"/actions/runs/(\d+)", body)
    if not snapshot or not run:
        raise ValueError(f"Comment {comment['id']}: missing source snapshot or workflow link")
    outcomes = Counter()
    refutations = []
    blocks = re.split(r"^### (P\d+)\s*$", body, flags=re.M)
    if len(set(blocks[1::2])) != len(blocks[1::2]):
        raise ValueError(f"Comment {comment['id']}: duplicate property identifiers")
    for index in range(1, len(blocks), 2):
        property_id, block = blocks[index:index + 2]
        statuses = re.findall(r"^\*\*Outcome: (.*?)\*\*$", block, re.M)
        if len(statuses) != 1 or statuses[0] not in STATUSES:
            raise ValueError(f"Comment {comment['id']}: invalid outcome for {property_id}")
        status = statuses[0]
        outcomes[status] += 1
        if status == "refuted":
            intended = re.search(r"^\*\*(?:Intended|Inferred) property:\*\* (.*?)\n\n",
                                 block, re.M | re.S)
            if not intended:
                raise ValueError(f"Comment {comment['id']}: missing refuted property")
            refutations.append({
                "property_id": property_id, "property": plain(intended[1]),
                "input": paragraph(block, "Input on which it fails"),
                "sketch": paragraph(block, "Sketch of the failure"),
            })
    if any(outcomes[status] != count for status, count in counts.items()):
        raise ValueError(f"Comment {comment['id']}: property outcomes disagree with summary")
    return {
        "comment_id": comment["id"], "url": f"{WEB}/pull/{number}#issuecomment-{comment['id']}",
        "published_at": comment["created_at"], "updated_at": comment["updated_at"],
        "body_sha256": hashlib.sha256(comment["body"].encode("utf-8")).hexdigest(),
        "source_sha_prefix": snapshot[1], "base_sha_prefix": snapshot[2],
        "run_id": int(run[1]), "run_url": f"{WEB}/actions/runs/{run[1]}",
        "counts": counts, "properties": sum(counts.values()), "refutations": refutations,
    }


def run_numbers(run, heads):
    numbers = [pr["number"] for pr in run["pull_requests"]
               if pr["url"].startswith(f"https://api.github.com/repos/{REPOSITORY}/pulls/")]
    if not numbers and (run.get("head_repository") or {}).get("full_name") == REPOSITORY:
        numbers = heads.get(run["head_branch"], [])
        if len(numbers) > 1:
            raise ValueError(f"Run {run['id']}: ambiguous PR branch association")
    return numbers


def build(pulls, comments, runs, generated_at):
    prs = {pr["number"]: pr for pr in pulls}
    if len(prs) != len(pulls):
        raise ValueError("Duplicate PR metadata")
    heads = {}
    for pr in pulls:
        heads.setdefault(pr["head"]["ref"], []).append(pr["number"])
    attempts, reports = {}, {}
    run_index = {run["id"]: run for run in runs}
    for run in runs:
        if run.get("conclusion") == "skipped":
            continue
        if type(run.get("run_attempt")) is not int or run["run_attempt"] < 1:
            raise ValueError(f"Run {run['id']}: missing or invalid workflow attempt")
        for number in run_numbers(run, heads):
            if number not in prs:
                raise ValueError(f"Missing metadata for attempted PR {number}")
            attempts.setdefault(number, []).append(run)
    for comment in comments:
        report = parse_report(comment)
        if report is None:
            continue
        number = int(comment["issue_url"].rsplit("/", 1)[1])
        run = run_index.get(report["run_id"])
        if run is None or number not in run_numbers(run, heads):
            raise ValueError(f"Comment {comment['id']}: workflow evidence does not match the PR")
        reports.setdefault(number, []).append(report)
    entries = []
    for number in sorted(attempts.keys() | reports.keys()):
        pr = prs[number]
        history = sorted(reports.get(number, []), key=lambda r: (r["published_at"], r["comment_id"]))
        latest = history[-1] if history else None
        recent = sorted(attempts.get(number, []), key=lambda r: (r.get("run_started_at", r["created_at"]), r["id"]))
        last_run = recent[-1] if recent else None
        entries.append({
            "number": number, "title": pr["title"], "url": f"{WEB}/pull/{number}",
            "state": "merged" if pr["merged_at"] else pr["state"],
            "head_sha": pr["head"]["sha"], "head_branch": pr["head"]["ref"],
            "latest_report": latest, "report_history": history,
            "report_matches_current_head": pr["head"]["sha"].startswith(latest["source_sha_prefix"]) if latest else None,
            "attempts": sum(run["run_attempt"] for run in recent),
            "latest_run": {"id": last_run["id"], "url": f"{WEB}/actions/runs/{last_run['id']}", "status": last_run["status"],
                           "conclusion": last_run["conclusion"], "attempt": last_run["run_attempt"]} if last_run else None,
        })
    totals = Counter({status: 0 for status in STATUSES})
    for entry in entries:
        if entry["latest_report"]:
            totals.update(entry["latest_report"]["counts"])
    return {
        "schema": 1, "repository": REPOSITORY, "generated_at": generated_at,
        "summary": {
            "attempted_prs": len(entries), "published_reports": sum(bool(e["latest_report"]) for e in entries),
            "workflow_attempts": sum(e["attempts"] for e in entries),
            "without_report": sum(e["latest_report"] is None for e in entries),
            "refuted_prs": sum(bool(e["latest_report"] and e["latest_report"]["counts"]["refuted"]) for e in entries),
            "properties": sum(totals.values()), "outcomes": dict(totals),
        },
        "prs": entries,
    }


def ordered(data):
    return sorted(data["prs"], key=lambda e: (
        bool(e["latest_report"] and e["latest_report"]["counts"]["refuted"]),
        e["latest_report"]["published_at"] if e["latest_report"] else "", e["number"]), reverse=True)


def markdown(value):
    escaped = re.sub(r"([\\`*{}\[\]()#+.!_|~-])", r"\\\1", str(value))
    return html.escape(escaped, quote=False).replace("@", "&#64;").replace("\n", " ")


def render_markdown(data):
    total = data["summary"]
    lines = [
        "# LiteBox NFV audit dashboard", "",
        "Published results from the prototype [Neuro-Formal Verification](https://arxiv.org/abs/2608.21516) reviewer.",
        "**Refutations are conditional MODEL refutations, not confirmed source bugs. Verification concerns "
        "translated models under stated assumptions; failure to refute is not evidence of correctness.**", "",
        "**[Live interactive dashboard](https://shuvendu-lahiri.github.io/nfv_dashboard/litebox/)** "
        "or [download the standalone HTML](index.html) (no server or external dependencies).", "",
        f"Snapshot: {data['generated_at']}. Latest published report per PR supplies the counts; all report links are retained "
        "in [data.json](data.json). Workflow attempts without a published report are not counted as zero findings.", "",
        f"**{total['attempted_prs']} PRs attempted; {total['workflow_attempts']} workflow attempts; "
        f"{total['published_reports']} published reports; "
        f"{total['refuted_prs']} PRs with {total['outcomes']['refuted']} conditional refutations; "
        f"{total['outcomes']['verified']} model verifications; {total['without_report']} PRs without a published report.**", "",
        "## All attempted PRs (refutations first)", "",
        "| PR | Change | Latest report | Properties | Refuted | Verified | Exhausted | Audit failure | Evidence |",
        "|---|---|---|---:|---:|---:|---:|---:|---|",
    ]
    for entry in ordered(data):
        report = entry["latest_report"]
        label = f"{REPOSITORY}#{entry['number']}"
        if report:
            counts = report["counts"]
            result = "**REFUTED (model)**" if counts["refuted"] else "Published"
            if not entry["report_matches_current_head"]:
                result += " (older head)"
            run = entry["latest_run"]
            newer_attempt = run and (run["id"] != report["run_id"] or run["conclusion"] != "success")
            if newer_attempt:
                result += " / latest attempt: " + markdown(run["conclusion"] or run["status"])
            values = [str(counts[status]) for status in STATUSES]
            if counts["refuted"]:
                values[0] = f"**{values[0]}**"
            evidence = f"[Report]({report['url']}) / [run]({report['run_url']})"
            if newer_attempt:
                evidence += f" / [latest attempt]({run['url']})"
            lines.append(f"| [{label}]({entry['url']}) | {markdown(entry['title'])} | {result} | "
                         f"{report['properties']} | {' | '.join(values)} | {evidence} |")
        else:
            run = entry["latest_run"]
            status = run["conclusion"] or run["status"]
            lines.append(f"| [{label}]({entry['url']}) | {markdown(entry['title'])} | "
                         f"No published report ({markdown(status)}) | - | - | - | - | - | [Run]({run['url']}) |")
    lines.extend(["", "## Conditional model refutations", "",
                  "The following property texts are extracted from the published reports, without new adjudication "
                  "or inference. The original report contains assumptions, source overlays and native evidence.", ""])
    for entry in ordered(data):
        report = entry["latest_report"]
        if not report:
            continue
        for finding in report["refutations"]:
            lines.extend([f"### {REPOSITORY}#{entry['number']} / {finding['property_id']}", "",
                          markdown(finding["property"]), "", f"[Original report]({report['url']})", ""])
    lines.extend([
        "## Refresh and validate", "",
        "Requires Python 3.10+ and authenticated GitHub CLI read access. From the repository root:", "",
        "```text", "python nfv_reports/refresh.py",
        "python -m unittest discover -s nfv_reports -p test_refresh.py",
        "python nfv_reports/refresh.py --check", "```", "",
        "Refresh reads PR metadata, issue comments and reviewer workflow runs. It never checks out PR heads, "
        "executes PR code, launches audits or changes proof acceptance. Malformed report counts fail refresh explicitly. "
        "Code blocks are excluded when reading outcome labels; Markdown and HTML output treat PR content as data.", "",
        "Only non-skipped reviewer attempts and published reports are included. Skipped-only setup PRs are excluded. "
        "Workflow attempts include reruns without counting PRs or property outcomes twice. "
        "A report for an older head is labeled. Counts are published outcomes, not new proof validation; "
        "comment hashes are snapshot provenance, not authentication or semantic proof.", "",
        "Visual layout reference: [CoZ3 NFV dashboard](https://github.com/Z3Prover/coz3/blob/main/nfv_dashboard.html). "
        "No CoZ3 audit data or adjudication results are used here.", "",
    ])
    return "\n".join(lines)


def render_html(data):
    template = (DIRECTORY / "dashboard.html").read_text(encoding="utf-8")
    if template.count("__NFV_DATA__") != 1:
        raise ValueError("Invalid dashboard template")
    encoded = json.dumps(data, ensure_ascii=True).replace("<", "\\u003c").replace(">", "\\u003e").replace("&", "\\u0026")
    return template.replace("__NFV_DATA__", encoded)


def fetch(endpoint, key=None):
    pages = json.loads(subprocess.check_output(
        ["gh", "api", "--paginate", "--slurp", f"repos/{REPOSITORY}/{endpoint}"],
        text=True, encoding="utf-8"))
    return [item for page in pages for item in (page[key] if key else page)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--input-dir", type=Path, help="Read previously captured pulls/comments/review-runs JSON")
    mode.add_argument("--check", action="store_true", help="Check generated files offline without changing them")
    args = parser.parse_args()
    if args.check:
        data = json.loads((DIRECTORY / "data.json").read_text(encoding="utf-8"))
    else:
        if args.input_dir:
            pulls, comments, runs = [
                json.loads((args.input_dir / name).read_text(encoding="utf-8"))
                for name in ("pulls.json", "comments.json", "review-runs.json")]
        else:
            pulls = fetch("pulls?state=all&per_page=100")
            comments = fetch("issues/comments?per_page=100")
            runs = fetch("actions/workflows/nfv-pr-review.lock.yml/runs?per_page=100", "workflow_runs")
        data = build(pulls, comments, runs, datetime.now(timezone.utc).isoformat())
    outputs = {"data.json": json.dumps(data, indent=2, ensure_ascii=True) + "\n",
               "README.md": render_markdown(data), "index.html": render_html(data)}
    for name, content in outputs.items():
        path = DIRECTORY / name
        if args.check:
            if path.read_text(encoding="utf-8") != content:
                raise ValueError(f"Generated dashboard is stale: {name}")
        else:
            temporary = path.with_name(name + ".tmp")
            temporary.write_text(content, encoding="utf-8", newline="\n")
            temporary.replace(path)
    print(json.dumps({"checked" if args.check else "generated": True, **data["summary"]}))


if __name__ == "__main__":
    main()
