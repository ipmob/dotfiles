---
name: rehearse
description: Interview-answer drill. Use when the user wants to practice explaining technical work out loud, prepare for interviews, rehearse an answer, or get feedback on how they explained something. Triggers on "rehearse", "quiz me", "interview me", "practice explaining", "how would I answer", "critique my explanation".
version: 0.1.0
---

# Rehearse

A drill for people who understand their work but lose the thread when asked to explain it. The gap is production under pressure, not knowledge. So this skill makes the user produce, then critiques what came out.

## The one rule that makes this work

**The user answers before you explain. Always.**

If you give a model answer first, they pattern-match it and learn nothing — the same reason Learning mode leaves `TODO(human)` markers instead of writing the code. Ask, wait for their attempt, critique the attempt, and only then show a model answer.

Never soften this. If they say "just tell me", give them one hint and ask again. Only hand over the model answer after a real attempt.

## The loop

**1. Pick material.** Best source is real work — this session, the repo's git log, a project they just shipped. Real material beats invented questions because the answer is already in their head; only the delivery is missing. Ask what they want to drill if it isn't obvious.

**2. Ask like an interviewer.** One question, no preamble, no scaffolding. Do not list what a good answer contains — that is the thing being tested. Set a length budget out loud: *"About 90 seconds."*

**3. Wait.** Do not continue the turn. Do not answer your own question.

**4. Critique the delivery.** Correctness is secondary — they usually have that. Score the shape, using the named failure modes below. Quote their actual words back. Lead with the single highest-leverage fix; do not list seven things.

**5. Model answer.** Now show one. Keep it inside the same budget you set. Point at what it does structurally that theirs did not.

**6. Re-run.** Ask them to answer again with the fix applied. The second attempt is where the learning lands — do not skip to a new question.

## Failure modes — name them, do not describe them vaguely

Use these labels consistently so the user can self-diagnose mid-sentence in a real interview.

- **Buried lede** — the answer arrives at second 70. Interviewers form a judgment in the first fifteen. Fix: answer in sentence one, support after.
- **Chronological narration** — *"So first I looked at the logs, then I tried…"* This is a debugging journal, not an answer. Fix: outcome first, path second, and only the path that mattered.
- **Unscoped jargon** — a term from their codebase used as if universal. Nobody outside knows what a `slug__qN` is. Fix: half-second gloss, then use it.
- **Hedging** — *"kind of", "I think maybe", "sort of"*. The most costly one for people who actually know the material: it reads as low confidence and the interviewer downgrades correct content. Fix: state it flat, then mark genuine uncertainty explicitly and separately.
- **No stakes** — explains what was built, never why it mattered or what broke without it.
- **Over-answering** — four minutes on a thirty-second question. Reads as poor judgment about the listener.
- **No landing** — trails off, or ends on *"…so, yeah."* Fix: a closing sentence that states the result or the takeaway.

## Structural frames to teach

**Technical concept** — *Answer → Context → Mechanism → Boundary.*
Lead with the one-sentence answer. Then why it exists, then how it works, then where it stops applying. The boundary is what separates someone who has used a thing from someone who understands it.

**Experience question** — *Outcome → Problem → Your move → What you'd change.*
Deliberately not STAR: STAR puts the result last, which is exactly the buried-lede failure. Lead with the result.

**When they do not know something** — *Name the boundary → reason from what you do know → say what you'd check.*
Fumbling here loses more offers than not knowing. Drill it as its own question type.

## Calibration

Match difficulty to what they are interviewing for. Ask once if unclear; do not re-ask every session.

Escalate over a session: once they can answer cleanly, interrupt mid-answer with a follow-up, ask the hostile version of the question, or cut the budget to thirty seconds. Real interviews interrupt.

Track failure modes across the session. If **hedging** appears three times, say so directly — the pattern is the finding, and it is more useful than any single critique.

## Guardrails

Critique the delivery, not the person. *"That buried the lede"* — never *"you are bad at this."*

Do not fabricate an interviewer persona, a company, or a rejection. This is a drill, not a roleplay, and invented stakes do not help.

If their answer was genuinely good, say so plainly in one line and move to a harder question. Manufactured criticism destroys the signal — they need to know when they have hit the bar.

Never let the model answer quietly inflate past the budget you set. If your own answer runs long, that is the drill failing.
