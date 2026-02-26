#import "/utils/todo.typ": TODO

= Background
#TODO[
  Describe each proven technology / concept shortly that is important to understand your thesis. Point out why it is interesting for your thesis. Make sure to incorporate references to important literature here.
]

This chapter introduces the background concepts needed to understand the problem space and the design decisions of the proposed system. It first summarizes Artemis, the relevant roles for this thesis, and the structure of programming exercises. It then explains LLM-based consistency checking and why it benefits from human oversight. Finally, it motivates persistent, review-style workflows as a practical interface between automated issue detection and instructor decision-making.

== Artemis, Roles and the Exercise Model
#TODO[
  Summarize Artemis as a learning platform and explain the structure of programming exercises (problem statement, template, solution, tests). Highlight why consistency across these artifacts matters for grading and learning.
]
Artemis is a learning platform for programming education that combines interactive exercises with automatic assessment and continuous feedback #cite(<Krusche2018284>). In Artemis, programming exercises are defined through a set of artifacts that specify the task and its assessment. Concretely, each programming exercise consists of a problem statement and a set of version-controlled repositories: a template repository that provides starter code and the interface students are expected to implement, a solution repository that contains the reference implementation, and a test repository that encodes the executable grading criteria. Depending on the exercise and course setup, additional auxiliary repositories can be attached.

Artemis uses roles to decide who can do what in different situations, for example when editing exercises or discussing consistency issues. The most relevant roles in this thesis are:
- Admins: manage the platform globally and can override course-level restrictions when needed.
- Instructors: create and configure exercises, and can also perform editor-level review actions.
- Editors: modify exercise content and work with consistency-review threads.
- Students: solve exercises and view student-facing content, but are not part of the review workflow.

== LLM-Based Consistency Checking
#TODO[
  Describe how large language models are used to detect inconsistencies in multi-file artifacts, typical strengths/limitations, and why human review remains necessary.
]
Large language models (LLMs) can process natural language and source code and are therefore well suited to detect semantic mismatches across mixed artifacts such as problem statements, templates, solutions, and tests. In a consistency-checking workflow, the system provides the relevant artifacts (or excerpts) to the model and asks it to identify potential inconsistencies, classify them, and propose concrete fixes. The output is often structured (e.g., as JSON) so that downstream components can render findings, link them to affected files and lines, and attach additional metadata such as severity or category.

The strengths of LLM-based checking lie in its ability to relate text and code, recognize common educational patterns, and flag issues that would otherwise require careful cross-reading. This includes mismatches in terminology, missing edge cases implied by the specification, and discrepancies between declared interfaces and their usage in tests. Unlike purely syntactic tooling, LLMs can also explain why a mismatch matters and suggest a repair that aligns artifacts at the level of intent.

At the same time, LLM outputs are not inherently authoritative. Models can miss relevant constraints, overgeneralize from patterns, or produce plausible but incorrect suggestions. In addition, the effective context window is limited, and the model's conclusions can depend on how artifacts are selected, summarized, and prompted. For these reasons, the system must treat LLM findings as proposals rather than as ground truth. Instructor review remains necessary to ensure that any applied change preserves the pedagogical intent of the exercise and does not introduce new inconsistencies or regressions in assessment behavior.

== Human-in-the-Loop Review in Education
#TODO[
  Introduce human-in-the-loop workflows in educational systems, focusing on instructor oversight, accountability, and quality assurance for AI-assisted outputs.
]
Human-in-the-loop (HITL) review describes AI-assisted workflows that deliberately incorporate human judgment into the decision process. Instead of treating model output as an automated correction, the system proposes findings and potential fixes, while instructors and editors validate, refine, or reject them. This combination is especially relevant in educational settings, where automated outputs can influence assessment and learning outcomes. Prior work therefore emphasizes human oversight for LLM-based grading and feedback as well as for hint and assessment generation, both to improve quality and to maintain accountability #cite(<Xu2025469>) #cite(<Wolff2025897>) #cite(<Knipp2025379>) #cite(<Kituku2025>).

For programming exercises, HITL is critical because small inconsistencies across the problem statement and repositories can have disproportionate impact: they can change what is assessed, introduce hidden requirements, or create confusion when tests and specification diverge. A practical HITL design must therefore make instructor/editor verification easy. This requires precise localization (which file and where), a clear rationale for why something is considered inconsistent, and a workflow that supports explicit decisions (e.g., accept, dismiss, resolve) without silently changing exercise content.

This thesis follows the HITL paradigm by turning LLM consistency findings into review threads that instructors and editors can act on directly. The system integrates AI proposals into a familiar review workflow with persistent threads, resolution states, and safe application of suggested code changes. Instructors and editors remain responsible for the final outcome, while the system reduces the mechanical effort of identifying, tracking, and navigating inconsistencies.

== Review Comment Systems
#TODO[
  Explain the concept of review comments, inline annotations, resolution states, and why such systems provide a foundation for persistent issue tracking.
]
Review comment systems provide a structured way to discuss and track issues in evolving artifacts. Instead of treating findings as ephemeral output, a review system models issues as threads linked to a concrete location in a document (e.g., a file and line range) with one or more comments that capture rationale and discussion. This representation supports collaboration by allowing multiple instructors and editors to contribute context, propose alternatives, and converge on a decision.

A key feature of review systems is state. Threads are typically marked as open or resolved, enabling reviewers to separate active work from completed decisions and to measure progress. For AI-assisted workflows, state is also needed to distinguish between issues that have been accepted and fixed, those that have been intentionally dismissed, and those that require re-evaluation because the exercise has changed. The concept of an \"outdated\" thread is particularly useful when thread references are tied to line content: if the surrounding content changes, the system can warn that the original context may no longer apply and prompt reviewers to revisit the thread.

For the scope of this thesis, review comments provide the foundation for turning consistency checking into an actionable workflow. They enable persistent storage of detected issues, integrate manual instructor and editor feedback and AI-generated findings into a unified interface, and provide an auditable record of what was changed and why. This is essential for iterative exercise development, where artifacts evolve over time and where the cost of repeatedly re-interpreting raw tool output would otherwise remain high.
