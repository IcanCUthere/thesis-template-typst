#import "/utils/todo.typ": TODO

= Introduction
#TODO[
  Introduce the topic of your thesis, e.g. with a little historical overview.
]
Artemis is a learning platform widely used in higher education to support programming education through interactive exercises and automatic assessment #cite(<Krusche2018284>). The platform integrates with version-controlled repositories and continuous integration systems, and recent releases add large language model (LLM) features. Through Iris, the integrated LLM-based chatbot, students can receive explanations and guidance while solving exercises #cite(<Bassner2024394>).

Artemis now supports instructors and editors with AI-assisted review workflows. Each programming exercise consists of a problem statement, a template, a solution, and tests, and these artifacts must remain consistent. Artemis can query an LLM for a consistency check and receive structured JavaScript Object Notation (JSON) that describes each consistency issue, its severity, and a suggested fix description. This thesis uses the term *consistency issue* for one detected mismatch.

== Problem
#TODO[
  Describe the problem that you like to address in your thesis to show the importance of your work. Focus on the negative symptoms of the currently available solution.
]
Artemis already uses LLMs to generate exercises, but review and refinement still rely on manual work. Instructors and editors can run a consistency check, yet Artemis only shows the result as formatted JSON. They must interpret each entry, locate the affected files and lines, and apply corrections manually.

This workflow consumes time, introduces avoidable errors, and scales poorly for complex exercises. Artemis also lacks a persistent review comment system for consistency issues, so teams cannot track issue history reliably across exercise versions.

When the page reloads or the exercise version changes, Artemis discards detected consistency issues and forces users to rerun the check. This repeated effort pulls instructors and editors away from pedagogical improvements and makes consistent quality harder to maintain.

Students depend on coherent exercises for effective learning. Mismatches between the problem statement, template, solution, and tests can confuse students, increase cognitive load, and weaken learning outcomes.

== Motivation
#TODO[
  Motivate scientifically why solving this problem is necessary. What kind of benefits do we have by solving the problem?
]
An interactive and persistent workflow can turn static LLM output into actionable feedback. Inline review comments and structured overviews help instructors and editors identify and prioritize consistency issues quickly. Persistent storage keeps review progress available across sessions and exercise versions.

Suggested code changes further reduce manual editing effort. Instructors and editors can preview and apply changes directly in the exercise editor while retaining full control over final decisions.

These improvements let instructors and editors focus on pedagogical refinement instead of repetitive consistency checks. Students benefit indirectly through clearer and more coherent exercises that support focused problem solving and conceptual understanding.

== Objectives
#TODO[
  Describe the research goals and/or research questions and how you address them by summarizing what you want to achieve in your thesis, e.g. developing a system and then evaluating it.
]
The thesis defines concrete objectives that guide the implementation. Each objective targets a key improvement for exercise creation: persistent consistency checks, direct integration of suggested code changes, and intuitive support for human-in-the-loop review. The objectives are:
+ Add Inline Comments and Navigation Options
+ Implement Persistent Storage and Collaboration
+ Propose Inline Code Improvements

=== Add Inline Comments and Navigation Options

The first goal enhances how Artemis presents consistency check results and makes them directly actionable. Artemis currently shows only raw JSON from the LLM request, so instructors and editors must interpret the output manually. The improved interface shows the findings as inline comments in the editor and gives immediate context during review.

Each comment describes the consistency issue, provides a fix rationale, and marks affected lines with a severity level. When instructors and editors rerun a consistency check, Artemis updates existing comments, removes resolved findings, and keeps the displayed feedback aligned with the current exercise state.

A dropdown overview summarizes all detected consistency issues. Instructors and editors can inspect severity, affected files, and line ranges, and they can filter or sort by severity, component, or issue category. This overview supports faster prioritization and clearer tracking of resolved and unresolved work.

=== Implement Persistent Storage and Collaboration

The next goal extends Artemis data management with persistent storage for consistency issues and LLM-generated fix suggestions. Artemis currently keeps detected consistency issues only in the active client session after a consistency check.

The server-side model adds a dedicated entity for consistency issues and links each entry to the exercise, file, and exercise version. Artemis stores the description, severity, category, suggested fix description, affected line range, and timestamps so users can query and restore findings later.

This goal also adds collaborative review support. Multiple instructors and editors can review the same exercise in parallel without overwriting each other's comments. A synchronization mechanism propagates consistency-issue status changes, and conflict handling prevents race conditions, for example when two users try to resolve the same consistency issue simultaneously.

=== Propose Inline Code Improvements

The third goal extends Artemis from detecting consistency issues to supporting resolution through suggested inline code changes. Each consistency check can return structured modification proposals in addition to consistency-issue descriptions. Each suggested code change defines a file path, an affected line range, and a replacement snippet. Artemis stores this data with the consistency issue so the editor can present side-by-side previews.

The workflow lets instructors and editors apply or discard suggested changes directly in the editor. When a user accepts a change, Artemis updates the file and creates a new exercise version. Validation and conflict checks ensure that each suggested code change still matches the current file state. This approach reduces repetitive editing and keeps human review focused on conceptual correctness.

== Outline
#TODO[
  Describe the outline of your thesis
]
This thesis is structured in six chapters. Chapter 1 introduces the context of AI-assisted review in Artemis, defines the problem, and formulates the objectives. Chapter 2 presents technical and conceptual background. Chapter 3 positions the work in related research on human-in-the-loop education and AI-assisted review.

Chapter 4 analyzes requirements for a persistent review comment system, including functional requirements, quality attributes, constraints, and models. Chapter 5 develops the system architecture with design goals, subsystem decomposition, persistence, and access control. Chapter 6 summarizes the implementation status, discusses contributions, and outlines future work.
