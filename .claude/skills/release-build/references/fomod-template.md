# FOMOD-Vorlage – Night's Harvest

## Archivstruktur

```text
NightsHarvest-<Version>.7z
├─ fomod/
│  ├─ info.xml
│  ├─ ModuleConfig.xml
│  └─ images/                  header.png, je Option ein Bild (optional)
├─ 00 Core/
│  ├─ NightsHarvest.esp
│  ├─ NightsHarvest.bsa        Scripts, MCM-Strings, ggf. SEQ
│  └─ SEQ/NightsHarvest.seq    nur falls nötig und nicht im BSA
├─ 10 Patches/
│  └─ <ModName>/               je Patch ein Ordner mit eigenem ESP
└─ 20 Mantella/                optionale Charakter-Bios (Pfad je Mantella-Version)
```

Das Voice-Pack (ab v1.1) ist ein eigener Nexus-Download, kein Teil dieses Installers.

## fomod/info.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<fomod>
  <Name>Night's Harvest</Name>
  <Author>AUTHOR</Author>
  <Version>0.1.0</Version>
  <Website>https://www.nexusmods.com/skyrimspecialedition/mods/XXXXX</Website>
  <Description>Rebuild the Dark Brotherhood after Hail Sithis: a new recruiter, five recruitment contracts and a family that lives on in the Dawnstar Sanctuary.</Description>
  <Groups>
    <element>Quests and Adventures</element>
  </Groups>
</fomod>
```

## fomod/ModuleConfig.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="http://qconsulting.ca/fo3/ModConfig5.0.xsd">
  <moduleName>Night's Harvest</moduleName>
  <moduleImage path="fomod/images/header.png"/>

  <requiredInstallFiles>
    <folder source="00 Core" destination=""/>
  </requiredInstallFiles>

  <installSteps order="Explicit">

    <installStep name="Compatibility Patches">
      <optionalFileGroups order="Explicit">
        <group name="Patches" type="SelectAny">
          <plugins order="Explicit">
            <plugin name="EXAMPLE Sanctuary Overhaul Patch">
              <description>Moves the Deep Sanctuary entrance to fit EXAMPLE Sanctuary Overhaul. Recommended if that mod is active.</description>
              <image path="fomod/images/patch_example.png"/>
              <files>
                <folder source="10 Patches/EXAMPLE" destination=""/>
              </files>
              <typeDescriptor>
                <dependencyType>
                  <defaultType name="NotUsable"/>
                  <patterns>
                    <pattern>
                      <dependencies operator="And">
                        <fileDependency file="EXAMPLE.esp" state="Active"/>
                      </dependencies>
                      <type name="Recommended"/>
                    </pattern>
                  </patterns>
                </dependencyType>
              </typeDescriptor>
            </plugin>
          </plugins>
        </group>
      </optionalFileGroups>
    </installStep>

    <installStep name="Mantella">
      <optionalFileGroups order="Explicit">
        <group name="Character Bios" type="SelectAtMostOne">
          <plugins order="Explicit">
            <plugin name="Mantella Character Bios">
              <description>Spoiler-free bios for Veyra and the recruits, for use with Mantella. Does not replace scripted dialogue.</description>
              <files>
                <folder source="20 Mantella" destination="MANTELLA_TARGET_PATH"/>
              </files>
              <typeDescriptor>
                <type name="Optional"/>
              </typeDescriptor>
            </plugin>
          </plugins>
        </group>
      </optionalFileGroups>
    </installStep>

  </installSteps>
</config>
```

## Regeln

- Reihenfolge in `<plugin>`: `description`, `image`, `files`, `typeDescriptor`.
- `fileDependency state`: `Active`, `Inactive` oder `Missing`.
- Patch-Optionen: `defaultType NotUsable` + Pattern `Recommended`, damit sie nur bei vorhandenem Zielmod wählbar sind.
- `MANTELLA_TARGET_PATH` vor dem ersten Release mit dem Pfad der aktuellen Mantella-Version ersetzen oder den Schritt weglassen.
- Nach jeder Änderung: frische Installation in Vortex und MO2 testen.
