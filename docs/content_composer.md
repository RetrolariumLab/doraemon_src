# Common content composer

The common composer turns any subset of the five supported Studio workspaces
into one playable ROM. Its base is always the selected source-built official
revision; it never patches the user's reference dump directly.

Initialize and validate the complete workspace with:

```text
make content-init PROFILE=original
make content-check PROFILE=original
```

Build all edited content into one image:

```text
make content-rom PROFILE=original
```

`PROFILE=rev_a` selects Revision A. To compose only a subset, pass the
comma-separated Studio IDs, for example:

```text
make content-rom PROFILE=rev_a STUDIOS=level,graphics,objects
```

The accepted IDs are `level`, `graphics`, `objects`, `text`, and `sound`.

## Shared-byte policy

Each selected Studio first renders a complete candidate image from the same
unchanged base. The composer then merges only bytes that differ from that base.
Two Studios may write the same changed value, which is required for shared
World 1/3 hierarchy documents and the World 2 map/spawn stream. Different
values at one physical offset are rejected with both Studio names and the
conflicting bytes.

This also protects the documented Bank 1 boundary shared by an audio end token
and World 2 graphics data: Sound Studio locks the control-flow token, and the
merger refuses any future incompatible claim.

## Release checks

```text
make content-roundtrip
```

The round trip first verifies both source-built revision images, applies every
canonical Studio document together, and requires zero changed bytes for the
original revision and Revision A.
