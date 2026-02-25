#import "/utils/todo.typ": TODO

= Introduction
#TODO[
  Introduce the topic of your thesis, e.g. with a little historical overview.
]
Artemis is a learning platform widely used in higher education to support programming education through interactive exercises and automatic assessment #cite(<Krusche2018284>). It integrates with version-controlled repositories and continuous integration systems and has recently been extended with large language models (LLMs). Through Iris, the integrated LLM-based chatbot, students can receive explanations and guidance while solving exercises #cite(<Bassner2024394>).

In addition to student support, Artemis also allows instructors and editors to use LLMs to review programming exercises. Each exercise consists of a problem statement, a template, a solution, and tests, which must remain consistent with each other. The system can query an LLM to detect inconsistencies and returns a structured JSON output describing each issue, its severity, and a suggested fix description.

== Problem
#TODO[
  Describe the problem that you like to address in your thesis to show the importance of your work. Focus on the negative symptoms of the currently available solution.
]
While Artemis already integrates LLMs to automatically generate new exercises, its support for reviewing and refining them is still limited. Instructors and editors can query an LLM to check for inconsistencies, but the results are returned only as formatted JSON. The output lists descriptions, severities, categories, and suggested fix descriptions, but it still does not present the information in a way instructors and editors can act on directly. Instead, they must manually interpret the entries, identify the affected files and lines, and apply corrections themselves.
This manual review process is time-consuming, error-prone, and does not scale well for complex exercises. In addition, Artemis does not yet provide a review comment system to persist issues across exercise versions, making it hard to track whether inconsistencies have been resolved or whether issues resurface in later iterations of the exercise.

This means that instructors and editors must spend a substantial amount of time manually interpreting raw JSON outputs, locating inconsistencies across multiple files, and reapplying checks when exercises evolve. This repetitive process diverts attention from pedagogical work and makes it harder to maintain a consistent standard across exercises.
Students, in turn, depend on well-structured and coherent exercises for effective learning. Inconsistencies between the problem statement, template, solution, and tests can cause confusion, increase cognitive load, and ultimately hinder their ability to achieve learning goals.

== Motivation
#TODO[
  Motivate scientifically why solving this problem is necessary. What kind of benefits do we have by solving the problem?
]
By transforming static LLM output into interactive, persistent, and actionable feedback, the review workflow becomes more efficient and transparent. Inline review comments and structured overviews help instructors and editors quickly identify and prioritize inconsistencies, while persistent storage ensures that progress is retained across sessions and exercise versions.
The introduction of automatic code suggestions enables instructors and editors to preview and apply fixes directly within the exercise editor. This reduces the need for manual editing while keeping instructors and editors fully in control of the final result.

For instructors and editors, this means being able to focus on refining the pedagogical aspects of exercises rather than on manual consistency checks. Collaboration features further support shared review workflows, enabling multiple instructors and editors to contribute simultaneously and maintain a consistent standard across courses.
Students benefit indirectly from these enhancements through more coherent, reliable exercises that better reflect the intended learning goals. With fewer inconsistencies and clearer task structures, they can focus more effectively on problem-solving and conceptual understanding.

== Objectives
#TODO[
  Describe the research goals and/or research questions and how you address them by summarizing what you want to achieve in your thesis, e.g. developing a system and then evaluating it.
]
To achieve these outcomes, the thesis defines concrete objectives that guide the implementation. Each objective addresses a key improvement for creating and maintaining programming exercises: providing persistent consistency checks, enabling direct integration of code changes, and offering intuitive support for human-in-the-loop review. The objectives are as follows:
+ Add Inline Comments and Navigation Options
+ Implement Persistent Storage and Collaboration
+ Propose Inline Code Improvements

=== Add Inline Comments and Navigation Options

The first goal is to enhance the interface for displaying consistency check results and make them directly actionable. Currently, Artemis only shows the raw JSON returned by the LLM request, which instructors and editors must interpret manually. The improved interface visualizes this data as inline comments within the text editor, giving instructors and editors immediate context while reviewing an exercise.

Each comment clearly describes the identified issue, explains how it can be resolved, and indicates the affected lines of code, along with its severity level to help instructors and editors prioritize their actions. When instructors and editors rerun a consistency check, the interface automatically updates existing comments to reflect new results or remove resolved ones, ensuring that the displayed feedback always matches the current state of the exercise. This approach transforms the static JSON output into an interactive, structured review experience directly inside the exercise editor.

A dropdown menu also summarizes all detected inconsistencies to give instructors and editors a clear overview of the entire exercise. The menu lists each issue along with its severity level, affected files, and line ranges, allowing instructors and editors to quickly assess the overall state of the exercise. The dropdown also includes filtering and sorting options, such as by severity, component (problem statement, template, solution, or tests), or issue category. This overview enables instructors and editors to manage the review process more efficiently, prioritize critical inconsistencies, and keep track of which issues have been addressed or remain unresolved.

=== Implement Persistent Storage and Collaboration

The next goal is to extend Artemis's internal data management architecture to support persistent storage of consistency issues and LLM-generated fix suggestions. Currently, detected inconsistencies exist only temporarily within the client-side session after the user executes a consistency check. Once the page is reloaded, the results are lost, and instructors and editors must repeat the process to retrieve them.

To address this limitation, the server-side model expands to include a dedicated database entity for consistency issues, linked to the corresponding exercise, file, and exercise version. Each issue entry stores the description, severity, category, suggested fix description, affected line range, and timestamps, ensuring that results can be queried and restored later.

In addition to persistence, this goal introduces concurrent collaboration support for reviewing and managing consistency data. Multiple instructors and editors can open and annotate the same exercise simultaneously without losing or overwriting each other's comments. A synchronization mechanism ensures that issue status updates, resolutions, or deletions are propagated immediately to all active users. A conflict-handling strategy prevents race conditions, such as two users marking the same issue as resolved/discarded at once.

=== Propose Inline Code Improvements

The third goal is to extend Artemis to support not only the detection of inconsistencies but also their automatic resolution through suggested inline code changes. When a consistency check is executed, the LLM response also includes structured code modification proposals in addition to issue descriptions. Each suggested code change specifies the file path, affected line range, and replacement snippet that implements the proposed correction. The database stores this data together with the issue, allowing Artemis to associate each inconsistency with its corresponding suggested code change. Within the exercise editor, instructors and editors can preview these suggested code changes inline, viewing the existing and modified code side by side.

The system also provides mechanisms for applying or discarding suggested code changes directly from the editor. When an instructor or editor accepts a suggested code change, Artemis replaces the existing code with that change and automatically creates a new exercise version. The implementation includes validation and conflict checks to ensure that suggested code changes remain consistent with the current state of the file, even if it has been modified since the check was generated. This approach reduces repetitive manual editing, accelerates the review process, and allows instructors and editors to focus on conceptual validation while the system handles mechanical consistency corrections.

== Outline
#TODO[
  Describe the outline of your thesis
]
The structure of this thesis leads the reader step by step from motivation to design, implementation, and reflection. Chapter 1 introduces the context of AI-assisted review in Artemis, outlines the problem motivating this work, and formulates the objectives. Chapter 2 covers the technical and conceptual background. Chapter 3 positions the work within existing research on human-in-the-loop education and AI-assisted review. Chapter 4 analyzes the requirements for a persistent review comment system, documenting functional requirements, quality attributes, constraints, and supporting models.
Chapter 5 moves into the solution space and develops the system architecture, defining design goals, decomposing the system into subsystems, and specifying persistence and access control. Chapter 6 describes the object design and implementation of the review workflow and consistency issue handling. Chapter 7 evaluates the system through user testing, and Chapter 8 concludes by revisiting the objectives, summarizing contributions, and outlining future work.
