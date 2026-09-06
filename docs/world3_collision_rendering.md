# World 3 collision and rendering

`config/world3_collision_rendering.json` fixes all twenty-two formerly
address-named routine entries in `object_scripts_2.asm`. The exact contract
covers 808 executable bytes, 50 direct calls or tail jumps, and twenty
Bank 2-private RAM symbols covering 21 bytes.

The collision convention is now explicit: carry set means the sampled edge is
passable, while carry clear rejects movement or turns a projectile into its
impact state. Player probes sample three points on each vertical edge and two
points on each horizontal edge. Entity probes sample two points and treat tile
ID `$01` differently from the player. The player path additionally enables
state-dependent openings for:

- the freed companions in final room `$3C`;
- the active Passing Hoop portal;
- defeated formations in rooms `$27`, `$28`, and `$34`.

The rendering half pins forward/reverse entity traversal, one-slot state and
metasprite composition, the complete 15-byte metasprite/OAM workspace, and the
deliberate one-byte no-op hook at `$9DCD`. Scratch coordinates shared with
unrelated routines remain numeric.

Run:

```text
make validate-world3-collision-rendering
```
