# Audio effect request ABI

The four bank-local effect drivers map a request ID through an even priority
byte to one adjacent `init`/`update` pair in a target-minus-one RTS dispatch
table. The stored priority is therefore both an arbitration rank and the byte
offset of the pair. World 1, World 3, and the shell expose 26 requests; World 2
uses a 15-request subset with its own permutation.

`config/audio_effects.json` assigns all 93 request IDs to 26 conservative
structural roles. Each role records its handler pair, effect-timer leases, APU
channels actually written, and directly observed synthesis behavior. These
names deliberately describe register and state transitions rather than
unproved in-game sound identities.

The distinction between timer leases and APU writes matters. The
`pulse1_tone_triangle_lease` role writes pulse 1 while reserving the triangle
timer slot. The late pulse-1 alternators and three shell composites write APU
registers without acquiring any timer lease, so music can overwrite those
channels in the same arbitration model. Reset request zero clears every timer
instead of acquiring a lease.

Several request roles share one update entry, such as the generic timed stop
or the parameterized pulse-2 pitch sequence. The validator rejects two roles
that assign incompatible meanings to the same target, derives all 145 unique
dispatch-handler symbols from the request graph, and also requires the sixteen
bank-local noise-onset, pointer, sequence-gate, and indexed-tonal helpers in the
canonical source registry.

`make validate-audio-effects` checks the complete request-to-pair permutation,
all channel contracts, shared-handler consistency, and semantic symbols.
Exact gameplay identities for the effects remain intentionally open until
runtime call-site/audio evidence supports them.
