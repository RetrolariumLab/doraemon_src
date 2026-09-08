"""Read and inspect the public Make interface, including literal fragments."""

from __future__ import annotations

from pathlib import Path
import re


INCLUDE_PATTERN = re.compile(r"^-?include\s+(.+)$", re.MULTILINE)
TARGET_PATTERN = re.compile(r"^([^\s:#=][^\r\n:#=]*)\s*:(?![=])", re.MULTILINE)


def _logical_lines(text: str) -> str:
    return re.sub(r"\\\r?\n\s*", " ", text)


def read_make_interface(makefile: Path) -> str:
    """Return *makefile* plus every literal include, in declaration order."""

    seen: set[Path] = set()
    documents: list[str] = []

    def visit(path: Path) -> None:
        resolved = path.resolve()
        if resolved in seen:
            return
        seen.add(resolved)
        text = resolved.read_text(encoding="utf-8")
        documents.append(text)
        for match in INCLUDE_PATTERN.finditer(_logical_lines(text)):
            for value in match.group(1).split():
                if "$" in value or any(character in value for character in "*?["):
                    raise ValueError(
                        f"Make include must be a literal path for repository audits: {value}"
                    )
                child = Path(value)
                if not child.is_absolute():
                    child = resolved.parent / child
                visit(child)

    visit(makefile)
    return "\n".join(documents)


def make_targets(text: str) -> set[str]:
    targets: set[str] = set()
    for match in TARGET_PATTERN.finditer(text):
        for target in match.group(1).split():
            if re.fullmatch(r"[A-Za-z0-9_.-]+", target):
                targets.add(target)
    return targets


def make_rule_dependencies(text: str, target: str) -> set[str]:
    lines = text.splitlines()
    for index, line in enumerate(lines):
        match = re.match(rf"^{re.escape(target)}\s*:(?![=])(.*)$", line)
        if match is None:
            continue
        parts = [match.group(1).rstrip(" \\")]
        while line.rstrip().endswith("\\"):
            index += 1
            if index >= len(lines):
                break
            line = lines[index]
            parts.append(line.strip().rstrip(" \\"))
        return set(" ".join(parts).split())
    return set()
