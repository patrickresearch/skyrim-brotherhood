"""Build the human-sized Deep Sanctuary CK inventory from the raw master dump."""
from __future__ import annotations

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "docs/ck/M1.3-Deep-Sanctuary-Asset-Inventar.tsv"
OUT = ROOT / "docs/ck/M1.3-Deep-Sanctuary-Asset-Records.csv"

SELECT = {
    # Nordic room kit and ruined-state dressing
    "NorRmBgMidFloorOnly01", "NorRmBgMidCeilingOnlyLow01", "NorRmBgWallFront01",
    "NorRmBgWallSide01", "NorRmSmMidFloorOnly01", "NorRmSmWallFront01",
    "NorRmSmWallSide01", "NorRmSmWallFrontFireplace01", "NorRmSmWallSideFireplace01",
    "NorHallOfStoriesArch01", "NorDoorMediumSTATIC", "NorRubblePiece01",
    "NorRubblePiece02", "NorRubblePile01", "NorBookPedestal", "NorTable01NoShadow",
    "NorTableLong01", "NorHallBg1wayStairs256", "NorHallSm1wayStairs128",
    "NorRmShaftMidStairBot01", "NorRmShaftMidStair01", "NorRmShaftMidStairTop01",
    "NorRmShaftMidStairDeck01", "NorTmpHallBg1wayStairsDown01", "NorTmpHallBg1wayStairsUp01",
    # Ruins furniture/decor
    "RuinsAltar", "RuinsBench01Static", "RuinsBrokenBench01", "RuinsBrokenShelf01",
    "RuinsBrokenTable01", "RuinsCandleSconceNoCandle", "RuinsCandleSconceOff01",
    "RuinsCandleSconceOn1", "RuinsCandleSconceOn2", "RuinsLargeCeilingSconce",
    "RuinsLargeFloorSconce", "RuinsSconceAndBase", "RuinsWallSconce",
    "RuinsShelfLargeFull", "RuinsShelfSmallFull",
    # Brotherhood-specific visual language
    "DBBannerAnchor", "DBBannerAnchor02", "DBNightMotherCoffin", "DBNightMotherCoffin2",
    # Furniture and craft stations
    "CommonBed01", "CommonBedDouble01", "CommonBench01", "CommonChair01",
    "CommonTableOneBench", "CommonTableTwoBenches", "NorTableOneBench", "NorTableTwoBenches",
    "CraftingAlchemyWorkbench", "CraftingEnchantingWorkbench", "CraftingBlacksmithAnvil",
    "CraftingBlacksmithArmorWorkbench", "CraftingBlackSmithForge", "CraftingCookingFireSpit",
    "CraftingCookingPotLG", "CraftingCookingPotSm", "CraftingSmelterMarker1",
    "CraftingTanningRackMarker", "CraftingBlacksmithForgeSTATIC",
    # Training and display
    "CombatDummy01", "CombatDummy02", "CombatDummy03", "ArcheryTarget", "ArcheryTargetTripod",
    "WeaponRackMid", "WeaponRackMidACTIVATOR", "WeaponRackPlaque", "WeaponRackPlaqueACTIVATOR",
    # Shelving/containers/lighting
    "CommonWardrobe01", "Cupboard01", "BarrelIngredientCommon01", "BarrelFood01",
    "LargeChestNoRespawn", "FVDStrongbox", "DB03Barrel", "DBCandlePost01NS",
    "DBFireLight01", "DBFireLight01NS",
    # Garden and water-room candidates
    "SBigPlanter01", "SBigPlanter02", "Splanter01", "WRTemplePlanter", "WRTempIntPool01",
    "RockL01Wet", "RockM02Wet", "FloraCreepClusterRock", "FloraMushroom01", "FloraMushroom02",
    "GlowingMushroomCluster",
}

META = {
    "NorRmBgMidFloorOnly01": ("Architecture", "large Nordic room floor", "core shell"),
    "NorRmBgMidCeilingOnlyLow01": ("Architecture", "low Nordic ceiling", "core shell"),
    "NorRmBgWallFront01": ("Architecture", "Nordic wall front", "core shell"),
    "NorRmBgWallSide01": ("Architecture", "Nordic wall side", "core shell"),
    "NorRmSmMidFloorOnly01": ("Architecture", "small room floor", "core shell"),
    "NorRmSmWallFront01": ("Architecture", "small room wall front", "core shell"),
    "NorRmSmWallSide01": ("Architecture", "small room wall side", "core shell"),
    "NorRmSmWallFrontFireplace01": ("Hall/Fireplace", "wall with fireplace opening", "core shell"),
    "NorRmSmWallSideFireplace01": ("Hall/Fireplace", "side wall with fireplace opening", "core shell"),
    "NorHallOfStoriesArch01": ("Architecture", "interior arch", "core shell"),
    "NorDoorMediumSTATIC": ("Architecture", "Nordic medium doorway", "core shell"),
    "NorRubblePiece01": ("Ruined dressing", "loose rubble", "ruined state"),
    "NorRubblePiece02": ("Ruined dressing", "loose rubble", "ruined state"),
    "NorRubblePile01": ("Ruined dressing", "rubble pile", "ruined state"),
    "NorBookPedestal": ("Shrine/Arcanum", "book or relic pedestal", "decor"),
    "NorTable01NoShadow": ("Hall/Ledger", "Nordic table", "decor"),
    "NorTableLong01": ("Hall/Ledger", "long Nordic table", "decor"),
    "NorHallBg1wayStairs256": ("Vertical route", "large Nordic stair flight", "stair candidate"),
    "NorHallSm1wayStairs128": ("Vertical route", "small Nordic stair flight", "stair candidate"),
    "NorRmShaftMidStairBot01": ("Vertical route", "stair shaft bottom", "stair candidate"),
    "NorRmShaftMidStair01": ("Vertical route", "stair shaft middle", "stair candidate"),
    "NorRmShaftMidStairTop01": ("Vertical route", "stair shaft top", "stair candidate"),
    "NorRmShaftMidStairDeck01": ("Vertical route", "stair shaft landing", "stair candidate"),
    "NorTmpHallBg1wayStairsDown01": ("Vertical route", "downward hall stair", "stair candidate"),
    "NorTmpHallBg1wayStairsUp01": ("Vertical route", "upward hall stair", "stair candidate"),
    "RuinsAltar": ("Shrine", "ruined altar", "decor"),
    "RuinsBench01Static": ("Hall/Training", "ruined bench", "decor"),
    "RuinsBrokenBench01": ("Ruined dressing", "broken bench", "ruined state"),
    "RuinsBrokenShelf01": ("Ruined dressing", "broken shelf", "ruined state"),
    "RuinsBrokenTable01": ("Ruined dressing", "broken table", "ruined state"),
    "RuinsCandleSconceNoCandle": ("Lighting", "empty wall sconce", "ruined state"),
    "RuinsCandleSconceOff01": ("Lighting", "unlit wall sconce", "decor"),
    "RuinsCandleSconceOn1": ("Lighting", "lit wall sconce", "decor"),
    "RuinsCandleSconceOn2": ("Lighting", "lit double wall sconce", "decor"),
    "RuinsLargeCeilingSconce": ("Lighting", "large ceiling sconce", "decor"),
    "RuinsLargeFloorSconce": ("Lighting", "large floor sconce", "decor"),
    "RuinsSconceAndBase": ("Lighting", "sconce with base", "decor"),
    "RuinsWallSconce": ("Lighting", "wall sconce", "decor"),
    "RuinsShelfLargeFull": ("Ledger/Arcanum", "large shelf", "decor"),
    "RuinsShelfSmallFull": ("Ledger/Arcanum", "small shelf", "decor"),
    "DBBannerAnchor": ("Hall/Memorial", "Dark Brotherhood banner anchor", "DB visual"),
    "DBBannerAnchor02": ("Hall/Memorial", "alternate banner anchor", "DB visual"),
    "DBNightMotherCoffin": ("Shrine", "Night Mother coffin prop", "optional lore prop"),
    "DBNightMotherCoffin2": ("Shrine", "alternate Night Mother coffin prop", "optional lore prop"),
    "CommonBed01": ("Dormitory", "single bed", "furniture"),
    "CommonBedDouble01": ("Dormitory", "double bed", "furniture"),
    "CommonBench01": ("Hall/Training", "bench", "furniture"),
    "CommonChair01": ("Hall/Ledger", "chair", "furniture"),
    "CommonTableOneBench": ("Hall", "table with one bench", "furniture"),
    "CommonTableTwoBenches": ("Hall", "table with two benches", "furniture"),
    "NorTableOneBench": ("Hall", "Nordic table with one bench", "furniture"),
    "NorTableTwoBenches": ("Hall", "Nordic table with two benches", "furniture"),
    "CraftingAlchemyWorkbench": ("Arcanum", "alchemy lab furniture", "crafting station"),
    "CraftingEnchantingWorkbench": ("Arcanum", "arcane enchanter furniture", "crafting station"),
    "CraftingBlacksmithAnvil": ("Forge", "anvil furniture", "crafting station"),
    "CraftingBlacksmithArmorWorkbench": ("Forge", "armor workbench", "crafting station"),
    "CraftingBlackSmithForge": ("Forge", "blacksmith forge marker", "crafting station"),
    "CraftingCookingFireSpit": ("Kitchen", "cooking spit", "crafting station"),
    "CraftingCookingPotLG": ("Kitchen", "large cooking pot", "crafting station"),
    "CraftingCookingPotSm": ("Kitchen", "small cooking pot", "crafting station"),
    "CraftingSmelterMarker1": ("Forge", "smelter marker", "crafting station"),
    "CraftingTanningRackMarker": ("Forge", "tanning rack marker", "crafting station"),
    "CraftingBlacksmithForgeSTATIC": ("Forge", "blacksmith forge static activator", "crafting station"),
    "CombatDummy01": ("Training", "practice dummy activator", "training"),
    "CombatDummy02": ("Training", "alternate practice dummy activator", "training"),
    "CombatDummy03": ("Training", "third practice dummy activator", "training"),
    "ArcheryTarget": ("Training", "archery target", "training"),
    "ArcheryTargetTripod": ("Training", "archery target tripod", "training"),
    "WeaponRackMid": ("Training/Memorial", "single weapon rack", "display pair"),
    "WeaponRackMidACTIVATOR": ("Training/Memorial", "weapon rack activator", "display pair"),
    "WeaponRackPlaque": ("Memorial", "weapon plaque", "display pair"),
    "WeaponRackPlaqueACTIVATOR": ("Memorial", "weapon plaque activator", "display pair"),
    "CommonWardrobe01": ("Dormitory", "wardrobe", "storage"),
    "Cupboard01": ("Kitchen", "cupboard", "storage"),
    "BarrelIngredientCommon01": ("Kitchen/Garden", "ingredient barrel", "storage"),
    "BarrelFood01": ("Kitchen", "food barrel", "storage"),
    "LargeChestNoRespawn": ("Ledger/Dormitory", "non-respawning chest", "storage"),
    "FVDStrongbox": ("Ledger", "strongbox", "storage"),
    "DB03Barrel": ("Kitchen", "Brotherhood barrel", "storage"),
    "DBCandlePost01NS": ("Lighting", "Dark Brotherhood candle post light", "lighting"),
    "DBFireLight01": ("Lighting", "Dark Brotherhood fire light", "lighting"),
    "DBFireLight01NS": ("Lighting", "Dark Brotherhood fire light, no shadow", "lighting"),
    "SBigPlanter01": ("Garden", "large planter", "garden"),
    "SBigPlanter02": ("Garden", "alternate large planter", "garden"),
    "Splanter01": ("Garden", "small planter", "garden"),
    "WRTemplePlanter": ("Garden", "stone temple planter", "garden"),
    "WRTempIntPool01": ("Drowned Pool", "interior pool segment", "pool candidate"),
    "RockL01Wet": ("Drowned Pool", "wet large rock", "pool dressing"),
    "RockM02Wet": ("Drowned Pool", "wet medium rock", "pool dressing"),
    "FloraCreepClusterRock": ("Garden/Drowned Pool", "creep cluster", "flora"),
    "FloraMushroom01": ("Garden/Drowned Pool", "mushroom", "flora"),
    "FloraMushroom02": ("Garden/Drowned Pool", "mushroom variant", "flora"),
    "GlowingMushroomCluster": ("Drowned Pool", "glowing mushroom cluster", "flora"),
}

CUSTOM = [
    ("Night's Harvest", "ACTI", "—", "NHV_Act_MapTable", "Map Table", "CWMapMarkers02.nif", "Ledger Room", "existing custom record"),
    ("Night's Harvest", "ACTI", "—", "NHV_Act_Q00_Plaque*", "Memorial plaque activators", "Clutter\\WeaponRack\\WRPlaque01.nif", "Memorial Wall", "existing custom records; see individual IDs"),
    ("Night's Harvest", "ACTI", "—", "NHV_Act_DrownedPoolNameBowl", "Name bowl", "TBD in CK", "Drowned Pool", "existing custom record; choose mesh in CK"),
    ("Night's Harvest", "STAT/ACTI", "—", "NHV_Act_DrownedPoolPost", "Pool post", "TBD in CK", "Drowned Pool", "existing custom record; choose mesh in CK"),
]


def main() -> None:
    raw_rows = list(csv.DictReader(RAW.open(encoding="utf-8"), delimiter="\t"))
    by_id = {row["EditorID"]: row for row in raw_rows}
    rows = []
    for editor_id in sorted(SELECT, key=str.lower):
        row = by_id.get(editor_id)
        if not row:
            raise SystemExit(f"Missing expected master record: {editor_id}")
        category, use, status = META[editor_id]
        rows.append({
            "Source": row["Master"], "RecordType": row["RecordType"], "FormID": row["FormID"],
            "EditorID": row["EditorID"], "CKFilterName": row["EditorID"], "Mesh": row["Mesh"],
            "Room": category, "Use": use, "Status": status,
        })
    for source, typ, form_id, eid, name, mesh, room, status in CUSTOM:
        rows.append({"Source": source, "RecordType": typ, "FormID": form_id, "EditorID": eid,
                     "CKFilterName": eid, "Mesh": mesh, "Room": room, "Use": name, "Status": status})
    OUT.parent.mkdir(parents=True, exist_ok=True)
    with OUT.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    print(f"wrote {len(rows)} curated records to {OUT}")


if __name__ == "__main__":
    main()
