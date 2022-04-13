# NAS Utilities
A collection of shell utilities.

## renameUtility.sh
A multiple purpose utility, intended to be used in the mass renaming of video files that follow the "SxxExx" convention for series numbering.

When launching the utility, two main options are offered:
1) Increasing decreasing the episode number.
This option will ask for a base directory and an offset. The offset CAN be negative.
The utility will then apply the offset to the episode number and appropriately rename the episode.
Es: for a given offset of "5" the utility will rename the following files:
```
Foobar - S01E03.mkv
Foobar - S01E04.mkv
Foobar - S01E10.mkv
```
to
```
Foobar - S01E08.mkv
Foobar - S01E09.mkv
Foobar - S01E15.mkv
```

2) Changing the season.
This option will ask for a base directory and a season number. The season number must be non-negative.
The utility will then change the season and appropriately rename the episode.
Es: for a given season of "1" the utility will rename the following files:
```
Foobar - S01E03.mkv
Foobar - S04E04.mkv
Foobar - S10E10.mkv
```
to
```
Foobar - S01E03.mkv
Foobar - S01E04.mkv
Foobar - S01E10.mkv
```
