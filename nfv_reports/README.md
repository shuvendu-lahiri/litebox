# LiteBox NFV audit dashboard

Published results from the prototype [Neuro-Formal Verification](https://arxiv.org/abs/2608.21516) reviewer.
**Refutations are conditional MODEL refutations, not confirmed source bugs. Verification concerns translated models under stated assumptions; failure to refute is not evidence of correctness.**

**[Live interactive dashboard](https://shuvendu-lahiri.github.io/litebox/nfv_reports/)** or [download the standalone HTML](index.html) (no server or external dependencies).

Snapshot: 2026-10-23T19:26:21.122437+00:00. Latest published report per PR supplies the counts; all report links are retained in [data.json](data.json). Workflow attempts without a published report are not counted as zero findings.

**44 PRs attempted; 50 workflow attempts; 34 published reports; 10 PRs with 11 conditional refutations; 153 model verifications; 10 PRs without a published report.**

## All attempted PRs (refutations first)

| PR | Change | Latest report | Properties | Refuted | Verified | Exhausted | Audit failure | Evidence |
|---|---|---|---:|---:|---:|---:|---:|---|
| [shuvendu-lahiri/litebox#38](https://github.com/shuvendu-lahiri/litebox/pull/38) | Staged NFV audit \- change 1668: Stacked runners: Add virtual init | **REFUTED (model)** | 8 | **1** | 2 | 3 | 2 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/38#issuecomment-6307252325) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532833594) |
| [shuvendu-lahiri/litebox#43](https://github.com/shuvendu-lahiri/litebox/pull/43) | Staged NFV audit \- change 1635: Cherry\-pick "LVBS: Allow concurrent vault entries" | **REFUTED (model)** | 10 | **1** | 0 | 2 | 7 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/43#issuecomment-6307191865) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532819562) |
| [shuvendu-lahiri/litebox#42](https://github.com/shuvendu-lahiri/litebox/pull/42) | Staged NFV audit \- change 1637: Cherry\-pick "LVBS: Clean up after a panic inside the vault" | **REFUTED (model)** | 8 | **1** | 1 | 4 | 2 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/42#issuecomment-6307056163) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532822431) |
| [shuvendu-lahiri/litebox#35](https://github.com/shuvendu-lahiri/litebox/pull/35) | Replay change 1059: Minor cleanup over change 1056 | **REFUTED (model)** | 10 | **2** | 6 | 0 | 2 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/35#issuecomment-6297535430) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39460648199) |
| [shuvendu-lahiri/litebox#33](https://github.com/shuvendu-lahiri/litebox/pull/33) | Replay change 1254: Cherry pick change 1106 Improve handle management | **REFUTED (model)** | 10 | **1** | 6 | 1 | 2 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/33#issuecomment-6296426613) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39456104468) |
| [shuvendu-lahiri/litebox#32](https://github.com/shuvendu-lahiri/litebox/pull/32) | Replay change 1255: Cherry pick change 1107 Migrate in\-memory file system to new backend | **REFUTED (model)** | 10 | **1** | 8 | 1 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/32#issuecomment-6295599807) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39449644221) |
| [shuvendu-lahiri/litebox#30](https://github.com/shuvendu-lahiri/litebox/pull/30) | Replay change 1273: Cherry pick change 1111 Reduce locking contention over fd iterations | **REFUTED (model)** | 9 | **1** | 5 | 0 | 3 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/30#issuecomment-6294367207) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39440593410) |
| [shuvendu-lahiri/litebox#27](https://github.com/shuvendu-lahiri/litebox/pull/27) | Replay change 1281: Cherry pick change 1165 Join the spawned handles in tests | **REFUTED (model)** | 7 | **1** | 6 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/27#issuecomment-6292943415) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39432560915) |
| [shuvendu-lahiri/litebox#24](https://github.com/shuvendu-lahiri/litebox/pull/24) | Replay change 1297: Cherry pick change 1231 Switch to explicit file system \`Context\`s | **REFUTED (model)** | 10 | **1** | 8 | 0 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/24#issuecomment-6291911996) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39424463467) |
| [shuvendu-lahiri/litebox#2](https://github.com/shuvendu-lahiri/litebox/pull/2) | Replay change 1656: copy broker pipe and socket reads in bulk | **REFUTED (model)** | 8 | **1** | 7 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/2#issuecomment-6260871431) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39205431424) |
| [shuvendu-lahiri/litebox#39](https://github.com/shuvendu-lahiri/litebox/pull/39) | Staged NFV audit \- change 1665: Zeroize sensitive data in OP\-TEE crypto syscalls | Published | 9 | 0 | 2 | 0 | 7 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/39#issuecomment-6307021315) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532831209) |
| [shuvendu-lahiri/litebox#44](https://github.com/shuvendu-lahiri/litebox/pull/44) | Staged NFV audit \- change 1633: Cherry\-pick "Fix handle allocator overflows in OP\-TEE shim" | Published | 9 | 0 | 2 | 0 | 7 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/44#issuecomment-6306994781) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532816407) |
| [shuvendu-lahiri/litebox#41](https://github.com/shuvendu-lahiri/litebox/pull/41) | Staged NFV audit \- change 1652: Accept inherited ignored signals in the Linux userland runner | Published | 4 | 0 | 1 | 1 | 2 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/41#issuecomment-6306966220) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532828639) |
| [shuvendu-lahiri/litebox#40](https://github.com/shuvendu-lahiri/litebox/pull/40) | Staged NFV audit \- change 1651: Spin before sleeping and skip needless wakes on the broker control ring | Published | 10 | 0 | 5 | 1 | 4 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/40#issuecomment-6306958335) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532825730) |
| [shuvendu-lahiri/litebox#45](https://github.com/shuvendu-lahiri/litebox/pull/45) | Staged NFV audit \- change 1623: Cherry\-pick "Fix the failure handling of non\-page\-sized memory allocation" | Published | 8 | 0 | 2 | 1 | 5 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/45#issuecomment-6306907644) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532695234) |
| [shuvendu-lahiri/litebox#46](https://github.com/shuvendu-lahiri/litebox/pull/46) | Staged NFV audit \- change 1621: Fix delayed SIGCHLD after wait4 returns ECHILD | Published | 4 | 0 | 0 | 2 | 2 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/46#issuecomment-6306751843) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532813376) |
| [shuvendu-lahiri/litebox#36](https://github.com/shuvendu-lahiri/litebox/pull/36) | Replay change 1040: Migrate Tar\-RO file system to new backend | Published | 10 | 0 | 8 | 1 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/36#issuecomment-6297309950) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39462655079) |
| [shuvendu-lahiri/litebox#34](https://github.com/shuvendu-lahiri/litebox/pull/34) | Replay change 1078: Normalize objdump snapshot output | Published | 4 | 0 | 2 | 1 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/34#issuecomment-6296136265) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39456543041) |
| [shuvendu-lahiri/litebox#31](https://github.com/shuvendu-lahiri/litebox/pull/31) | Replay change 1272: Cherry pick change 1110 Fix checking of directory search/read perms | Published | 9 | 0 | 9 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/31#issuecomment-6295515250) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39447927739) |
| [shuvendu-lahiri/litebox#28](https://github.com/shuvendu-lahiri/litebox/pull/28) | Replay change 1279: Stabilize broker TCP client test | Published | 1 | 0 | 1 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/28#issuecomment-6293319969) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39437995772) |
| [shuvendu-lahiri/litebox#23](https://github.com/shuvendu-lahiri/litebox/pull/23) | Replay change 1301: Sync ulitebox to latest main | Published | 10 | 0 | 4 | 6 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/23#issuecomment-6292062542) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39422364492) |
| [shuvendu-lahiri/litebox#22](https://github.com/shuvendu-lahiri/litebox/pull/22) | Replay change 1448: Unseal file system \`Backend\` | Published | 4 | 0 | 4 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/22#issuecomment-6291042276) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39421605628) |
| [shuvendu-lahiri/litebox#19](https://github.com/shuvendu-lahiri/litebox/pull/19) | Replay change 1469: Fixups for Rust 1\.99\.0 | Published | 10 | 0 | 8 | 1 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/19#issuecomment-6290757106) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39416362695) |
| [shuvendu-lahiri/litebox#21](https://github.com/shuvendu-lahiri/litebox/pull/21) | Replay change 1452: Add fallible backend constructors to ComposerBuilder mounts | Published | 2 | 0 | 2 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/21#issuecomment-6290668756) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39419250767) |
| [shuvendu-lahiri/litebox#20](https://github.com/shuvendu-lahiri/litebox/pull/20) | Replay change 1453: Add a ratchet test limiting pub use | Published | 1 | 0 | 0 | 0 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/20#issuecomment-6290330639) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39417204232) |
| [shuvendu-lahiri/litebox#12](https://github.com/shuvendu-lahiri/litebox/pull/12) | Replay change 1642: Cherry pick change 1385 Fix O\_PATH branch returns | Published | 8 | 0 | 8 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/12#issuecomment-6289783848) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39411981934) |
| [shuvendu-lahiri/litebox#11](https://github.com/shuvendu-lahiri/litebox/pull/11) | Replay change 1643: Cherry pick change 1386 Directory write check logic sits better in shim | Published | 1 | 0 | 1 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/11#issuecomment-6289345973) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39409808199) |
| [shuvendu-lahiri/litebox#9](https://github.com/shuvendu-lahiri/litebox/pull/9) | Replay change 1647: Cherry pick change 1558 Minor error cleanup for \`NoSearchPerms\` | Published | 10 | 0 | 8 | 1 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/9#issuecomment-6289057416) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39405410051) |
| [shuvendu-lahiri/litebox#7](https://github.com/shuvendu-lahiri/litebox/pull/7) | Replay change 1657: Cherry pick change 1566 Add support for symlink resolution | Published | 10 | 0 | 8 | 1 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/7#issuecomment-6288438653) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39399231191) |
| [shuvendu-lahiri/litebox#15](https://github.com/shuvendu-lahiri/litebox/pull/15) | Replay change 1533: Use try\_update instead of deprecated fetch\_update for atomics | Published | 7 | 0 | 6 | 0 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/15#issuecomment-6283835919) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39370711394) |
| [shuvendu-lahiri/litebox#14](https://github.com/shuvendu-lahiri/litebox/pull/14) | Replay change 1538: Implement LocalFs backend | Published | 10 | 0 | 9 | 0 | 1 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/14#issuecomment-6283484987) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39366637569) |
| [shuvendu-lahiri/litebox#13](https://github.com/shuvendu-lahiri/litebox/pull/13) | Replay change 1539: Introduce \`LocalFs\` mounting to CLI | Published | 7 | 0 | 4 | 0 | 3 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/13#issuecomment-6282967620) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39363406105) |
| [shuvendu-lahiri/litebox#10](https://github.com/shuvendu-lahiri/litebox/pull/10) | Replay change 1646: Cherry pick change 1548 Reject O\_CREAT \| O\_EXCL before backend open | Published | 3 | 0 | 3 | 0 | 0 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/10#issuecomment-6282208977) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39358987665) |
| [shuvendu-lahiri/litebox#4](https://github.com/shuvendu-lahiri/litebox/pull/4) | Replay change 1641: implement partial backend walks | Published | 10 | 0 | 7 | 1 | 2 | [Report](https://github.com/shuvendu-lahiri/litebox/pull/4#issuecomment-6261868399) / [run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39209801291) |
| [shuvendu-lahiri/litebox#47](https://github.com/shuvendu-lahiri/litebox/pull/47) | Add LiteBox NFV audit dashboard | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39871498222) |
| [shuvendu-lahiri/litebox#37](https://github.com/shuvendu-lahiri/litebox/pull/37) | Staged NFV audit \- change 1676: Plausible results for statfs | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39532837030) |
| [shuvendu-lahiri/litebox#29](https://github.com/shuvendu-lahiri/litebox/pull/29) | Replay change 1278: Cherry pick change 1113 Migrate 9p file system to new backend | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39440128194) |
| [shuvendu-lahiri/litebox#26](https://github.com/shuvendu-lahiri/litebox/pull/26) | Replay change 1282: Cherry pick change 1195 Switch layered to overlay filesystem | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39431692418) |
| [shuvendu-lahiri/litebox#25](https://github.com/shuvendu-lahiri/litebox/pull/25) | Replay change 1284: Cherry pick change 1226 Retire legacy \`FileSystem\` trait | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39430657719) |
| [shuvendu-lahiri/litebox#18](https://github.com/shuvendu-lahiri/litebox/pull/18) | Replay change 1470: Bump SNP and LVBS nightly toolchains | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39415165751) |
| [shuvendu-lahiri/litebox#17](https://github.com/shuvendu-lahiri/litebox/pull/17) | Replay change 1672: Route chmod syscalls | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39415165794) |
| [shuvendu-lahiri/litebox#8](https://github.com/shuvendu-lahiri/litebox/pull/8) | Replay change 1648: Cherry pick change 1564 Refactor to remove \`litebox::path::Arg\` | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39357363330) |
| [shuvendu-lahiri/litebox#6](https://github.com/shuvendu-lahiri/litebox/pull/6) | Replay change 1671: Route chown syscalls | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39397856512) |
| [shuvendu-lahiri/litebox#3](https://github.com/shuvendu-lahiri/litebox/pull/3) | Replay change 1640: replace procfd special cases with filesystem symlinks | No published report (failure) | - | - | - | - | - | [Run](https://github.com/shuvendu-lahiri/litebox/actions/runs/39390206732) |

## Conditional model refutations

The following property texts are extracted from the published reports, without new adjudication or inference. The original report contains assumptions, source overlays and native evidence.

### shuvendu-lahiri/litebox#38 / P4

It is expected that when neither a pending launch nor a virtual init exists, associate follows the legacy root path: it creates no broker process during association, returns an Association marked as not launched with an empty process cell, and places no pending launch in its New state\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/38#issuecomment-6307252325)

### shuvendu-lahiri/litebox#43 / P10

After the thunk returns and before trampoline returns to its caller, the function is expected to zero all VAULT\_STACK\_SIZE bytes beginning at VAULT\_STACK\_BOTTOM, restore the caller's stack pointer and CR3, replace VTL1 extended state with the saved user state or initialization state, zero the listed caller\-saved general\-purpose registers, and perform the configured CPU\-buffer clearing operation\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/43#issuecomment-6307191865)

### shuvendu-lahiri/litebox#42 / P8

After the selected vault\-abort path completes, the hypothesized behavior is to print exactly the supplied static panic location only when the location pointer is non\-null, print no location when it is null, and in either case finish by transferring control to VTL0 rather than returning\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/42#issuecomment-6307056163)

### shuvendu-lahiri/litebox#35 / P2

Assuming argv\_len \+ env\_len does not overflow and the declared region is within argv\_and\_env, argument parsing is expected to walk consecutive NUL\-terminated strings by their encoded byte lengths, classify strings whose starting offset is below argv\_len as argv and the remainder as envp, and use the first argv string as the UTF\-8 program path\. A missing NUL, an empty argv list, or a non\-UTF\-8 first argument makes parsing fail and causes invalid\-parameter termination rather than continuing startup\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/35#issuecomment-6297535430)

### shuvendu-lahiri/litebox#35 / P10

For every handle\_page\_fault error not recovered through a kernel\-space exception\-table fixup—including non\-AccessError errors, AccessError at a user\-space instruction pointer, and AccessError with no matching fixup—page\_fault\_handler invokes platform termination with SM\_SEV\_TERM\_SET and SM\_TERM\_EXCEPTION\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/35#issuecomment-6297535430)

### shuvendu-lahiri/litebox#33 / P6

For a valid readable non\-path file descriptor whose backend read succeeds, the read offset is zero for non\-seekable or zero\-position handles, and is the explicit offset or current descriptor position for position\-based handles\. The stored position advances by the number of bytes read only for a position\-based read without an explicit offset; explicit\-offset reads and other seek behaviors leave it unchanged\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/33#issuecomment-6296426613)

### shuvendu-lahiri/litebox#32 / P3

For a valid directory handle and supported flags, requesting WRONLY or RDWR triggers the writable\-directory workaround and emits a debug log rather than rejecting the directory merely because write access was requested\. Unless PATH is set, the function still returns AccessNotAllowed when the current user lacks any requested read or write permission; PATH bypasses those access checks, and otherwise a directory handle preserving the flags is returned\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/32#issuecomment-6295599807)

### shuvendu-lahiri/litebox#30 / P3

For a valid live descriptor whose table slot is occupied: if its shared entry is uniquely owned, call \`can\_close\_immediately\` once; when it returns true, mark the descriptor closed, remove the slot, and return \`Closed\` with the underlying subsystem entry, but when it returns false, restore the same slot, leave the descriptor open, and return \`Deferred\`\. If the entry has multiple strong owners, do not call the closure; mark the supplied descriptor closed, restore the shared entry in its slot, and return \`Duplicated\` containing a new descriptor for that same slot\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/30#issuecomment-6294367207)

### shuvendu-lahiri/litebox#27 / P7

For every socket type and blocking mode exercised by this helper, after spawning both receiver threads, the function waits for both receiver handles to finish before returning and propagates a panic from either receiver by panicking itself\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/27#issuecomment-6292943415)

### shuvendu-lahiri/litebox#24 / P3

For a non\-root missing target opened with CREAT after its parent is successfully resolved, open should return NoWritePerms without creating the file when the supplied context cannot change entries in that parent; otherwise it should request creation using the supplied mode and the supplied context's acting user as owner\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/24#issuecomment-6291911996)

### shuvendu-lahiri/litebox#2 / P3

For any VecDeque and any valid range with start &lt;= end &lt;= queue length, copy\_from\_queue returns the bytes in that logical queue range, in order and with length end \- start, including empty ranges and ranges crossing the deque's physical slice boundary, without modifying the queue\.

[Original report](https://github.com/shuvendu-lahiri/litebox/pull/2#issuecomment-6260871431)

## Refresh and validate

Requires Python 3.10+ and authenticated GitHub CLI read access. From the repository root:

```text
python nfv_reports/refresh.py
python -m unittest discover -s nfv_reports -p test_refresh.py
python nfv_reports/refresh.py --check
```

Refresh reads PR metadata, issue comments and reviewer workflow runs. It never checks out PR heads, executes PR code, launches audits or changes proof acceptance. Malformed report counts fail refresh explicitly. Code blocks are excluded when reading outcome labels; Markdown and HTML output treat PR content as data.

Only non-skipped reviewer attempts and published reports are included. Skipped-only setup PRs are excluded. Workflow attempts include reruns without counting PRs or property outcomes twice. A report for an older head is labeled. Counts are published outcomes, not new proof validation; comment hashes are snapshot provenance, not authentication or semantic proof.

Visual layout reference: [CoZ3 NFV dashboard](https://github.com/Z3Prover/coz3/blob/main/nfv_dashboard.html). No CoZ3 audit data or adjudication results are used here.
