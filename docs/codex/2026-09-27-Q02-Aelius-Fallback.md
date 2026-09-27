# Auftrag: Q02 – Fallback-Zeile, falls Aelius vor Stage 60 stirbt

**Wofür:** Q02 „Cold Waters“, Stage 60. Normalerweise holt Sings-Beneath-Ice Aelius Varro nachts aus
seinem Büro und tötet ihn in der Szene `SCN_Aelius`. Stirbt Aelius vorher durch einen unabhängigen
Zufall (Kampf, Unfall, ein anderer Mod), kann diese Szene nicht mehr stattfinden. Ohne eine
Ausweich-Zeile bleibt der Übergang zu Stage 70 stumm.

**Was schreiben:** Eine kurze Sings-Zeile (1 Satz, evtl. eine zweite Reaktionszeile des Spielers oder
Veyras optional), die den Sprung direkt zu Stage 70 trägt, ohne die eigentliche Tötungsszene zu
behaupten. Ton: nüchtern, leicht enttäuscht über die verpasste eigene Tat, kein Slapstick.
Sinngemäßer Inhalt (kein Zitat, nur Richtung): „Jemand war schneller als ich“ / „Sithis braucht
mich hier nicht mehr“.

**Speichern:** `dialogue/Q02.csv`, Topic `Sings_Judgement` (bestehend), Speaker `Sings`,
VoiceType `NHV_VoiceSings`, Stage 60. Neue LineID `NHV_Q02_060_90` (bisher unbenutzt, an das
bestehende Schema `NHV_Q02_<Stage>_<Nr>` anschließen, keine bestehende LineID umnummerieren).
Conditions-Spalte: an `GetIsID Aelius == 1 AND IsDead == 1` orientieren bzw. an das Global
`NHV_Q02_Flag_AeliusFallback == 1` (wird von `NHV_Q02Script.StartAeliusKillScene()` gesetzt).

**Grenzen:** Amerikanische Schreibweise, ein Satz, keine neue Lore-Behauptung über Aelius' Tod
(offen lassen, wer/was ihn getötet hat). Keine Wiederholung der bereits vorhandenen Zeilen aus
Stage 70 (`070_01`ff.).

**Technik:** Wird direkt nach `NHV_Q02Script.StartAeliusKillScene()` gezeigt, sobald
`IsAeliusAvailable()` False zurückgibt; danach `SetStage(70)` automatisch durch das Script.
