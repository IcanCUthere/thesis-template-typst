#import "/utils/todo.typ": TODO

= Background
#TODO[
  Describe each proven technology / concept shortly that is important to understand your thesis. Point out why it is interesting for your thesis. Make sure to incorporate references to important literature here.
]

This chapter introduces the background concepts needed to understand the problem space and the design decisions of the proposed system. It first summarizes Artemis, the relevant roles for this thesis, and the structure of programming exercises. It then explains LLM-based consistency checking and why it benefits from human oversight. Finally, it motivates persistent, review-style workflows as a practical interface between automated consistency-issue detection and instructor decision-making.

== Artemis, Roles and the Exercise Model
#TODO[
  Summarize Artemis as a learning platform and explain the structure of programming exercises (problem statement, template, solution, tests). Highlight why consistency across these artifacts matters for grading and learning.
]
Artemis is a learning platform for programming education that combines interactive exercises with automatic assessment and continuous feedback #cite(<Krusche2018284>). In Artemis, programming exercises use a set of artifacts that specify the task and its assessment. Concretely, each programming exercise consists of a problem statement and a set of version-controlled repositories: a template repository that provides starter code and the interface that students implement, a solution repository that contains the reference implementation, and a test repository that encodes the executable grading criteria #cite(<Dietrich2025>). Depending on the exercise and course setup, course teams can attach additional auxiliary repositories. Consistency across these artifacts matters because consistency issues can confuse learners and can distort assessment outcomes #cite(<Dietrich2025>).

Artemis uses roles to decide who can do what in different situations, for example when editing exercises or discussing consistency issues. The most relevant roles in this thesis are:
- Admins: manage the platform globally and can override course-level restrictions when needed.
- Instructors: create and configure exercises, and can also perform editor-level review actions.
- Editors: modify exercise content and work with consistency-review threads.
- Students: solve exercises and view student-facing content, but are not part of the review workflow.

== Hyperion and Consistency Checking
#TODO[
  Describe how large language models are used to detect consistency issues in multi-file artifacts, typical strengths/limitations, and why human review remains necessary.
]
In Artemis, the Hyperion module bundles AI-assisted authoring features. Hyperion supports several instructor/editor workflows, including problem-statement generation and refinement, rewriting of frequently asked questions (FAQs), code-generation support, and consistency checks for programming exercises. Prior work documents the consistency-check workflow in detail #cite(<Dietrich2025>). This thesis follows up on this workflow.

When a consistency check is triggered, Artemis sends the exercise context to Hyperion. Hyperion builds a snapshot of relevant artifacts and runs checks for structural and semantic consistency issues #cite(<Dietrich2025>). Hyperion returns structured consistency issues with severity, category, location, and suggested-fix information. Hyperion filters irrelevant files, combines multiple analysis steps, and handles partial failures without aborting the whole request. This approach detects cross-artifact consistency issues that syntax-only tooling often misses, because it compares specification meaning with code and test behavior #cite(<Dietrich2025>). For example, Hyperion can flag cases where the problem statement specifies one behavior but the template or tests enforce another. Hyperion outputs remain proposals, and instructors or editors decide what to do with it.

== Human-in-the-Loop in Machine Learning
#TODO[
  Introduce human-in-the-loop workflows in educational systems, focusing on instructor oversight, accountability, and quality assurance for AI-assisted outputs.
]
Human-in-the-loop (HITL) describes AI-assisted workflows in which human experts remain part of the decision process #cite(<Mosqueira-Rey20233005>). Instead of automatically applying model output, the system presents proposals that users review, adapt, and approve in context. In educational settings, this is especially relevant when outputs affect teaching material or assessment quality, and recent studies report practical benefits when instructor moderation is built into the workflow #cite(<Xu2025469>) #cite(<Kituku2025>).

For programming exercises in Artemis, HITL is critical because small consistency issues across the problem statement and repositories can have disproportionate impact: they can change what is assessed, introduce hidden requirements, or create confusion when tests and specification diverge #cite(<Dietrich2025>). A practical HITL design must therefore make instructor/editor verification easy. This requires precise localization (which file and where), a clear rationale for why something is considered a consistency issue, and a workflow that supports explicit decisions (e.g., accept, dismiss, resolve) without silently changing exercise content.

== Review Thread Systems
#TODO[
  Explain the concept of review threads, inline annotations, resolution states, and why such systems provide a foundation for persistent issue tracking.
]
Review thread systems provide a structured way to discuss and track issues in documents and code that change over time. In modern code review, an author submits a change and other developers review it asynchronously in tool-supported workflows, using inline comments and discussion before deciding whether the change is accepted, rejected, or reworked #cite(<Davila2021>). Instead of showing issues only once, the system stores this discussion as threads linked to concrete locations (e.g., file and line range), which supports communication, coordination, and shared understanding in addition to defect detection #cite(<Davila2021>).

A key feature of review systems is state. Reviewers mark threads as open or resolved, which helps teams separate active work from completed decisions and measure progress. Modern code-review practice relies on these explicit states to coordinate participants and keep review status visible #cite(<Davila2021>). In AI-assisted workflows, teams also use state to distinguish accepted and fixed issues, deliberately dismissed issues, and issues that require rechecking after content changes. The concept of an \"outdated\" thread is particularly useful when thread references are tied to line content: if surrounding content changes, the system can warn that original context may no longer apply and ask reviewers to revisit the thread.
