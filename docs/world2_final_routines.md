# World 2 final routines

`config/world2_final_routines.json` fixes the last thirteen address-named
routine entries in Bank 1. It covers 796 executable bytes, 19 direct calls or
tail jumps, and nineteen Bank 1-private RAM symbols covering 26 bytes.

The contract joins four remaining areas:

- packed pending-enemy activation and collision against all player attacks;
- world-scroll translation and rendering of enemy projectiles;
- enemy metasprite dispatch, quadrant composition, and OAM emission;
- terminal chapter completion plus the health/lives/score HUD.

The scroll direction and its vertical/horizontal transition delays are now
named from the NMI screen-service paths and the matching enemy/projectile
translation gates. The HUD's eight-byte health-tile workspace and the enemy
metasprite/projectile-aim workspaces are also explicit. Scratch locations with
unrelated lifetimes remain numeric.

After this pass Bank 1 has no `Bank1_Func_XXXX` definitions. Local branch
labels remain address-qualified unless their meaning materially clarifies a
routine contract.

Run:

```text
make validate-world2-final-routines
```
