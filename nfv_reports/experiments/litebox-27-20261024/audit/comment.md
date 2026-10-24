<!-- nfv-merged-pr:1d00686669b374d629f6da9259805565e21716678ccc0261a3ea7e06e69193e4 -->

[Neuro-formal verification (NFV)](https://arxiv.org/abs/2608.21516) selects nontrivial properties from PR intent and source, tries verification, then tries refutation.

# NFV: 0 refuted, 7 verified in PR #27

PR head `966b0986a08a`, base `e1be52d8cd71` · [run and evidence](https://github.com/shuvendu-lahiri/litebox/tree/0708b791c71c74d6a2bb505b1a7a79ce8940818e/nfv_reports/experiments/litebox-27-20261024)

**These are results for translated models under their stated assumptions, not proofs of source-code correctness or confirmed source bugs.**

refuted: 0 · verified: 7 · resources exhausted: 0 · type-check/audit failure: 0

### P1

**Intended property:** If the test reaches the point where the worker reports acquiring the released lock, it joins that worker before returning normally and propagates any worker panic via unwrap.

**Outcome: verified**

The property was verified for the translated model.

<details><summary>Verification details</summary>


**Quoted intention:** Join the spawned handles in tests

**Assumptions:** No additional input restrictions.

**Environment models:** Models worker.join\(\).unwrap\(\) as completing when the worker did not panic and propagating a panic when joining reports that the worker panicked.

**Checked property:**

```dafny
ensures reachedAcquiredReport ==> (joinCalled && (returnedNormally ==> joinCompleted) && (workerPanicked ==> workerPanicPropagated))
```

Evidence: `014e8b2efe1431f4a5ea/verification/model.dfy`; SHA-256 `33fc45535547282e4c4d6546feb9f5483d09395a2588d34ea2aa9bec05ef9117`.

The full verified Dafny is retained in the linked run artifact.

</details>

### P2

**Intended property:** On the normal cleanup path after spawning the writer-closing thread, the test waits for that thread to finish before returning, and fails if the spawned thread panicked.

**Outcome: verified**

The property was verified for the translated model.

<details><summary>Verification details</summary>


**Quoted intention:** Join the spawned handles in tests

**Assumptions:** No additional input restrictions.

**Environment models:** Reports, through an explicit abstract input, whether initialization, pipe creation, and descriptor conversion complete normally.; Creates the test thread unless the documented spawn panic occurs.; Reports, through an explicit abstract input, whether all operations after spawning and before cleanup complete normally.; Waits for the spawned thread and completes normally exactly when that thread did not panic.

**Checked property:**

```dafny
ensures (returnedNormally ==> waitedForCloser) && (spawned && closerPanicked ==> !returnedNormally)
```

Evidence: `207dccda08459f5c1b52/verification/model.dfy`; SHA-256 `7cb945258e48b45cc1049c08d25b6506bd9b7a42e7cddd731a932278f860a186`.

The full verified Dafny is retained in the linked run artifact.

</details>

### P3

**Intended property:** If execution reaches the final synchronization step, the test joins the spawned writer thread and returns normally only after that thread finishes without panicking; a writer-thread panic is propagated by unwrapping the join result.

**Outcome: verified**

The property was verified for the translated model.

<details><summary>Verification details</summary>


**Quoted intention:** Join the spawned handles in tests

**Assumptions:** No additional input restrictions.

**Environment models:** Exposes whether the omitted setup\_epoll operations complete normally.; Exposes whether pipe creation and its unwrap complete normally.; Exposes whether registering the pipe interest and unwrapping its result complete normally.; Exposes whether spawning the writer returns a join handle normally.; The writer eventually finishes and panics exactly when its write unwrap or equality assertion fails.; Exposes whether epoll wait and its unwrap complete normally.; Exposes whether the pipe read unwrap succeeds and whether the resulting two-byte buffer equals \[1, 2\].; Joining waits for writer termination and returns an error when the writer panicked.

**Checked property:**

```dafny
ensures finalSynchronizationReached ==> (writerJoined && writerFinished && (returnsNormally ==> !writerPanicked) && (writerPanicked ==> panicPropagated && !returnsNormally))
```

Evidence: `4fc93dcfef106054580f/verification/model.dfy`; SHA-256 `64276f847e8300006b7a081792fd4b6567079120c484b41f7689cd4b5629a407`.

The full verified Dafny is retained in the linked run artifact.

</details>

### P4

**Intended property:** If the writer thread is spawned, test\_poll must join it before returning normally; a panic in that thread must cause test\_poll to panic rather than silently succeed.

**Outcome: verified**

The property was verified for the translated model.

<details><summary>Verification details</summary>


**Quoted intention:** Join the spawned handles in tests

**Assumptions:** No additional input restrictions.

**Environment models:** Exposes whether the earlier portion of test\_poll completes without panic and reaches the writer-spawn suffix.; Models spawn\_clone\_for\_test as either panicking before creating a handle or spawning a thread with the supplied abstract panic outcome.; Models the post-spawn wait result; unwrap panics when the abstract result is an error.; Models the revents assertion as panicking unless the abstract observed event equals Events::IN.; Preserves the possibility that an omitted sys\_close implementation panics even though its return value is ignored.; Models writer.join\(\).unwrap\(\) as propagating a writer-thread panic to test\_poll.

**Checked property:**

```dafny
ensures (spawned ==> (returnedNormally ==> joined)) && (spawned && writerThreadPanics ==> testPanicked && !returnedNormally)
```

Evidence: `40c22d572f8495bce0ee/verification/model.dfy`; SHA-256 `f9a0da9e3ac344f81616d443a6da229318d1968c4c9b63883e6a1b64de4344ee`.

The full verified Dafny is retained in the linked run artifact.

</details>

### P5

**Intended property:** The test retains the spawned writer’s handle and, after the pipe operations and descriptor closes, waits for that writer to finish; it returns normally only if joining succeeds, so a writer-thread panic causes the test to panic.

**Outcome: verified**

The property was verified for the translated model.

<details><summary>Verification details</summary>


**Quoted intention:** Join the spawned handles in tests

**Assumptions:** No additional input restrictions.

**Environment models:** Returns the explicitly supplied outcome of an omitted operation, expect, conversion, allocation, or assertion stage.; Joining reports success exactly when the spawned writer thread did not panic; unwrapping failure prevents normal return.

**Checked property:**

```dafny
ensures (writerSpawned ==> writerRetained) && (closesCompleted ==> pipeOperationsCompleted && joinAttempted) && (joinAttempted ==> writerRetained && closesCompleted) && (normal ==> joinAttempted && joinSucceeded) && (writerSpawned && writerPanicked ==> !normal)
```

Evidence: `8015cf4ceb364a666cf5/verification/model.dfy`; SHA-256 `b9a99783d4faf359bcebefa1e43c25f650315e5c2255643637dcb5ba73f57722`.

The full verified Dafny is retained in the linked run artifact.

</details>

### P6

**Intended property:** After completing the server-side work, the test waits for the spawned client thread to finish before returning successfully; if that thread panics, the join is unwrapped and the test also panics.

**Outcome: verified**

The property was verified for the translated model.

<details><summary>Verification details</summary>


**Quoted intention:** Join the spawned handles in tests

**Assumptions:** No additional input restrictions.

**Environment models:** Represents whether task initialization and creation of the server socket complete without an unwrap panic.; Creates a client-thread handle unless spawning panics and exposes the otherwise undocumented eventual outcome of the captured client closure.; Represents whether all server-side accepts, receives, assertions, and socket closes complete successfully.; Models join\(\).unwrap\(\) as panicking exactly when the spawned client thread has panicked.

**Checked property:**

```dafny
ensures (returnedSuccessfully ==> serverWorkCompleted && clientJoined && joinAfterServerWork) && (serverWorkCompleted && clientPanicked ==> clientJoined && joinAfterServerWork && testPanicked)
```

Evidence: `53ea3d1a029c1794913a/verification/model.dfy`; SHA-256 `1705ac128e3264cb83ff1d9c820e745b13ad2bb413fa30d39184007322feaac0`.

The full verified Dafny is retained in the linked run artifact.

</details>

### P7

**Intended property:** If execution reaches thread cleanup and the first join succeeds, the function joins both spawned receiver handles before returning normally; a receiver panic detected by either executed join prevents normal return.

**Outcome: verified**

The property was verified for the translated model.

<details><summary>Verification details</summary>


**Quoted intention:** Join the spawned handles in tests

**Assumptions:** No additional input restrictions.

**Environment models:** Exposes whether all setup, communication, sleeps, socket closes, and other potentially panicking operations before the joins reach thread cleanup.; Models a receiver handle's join result as successful unless that receiver thread panicked; unwrap prevents normal continuation after failure.

**Checked property:**

```dafny
ensures ((reaches_cleanup && !receiver2_panicked) ==> (receiver2_joined && receiver1_joined)) && ((receiver2_joined && receiver2_panicked) ==> !normal_return) && ((receiver1_joined && receiver1_panicked) ==> !normal_return) && (normal_return ==> (reaches_cleanup && receiver2_joined && receiver1_joined))
```

Evidence: `8e730a90c242f5f89653/verification/model.dfy`; SHA-256 `de834229ec4bc8ce4f1e9e02171512e1538f4d29668de9c83770f9d43f7127a8`.

The full verified Dafny is retained in the linked run artifact.

</details>

<!-- gh-aw-workflow-id: nfv-pr-review -->