#import "/utils/todo.typ": TODO

= Introduction <chap-introduction>
#TODO[
  Introduce the topic of your thesis, e.g. with a little historical overview.
]
Artemis is a learning platform widely used in higher education to support programming education through interactive exercises and automatic assessment #cite(<Krusche2018284>). The platform integrates with version-controlled repositories and continuous integration systems, and recent releases add large language model (LLM) features. Through Iris, the integrated LLM-based chatbot, students can receive explanations and guidance while solving exercises #cite(<Bassner2024394>).

Artemis now supports instructors and editors with AI-assisted review workflows. Each programming exercise consists of a problem statement, a template, a solution, and tests, and these artifacts must remain consistent. Artemis can query an LLM for a consistency check and receive structured JavaScript Object Notation (JSON) output that describes each consistency issue, its severity, and a suggested fix description. This thesis uses the term *consistency issue* for one detected issue.

== Problem
#TODO[
  Describe the problem that you like to address in your thesis to show the importance of your work. Focus on the negative symptoms of the currently available solution.
]
Artemis supports LLM-based consistency checks, but review and refinement still rely on manual work. The platform only shows the results as formatted JSON. Instructors and editors must interpret each entry, locate the affected files and lines, and apply corrections manually.

This workflow consumes time, introduces avoidable errors, and scales poorly for complex exercises. Artemis also lacks a persistent review thread system for consistency issues, so teams cannot track issue history reliably across exercise versions.

When the page reloads or the exercise version changes, Artemis discards detected consistency issues and forces users to rerun the consistency check. This repeated effort pulls instructors and editors away from pedagogical improvements, makes consistent quality harder to maintain, and adds unnecessary costs because each rerun sends additional requests to LLM providers.

Students depend on coherent exercises for effective learning. Consistency issues between the problem statement, template, solution, and tests can confuse students, increase cognitive load, and weaken learning outcomes.

== Motivation
#TODO[
  Motivate scientifically why solving this problem is necessary. What kind of benefits do we have by solving the problem?
]
These limitations motivate a workflow that helps instructors and editors resolve consistency issues efficiently and transparently. A practical review workflow can transform raw JSON output from a consistency check into decisions that instructors and editors can execute directly. Clear in-context presentation and overviews help teams identify and prioritize consistency issues without repeatedly translating raw output into concrete actions.

Persistent tracking across exercise revisions strengthens collaborative quality assurance. Instructors and editors can document decisions, revisit unresolved consistency issues, and coordinate follow-up actions over time. This traceability supports consistent review standards across shared authoring workflows.

Automatic correction support can reduce repetitive editing while preserving human judgment. Instructors and editors can evaluate each proposed change against exercise intent, accept proposals that improve alignment, and reject proposals that conflict with pedagogical goals.

These capabilities shift effort from mechanical interpretation to educational design. Instructors and editors can focus on learning outcomes, task clarity, and assessment alignment. Students benefit from more coherent exercises and can focus on problem solving instead of resolving avoidable consistency issues.

== Objectives
#TODO[
  Describe the research goals and/or research questions and how you address them by summarizing what you want to achieve in your thesis, e.g. developing a system and then evaluating it.
]
This thesis investigates how Artemis can integrate AI-assisted consistency feedback into programming-exercise authoring so instructors and editors can resolve issues efficiently while keeping final decision authority.

The objectives derive from the motivation in the previous section: instructors and editors need actionable feedback presentation, traceability across exercise revisions, and lower correction effort without surrendering control over exercise content.

The thesis addresses the following research questions:
+ *RQ1:* How should Artemis present and structure LLM-detected consistency issues so instructors and editors can interpret, prioritize, and resolve them efficiently?
+ *RQ2:* How should Artemis preserve, synchronize, and update consistency information across exercise revisions so teams can collaborate and trace decisions over time?
+ *RQ3:* How can Artemis provide suggested code changes that reduce repetitive manual editing while preserving human control over final exercise content?

These research questions guide three operational objectives.

=== Provide In-Context Review Support

The first objective addresses RQ1. Artemis should present consistency issues as structured in-context annotations instead of raw JSON output. Each consistency issue should include a clear description, severity, rationale, and precise location context so instructors and editors can understand it without manual translation.

Artemis should additionally provide a dedicated overview for navigation and prioritization. Instructors and editors should inspect affected artifacts, filter and sort consistency issues, and navigate directly to relevant locations. This objective turns output from a consistency check into actionable review input.

=== Enable Persistent and Collaborative Traceability

The second objective addresses RQ2. Artemis should preserve consistency issues, decision states, and related context across sessions and exercise revisions. The workflow should keep enough information to restore and audit past decisions reliably.

Artemis should also support concurrent review by multiple instructors and editors. Synchronization and conflict handling should keep decision states consistent during parallel work. This objective establishes a stable collaboration workflow instead of a session-local check result.

=== Support Human-Controlled Change Decisions

The third objective addresses RQ3. Artemis should extend consistency checks with suggested code changes that instructors and editors can evaluate directly. The interface should present suggested code changes in a reviewable form so users can compare current and proposed content before deciding.

Artemis should enforce explicit accept or reject decisions and validate context before applying a suggested code change. When instructors or editors accept a suggested code change, Artemis should record the decision and resulting update transparently. This objective reduces repetitive editing while keeping conceptual and pedagogical decisions with human reviewers.

== Outline
#TODO[
  Describe the outline of your thesis
]
This thesis contains six chapters. #ref(<chap-introduction>) introduces the context of AI-assisted review in Artemis, defines the problem, and formulates the objectives. #ref(<chap-background>) presents technical and conceptual background. #ref(<chap-related-work>) positions the work in related research on human-in-the-loop education and AI-assisted review.

#ref(<chap-requirements>) analyzes requirements for a persistent review thread system, including functional requirements, quality attributes, constraints, and models. #ref(<chap-architecture>) develops the system architecture with design goals, subsystem decomposition, persistence, and access control. #ref(<chap-summary>) summarizes the implementation status, discusses contributions, and outlines future work.
