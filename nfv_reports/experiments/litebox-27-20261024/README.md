# LiteBox PR 27: experimental NFV audit

A fresh, trusted, local NFV audit of the immutable PR head, followed by bounded shorter-property and candidate-fix experiments on accepted refutations.

The historical-p7 directory separately preserves and rechecks the earlier finding for a controlled comparison. It is not an additional finding in the freshly extracted property set and is not counted twice.

**All results are conditional on the translated models and their assumptions. They are not confirmed source bugs, source-verified fixes, or a proof of global minimality.**

The baseline models and properties are kept whole and unchanged. A separate entailment proof and negative proof check each shorter display claim. A repair must prove the full original goal, preserve assumptions/interfaces/helpers, and pass input-domain and original-witness checks. Source patches are suggestions, not applied or compiled source.

The audit/report.json and audit/bundle.json files retain accepted proof and source data. The followups directory contains candidate patches and all seven verifier checks per attempt. Dafny models can be inspected as data or replayed with Dafny 4.11.0. Never execute inspected PR source to replay these checks.

Public export omits authentication metadata and makes operational diagnostic/evidence paths relative; models, goals, assumptions, witnesses and captured source are unchanged. Model prompts, account information and inference transcripts are not published. A refreshed presentation artifact, if present, is hash-bound to this exported copy. Artifact hashes establish provenance, not semantic equivalence or authentication.
