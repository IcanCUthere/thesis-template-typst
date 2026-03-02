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

== Hyperion and Consistency Checking
#TODO[
  Describe how large language models are used to detect inconsistencies in multi-file artifacts, typical strengths/limitations, and why human review remains necessary.
]
In Artemis, AI-assisted authoring is bundled in the Hyperion module. Hyperion supports several instructor/editor workflows, including problem-statement generation and refinement, FAQ rewriting, code-generation support, and consistency checks for programming exercises. In this thesis, the relevant part is the consistency-check workflow.

When a consistency check is triggered, Artemis sends the exercise context to Hyperion. Hyperion builds a stable snapshot of the relevant artifacts and runs complementary checks for structural and semantic mismatches. The result is returned as structured issues with severity, category, location, and suggested fix information, which can be mapped to concrete editor locations. The design aims for practical robustness: irrelevant files are filtered, checks are combined from multiple analysis steps, and partial failures degrade gracefully instead of aborting the whole request. This approach helps detect inconsistencies that are difficult to catch with purely syntactic tooling, especially when specification text and code must be interpreted together. At the same time, Hyperion outputs remain proposals rather than final decisions, so human review is required before changes are accepted.

== Human-in-the-Loop in Machine Learning
#TODO[
  Introduce human-in-the-loop workflows in educational systems, focusing on instructor oversight, accountability, and quality assurance for AI-assisted outputs.
]
Human-in-the-loop (HITL) describes AI-supported workflows in which human experts remain part of the decision process #cite(<Mosqueira-Rey20233005>). Instead of automatically applying model output, the system presents proposals that users review, adapt, and approve in context. In educational settings, this is especially relevant when outputs affect teaching material or assessment quality, and recent studies report practical benefits when instructor moderation is built into the workflow #cite(<Xu2025469>) #cite(<Kituku2025>).

For programming exercises in Artemis, HITL is critical because small inconsistencies across the problem statement and repositories can have disproportionate impact: they can change what is assessed, introduce hidden requirements, or create confusion when tests and specification diverge. A practical HITL design must therefore make instructor/editor verification easy. This requires precise localization (which file and where), a clear rationale for why something is considered inconsistent, and a workflow that supports explicit decisions (e.g., accept, dismiss, resolve) without silently changing exercise content.

This thesis follows the HITL paradigm by turning LLM consistency findings into review threads that instructors and editors can act on directly. The system integrates AI proposals into a familiar review workflow with persistent threads, resolution states, and safe application of suggested code changes. Instructors and editors remain responsible for the final outcome, while the system reduces the mechanical effort of identifying, tracking, and navigating inconsistencies.

== Review Comment Systems
#TODO[
  Explain the concept of review comments, inline annotations, resolution states, and why such systems provide a foundation for persistent issue tracking.
]
Review comment systems provide a structured way to discuss and track issues in documents and code that change over time. In modern code review, an author submits a change and other developers review it asynchronously in tool-supported workflows, using inline comments and discussion before deciding whether the change is accepted, rejected, or reworked #cite(<Davila2021>). Instead of showing findings only once, the system stores this discussion as threads linked to concrete locations (e.g., file and line range), which supports communication, coordination, and shared understanding in addition to defect detection #cite(<Davila2021>).

A key feature of review systems is state. Threads are typically marked as open or resolved, enabling reviewers to separate active work from completed decisions and to measure progress. In line with modern code-review practice, such explicit states are important to coordinate work across participants and keep review status visible #cite(<Davila2021>). In AI-assisted workflows, state is also needed to distinguish between issues that have been accepted and fixed, those that have been deliberately dismissed, and those that need to be checked again after content changes. The concept of an \"outdated\" thread is particularly useful when thread references are tied to line content: if the surrounding content changes, the system can warn that the original context may no longer apply and ask reviewers to revisit the thread.

For the scope of this thesis, review comments provide the foundation for turning consistency checking into an actionable workflow. They enable persistent storage of detected issues, integrate manual instructor and editor feedback and AI-generated findings into a unified interface, and provide a clear record of what was changed and why. This is essential for exercise development over time, where the cost of repeatedly interpreting raw tool output would otherwise remain high.
