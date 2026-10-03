"""Extract exact CK names and model paths from Skyrim/Update masters.

This is a read-only parser for the records needed by the Deep Sanctuary asset
inventory. It does not edit an ESP or any game files.
"""

from __future__ import annotations

import csv
import struct
import sys
import zlib
from pathlib import Path

RECORD_TYPES = {b"STAT", b"FURN", b"ACTI", b"LIGH", b"CONT", b"BOOK", b"FLOR"}
KEYWORDS = (
    "fire", "hearth", "brazier", "candle", "sconce", "lantern", "bench", "chair",
    "stool", "table", "desk", "bed", "bedroll", "bookcase", "shelf", "chest",
    "strongbox", "cupboard", "wardrobe", "banner", "tapestry", "shield", "skull",
    "bone", "altar", "ritual", "bowl", "basin", "training", "dummy", "target",
    "weapon", "rack", "enchanter", "alchemy", "cooking", "pot", "oven", "spit",
    "sack", "crate", "barrel", "basket", "bucket", "planter", "mushroom", "flower",
    "herb", "water", "pool", "rock", "shore", "plank", "pier", "forge", "anvil",
    "grindstone", "smelter", "workbench", "armor", "retort", "soulgem", "scroll",
    "quill", "ink", "parchment", "map", "book", "cup", "mug", "plate", "knife",
    "cloth", "curtain", "screen", "shovel", "hoe", "ore", "coal", "display",
    "ruin", "sanctuary", "nord", "stone",
)


def strings_file(path: Path) -> dict[int, str]:
    if not path.exists():
        return {}
    raw = path.read_bytes()
    if len(raw) < 8:
        return {}
    count, data_size = struct.unpack_from("<II", raw, 0)
    table_end = 8 + count * 8
    data_start = table_end
    out: dict[int, str] = {}
    for i in range(count):
        sid, off = struct.unpack_from("<II", raw, 8 + i * 8)
        p = data_start + off
        if p >= len(raw):
            continue
        if path.suffix.lower() == ".strings":
            q = raw.find(b"\0", p)
            q = len(raw) if q < 0 else q
            text = raw[p:q]
        else:
            if p + 4 > len(raw):
                continue
            n = struct.unpack_from("<I", raw, p)[0]
            text = raw[p + 4 : p + 4 + n]
        out[sid] = text.decode("utf-8", errors="replace")
    return out


def decode_subrecords(blob: bytes, string_table: dict[int, str]) -> dict[str, str]:
    values: dict[str, str] = {}
    p = 0
    extended_size: int | None = None
    while p + 6 <= len(blob):
        tag = blob[p : p + 4]
        size = struct.unpack_from("<H", blob, p + 4)[0]
        p += 6
        if tag == b"XXXX":
            if size >= 4 and p + 4 <= len(blob):
                extended_size = struct.unpack_from("<I", blob, p)[0]
            p += size
            continue
        if extended_size is not None:
            size = extended_size
            extended_size = None
        value = blob[p : p + size]
        p += size
        key = tag.decode("ascii", errors="replace")
        if key in {"EDID", "MODL", "FULL", "FNAM"}:
            if key == "FULL" and len(value) == 4:
                sid = struct.unpack_from("<I", value, 0)[0]
                text = string_table.get(sid, f"[String {sid:08X}]")
            else:
                text = value.rstrip(b"\0").decode("utf-8", errors="replace")
            values.setdefault(key, text)
    return values


def records(blob: bytes, start: int, end: int, string_table: dict[int, str]):
    p = start
    while p + 24 <= end:
        tag = blob[p : p + 4]
        size = struct.unpack_from("<I", blob, p + 4)[0]
        if tag == b"GRUP":
            group_end = min(p + size, end)
            yield from records(blob, p + 24, group_end, string_table)
            p = group_end
            continue
        record_end = p + 24 + size
        if record_end > end:
            break
        if tag in RECORD_TYPES:
            flags = struct.unpack_from("<I", blob, p + 8)[0]
            form_id = struct.unpack_from("<I", blob, p + 12)[0]
            record_blob = blob[p + 24 : record_end]
            if flags & 0x00040000:
                if len(record_blob) >= 4:
                    expected = struct.unpack_from("<I", record_blob, 0)[0]
                    try:
                        record_blob = zlib.decompress(record_blob[4:])
                    except zlib.error:
                        record_blob = b""
                    if expected and len(record_blob) != expected:
                        pass
            values = decode_subrecords(record_blob, string_table)
            yield tag.decode("ascii"), form_id, values
        p = record_end


def parse_master(path: Path, strings: dict[int, str]):
    data = path.read_bytes()
    yield from records(data, 0, len(data), strings)


def main() -> int:
    if len(sys.argv) < 3:
        print("usage: extract_skyrim_asset_records.py <Data> <output.tsv>", file=sys.stderr)
        return 2
    data_dir = Path(sys.argv[1])
    out_path = Path(sys.argv[2])
    rows = []
    for master in ("Skyrim.esm", "Update.esm"):
        path = data_dir / master
        if not path.exists():
            continue
        table: dict[int, str] = {}
        stem = path.stem
        for ext in (".STRINGS", ".DLSTRINGS", ".ILSTRINGS"):
            for candidate in (data_dir / "Strings" / f"{stem}_English{ext}",
                              data_dir / "Strings" / f"{stem}_english{ext}"):
                table.update(strings_file(candidate))
        for sig, form_id, vals in parse_master(path, table):
            edid = vals.get("EDID", "")
            full = vals.get("FULL", "")
            model = vals.get("MODL", "")
            haystack = f"{edid} {full} {model}".lower()
            if not any(k in haystack for k in KEYWORDS):
                continue
            rows.append((master, sig, f"{form_id:08X}", edid, full, model))
    rows.sort(key=lambda row: (row[0], row[1], row[3].lower()))
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f, delimiter="\t", lineterminator="\n")
        writer.writerow(("Master", "RecordType", "FormID", "EditorID", "DisplayName", "Mesh"))
        writer.writerows(rows)
    print(f"wrote {len(rows)} matching records to {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
