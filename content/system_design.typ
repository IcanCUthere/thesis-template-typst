#import "/utils/todo.typ": TODO

= Architecture <chap-architecture>
#TODO[
  This chapter follows the System Design Document Template in @bruegge2004object. You describe in this chapter how you map the concepts of the application domain to the solution domain. Some sections are optional, if they do not apply to your problem. Cite @bruegge2004object several times in this chapter.
]

This chapter maps the concepts of the application domain to the solution domain. Following the system design document template described by Bruegge and Dutoit #cite(<bruegge2004object>), this chapter uses analysis results, including functional requirements, constraints, and quality attributes, to guide architectural decisions. The chapter first describes the review workflow architecture in Artemis and then derives prioritized design goals from these requirements. It then decomposes the system into subsystems and explains how persistence and access control work in the solution domain.

== Overview
#TODO[
  Provide a brief overview of the software architecture and references to other chapters (e.g. requirements), references to existing systems, constraints impacting the software architecture..
]

Artemis operates as a web application with a client-server architecture. The client provides the programming exercise editor and review UI, while the server hosts the review workflow, persistence logic, and integration with Hyperion via Spring AI. Client and server communicate through Representational State Transfer (REST) endpoints, which keeps presentation and business logic separated and supports stable integration with existing Artemis components. The review subsystem integrates into the existing infrastructure for exercises and exercise versions so Artemis keeps review threads linked to the correct exercise version and permissions.

== Design Goals
#TODO[
  Derive design goals from your quality attributes and constraints, prioritize them (as they might conflict with each other) and describe the rationale of your prioritization. Any trade-offs between design goals (e.g., build vs. buy, memory space vs. response time), and the rationale behind the specific solution should be described in this section
]
The design goals derive from the functional requirements, quality attributes, and constraints defined in Chapter 4. Following Bruegge and Dutoit’s guidance on prioritizing conflicting objectives #cite(<bruegge2004object>), the goals below describe the primary forces that shape the architecture and the trade-offs between them.

#par(first-line-indent: 0pt)[*Usability and Familiar Review Interaction*]
The system must provide a low-friction review experience that aligns with common tools instructors and editors already use (QA1, QA2, FR6, FR7). The architecture therefore prioritizes a threaded comment model and a sidebar-based overview navigation pattern familiar from modern review and editor interfaces, which reduces training effort and supports fast adoption (FR6, FR16, C1). This goal ranks high because the review workflow only succeeds if instructors and editors can interpret thread context and status quickly without disrupting editing (QA1, QA2).

#par(first-line-indent: 0pt)[*Reliability and Safe Issue Resolution*]
All changes must remain under instructor and editor control (C3, QA3). The design must enforce explicit confirmation, clear resolution states, and consistent behavior even when LLM output is uncertain (QA3, QA4, FR8). This goal drives decisions around thread state management, change application, and validation of suggested code changes (FR14, FR15, QA4). It ranks equally high with usability because incorrect changes can compromise exercise integrity.

#par(first-line-indent: 0pt)[*Persistence and Traceability*]
Review artifacts must remain available across sessions and exercise versions (FR2, FR9, FR10). The architecture therefore emphasizes persistent storage for threads, resolution status, and applied fixes, enabling instructors and editors to track decisions and collaborate effectively (FR2, QA4, C2). This goal supports auditability and reduces repeated work across iterations.

#par(first-line-indent: 0pt)[*Performance and Responsiveness*]
The system must remain responsive while handling multiple threads, overview filters, and LLM requests (QA5, QA6). The architecture favors efficient state synchronization and non-blocking updates in the editor UI, so instructors and editors can continue working while data loads (QA5, QA6, C4). Performance is important, but it does not outweigh correctness and usability.

#par(first-line-indent: 0pt)[*Modularity and Extensibility*]
The design should allow independent evolution of the review workflow, LLM integration, and UI components (QA7, QA8). Clear subsystem boundaries and well-defined interfaces enable future comment types, new review sources, or alternative LLM services without restructuring the core system (QA7, QA8, C1, C2). Modularity ranks after usability and reliability but remains essential for long-term maintainability.

=== Prioritization and Trade-offs
In cases of conflict, the system follows an instructor/editor-first principle: reliability and correctness take precedence over speed, and clarity of review threads and comments takes precedence over aggressive automation. The design favors stable, comprehensible workflows over maximum LLM autonomy, aligning architectural choices with role and prompt constraints (C3, C4) and human-in-the-loop requirements.

== Subsystem Decomposition
#TODO[
  Describe the architecture of your system by decomposing it into subsystems and the services provided by each subsystem. Use UML class diagrams including packages / components for each subsystem.
]
The subsystem decomposition shown in #ref(<SubsystemDecompCombined>) follows two integration priorities for this thesis: keeping editor interaction responsive for instructors and editors, and preserving the existing separation between review logic, persistence, and AI-assisted consistency checking.
At a high level, the client subsystem provides interaction services (inline review display, comment actions, consistency-issue navigation, and initiation of consistency checks), while the server subsystem provides review-state persistence and synchronization, version-aware anchor remapping during exercise versioning, and consistency-issue processing through Hyperion.

#par(first-line-indent: 0pt)[*Client Side*]
On the client side, the decomposition separates interaction-focused UI components from the service interfaces they use to communicate with the server. CodeEditor, ProblemStatementEditor, FileBrowser, and ExerciseContainer remain focused on editing, navigation, and exercise interaction, while ReviewCommentManager centralizes review-thread behavior across these views. This keeps review-thread handling and comment handling decoupled from the individual UI components and makes the editor behavior easier to test and evolve.

The client communicates with the server through three dedicated interfaces with different interaction patterns and failure modes. ReviewCommentManager uses StoreAndFetchService for regular read/write access to persisted review state and LiveUpdateService for push-based synchronization across active clients, while ExerciseContainer uses ConsistencyCheckService to trigger longer-running AI-assisted checks. Isolating these flows avoids one concern (for example delayed check responses) from degrading others (for example local editor responsiveness), which directly supports usability and reliability goals.

#figure(
  image("../figures/SubDecompCombined.pdf", width: 95%),
  caption: [Combined Subsystem Decomposition. The diagram shows how client components, server workflows, persistence, and Hyperion integration interact in the review architecture.],
) <SubsystemDecompCombined>

#par(first-line-indent: 0pt)[*Server Side*]
On the server side, the decomposition separates review-state management, versioning, and AI-assisted checking into distinct components. ExerciseReview owns the core review workflow and manages review data exchanged with the client. ExerciseVersioning handles version creation as an explicit workflow step and then invokes ExerciseReview to remap comment anchors to the new file state; if remapping fails or context has changed significantly, ExerciseReview marks the affected comments as outdated. Hyperion handles consistency checks and feeds their results back into the review workflow. This keeps domain responsibilities explicit and avoids hidden coupling between review-state management, version creation, and automated analysis.

Artemis already provides the separation between persistence and LLM integration through DataService and PromptService. This thesis reuses these existing boundaries and integrates the review workflow through ExerciseReview, ExerciseVersioning, and Hyperion interfaces. The contribution in this section is therefore not the separation itself, but the integration contract across these components: the workflow transforms Hyperion consistency issues into review threads with initial consistency comments, version creation triggers anchor remapping and outdated-state handling, and the synchronization path propagates thread-state changes to active clients.

/*
== Hardware Software Mapping
#TODO[
  This section describes how the subsystems are mapped onto existing hardware and software components. The description is accompanied by a UML deployment diagram. The existing components are often off-the-shelf components. If the components are distributed on different nodes, the network infrastructure and the protocols are also described.
]
The review workflow reuses the existing Artemis deployment and does not introduce new hardware nodes. The client runs in the browser as part of the Artemis web application, and the server runs in the existing Artemis backend environment. LLM requests go through the existing Hyperion integration via Spring AI.

The implementation follows the established Artemis tech stack: Angular on the client, Spring Boot on the server, and a relational database (PostgreSQL or MySQL) for persistence. Client and server communicate through REST endpoints, and the review subsystem integrates into the existing services for exercises and exercise versions.
*/

== Persistent Data Management
#TODO[
  Optional section that describes how data is saved over the lifetime of the system and which data. Usually this is either done by saving data in structured files or in databases. If this is applicable for the thesis, describe the approach for persisting data here and show a UML class diagram how the entity objects are mapped to persistent storage. It contains a rationale of the selected storage scheme, file system or database, a description of the selected database and database administration issues.
]

Artemis stores review data in its relational database so review information remains available across sessions and across exercise versions. #ref(<DB>) shows that the persistence model centers on three entities: ThreadGroup, CommentThread, and Comment. ThreadGroup organizes related threads within one exercise, CommentThread stores the thread line reference and lifecycle state, and Comment stores the individual discussion entries and outputs from consistency checks.

The model links each CommentThread to the corresponding ProgrammingExercise and, where needed, to an ExerciseVersion. In addition to the thread state (for example resolved and outdated), the model stores line-reference metadata such as repository target, file path, line number, and initial version/commit references. This allows the system to keep review context stable even when the exercise evolves. The model links comments to a thread and to an optional author, and consistency-related comment content can carry both a human-readable fix description and an optional suggested code change.

#figure(
  image("../figures/Database.pdf", width: 95%),
  caption: [Review Persistence Database Schema. The schema maps thread groups, threads, and comments to exercises and versions for traceable review history.],
) <DB>

Over the lifetime of the system, Artemis writes review data when instructors or editors create threads/comments or update thread states, and Artemis cleans up review data according to ownership boundaries. In practice, this means that removing all comments from a thread removes the thread as well, and exercise-level deletion removes dependent review data. This behavior keeps the review model consistent with the lifecycle of its parent exercise while avoiding orphaned records.

The storage approach combines two ideas. Relational tables store core review data, such as ownership, references, and thread state. This keeps relationships and queries reliable. At the same time, structured payload fields store comment-specific consistency data, so the team can add new consistency-comment details without changing the database schema for every small extension. This combination keeps the model stable while still allowing gradual feature growth.

From an operational perspective, the subsystem reuses Artemis database infrastructure and migration process. Artemis manages schema changes through Liquibase changelogs, and the same model supports the existing Artemis database setups (for example MySQL and PostgreSQL profiles). For administration, this means the review data follows the same backup, migration, and monitoring workflows as the rest of the platform, with particular attention to thread/comment relations and version references.

== Access Control
#TODO[
  Optional section describing the access control and security issues based on the quality attributes and constraints. It also de- scribes the implementation of the access matrix based on capabilities or access control lists, the selection of authentication mechanisms and the use of en- cryption algorithms.
]
The review system restricts all review actions to instructors and editors. Only users with instructor or editor permissions can view review threads, create or edit comments, resolve or discard consistency issues, run consistency checks, and apply suggested code changes. This restriction aligns review actions with teaching responsibility and avoids accidental changes by students or tutors.

#figure(
  table(
    columns: (2fr, 1fr, 1fr, 1fr, 1fr),
    inset: 6pt,
    align: (left, center, center, center, center),
    [*Functionality*], [*Admin*], [*Instructor*], [*Editor*], [*Student*],
    [Create review thread], [✓], [✓], [✓], [✗],
    [List review threads], [✓], [✓], [✓], [✗],
    [Create thread group], [✓], [✓], [✓], [✗],
    [Delete thread group], [✓], [✓], [✓], [✗],
    [Add comment to thread], [✓], [✓], [✓], [✗],
    [Delete comment], [✓], [✓], [✓], [✗],
    [Mark thread resolved], [✓], [✓], [✓], [✗],
    [Edit comment], [✓], [✓], [✓], [✗],
    [Run consistency check], [✓], [✓], [✓], [✗],
  ),
  caption: [Access Rights Matrix for Review and Consistency-Check Functions. The table summarizes allowed actions for admin, instructor, editor, and student roles.],
) <AccessRightsMatrix>

Access control follows existing Artemis authorization rules for programming exercises. Review threads inherit the same access scope as the exercise and its repository, so only instructors and editors assigned to the exercise can access the data. Server-side endpoints in ReviewResource and ConsistencyCheckResource enforce these checks, and the client only exposes review UI elements when the user has the required role. #ref(<AccessRightsMatrix>) summarizes the role-based access rights for the core review and consistency check functions.

== Global Software Control
#TODO[
  Optional section describing the control flow of the system, in particular, whether a monolithic, event-driven control flow or concurrent processes have been selected, how requests are initiated and specific synchronization issues
]

Artemis uses a hybrid control model for the review workflow. Artemis handles user actions through a main REST request/response path and persists the authoritative state in the database, while a parallel WebSocket live-update path distributes changes to other open clients. This separation keeps write operations reliable and still supports low-latency collaboration.

The runtime processes requests and live notifications concurrently. This is important because multiple users can review the same exercise at the same time, and the system must remain responsive for all active clients.

The client synchronization logic keeps shared state stable by handling delayed or repeated updates safely. The client resolves temporary differences between open views without corrupting state, so the workflow remains eventually consistent during concurrent work.

/*
== Boundary Conditions
#TODO[
  Optional section describing the use cases how to start up the separate components of the system, how to shut them down, and what to do if a component or the system fails.
]
*/
