# World 3 room runtime

`config/world3_room_runtime.json` fixes fifteen formerly address-named World 3
routines covering input and audio wrappers, player rendering, all four room
edges, room-entry persistence policy, full room reconstruction, music
selection, and the palette fade. The exact contract covers 607 executable
bytes, 76 direct calls, and ten Bank 2-private RAM bytes.

## Room transition transaction

Each directional edge first checks the matching coordinate of the 8 by 8 room
grid and stages the adjacent room in `World3TransitionTargetRoom`. Before
committing `World3CurrentRoom`, the transition:

- drops an active follower if the destination already contains three
  persistent objects;
- clears persistent state before final room `$3F`;
- clears persistent state before undefeated boss rooms `$27`, `$28`, and
  `$34`;
- saves the outgoing and incoming object-persistence phases;
- rebuilds the destination room through `World3_LoadCurrentRoom`.

The load transaction darkens and disables the display, selects World 3 CHR,
prepares the nametable and room palette, clears and rematerializes entities,
rebuilds collision state, restores special-room presentation, renders the HUD,
reenables the display, and selects the room music.

## Input, player, and music

`World3_ReadActivePlayerButtons` returns the combined controller byte during
gameplay and zero during attract mode. Both effect wrappers preserve X and Y,
which accounts for all 29 direct audio-wrapper callers in this slice.

Player rendering adds `World3PlayerAnimationFrame` to
`World3PlayerMetaspriteBase`, stages the player coordinates through the common
metasprite-origin helper, and submits the resolved index. Room music uses a
64-byte room-to-class table followed by a four-byte class-to-track table:

```text
World3CurrentRoom
  -> World3_RoomMusicClassByRoom
  -> World3_MusicTrackByRoomClass
  -> World3RoomMusicTrack
```

Run:

```text
make validate-world3-room-runtime
```
