#import "/utils/todo.typ": TODO

= Architecture
#TODO[
  This chapter follows the System Design Document Template in @bruegge2004object. You describe in this chapter how you map the concepts of the application domain to the solution domain. Some sections are optional, if they do not apply to your problem. Cite @bruegge2004object several times in this chapter.
]

In this chapter, we map the concepts of the application domain to the solution domain. Following the System Design Document Template described by Bruegge and Dutoit #cite(<bruegge2004object>), we use the results of the analysis-such as the functional requirements, constraints, and quality attributes-to guide architectural decisions. The goal of this chapter is to establish the technical structure that enables the implementation of the required features. We describe the overall architecture of the review workflow in Artemis, outline the design goals derived from the quality attributes, decompose the system into subsystems, and explain how persistence and access control are realized in the solution domain.

== Overview
#TODO[
  Provide a brief overview of the software architecture and references to other chapters (e.g. requirements), references to existing systems, constraints impacting the software architecture..
]

Artemis operates as a web application with a client-server architecture. The client provides the programming exercise editor and review UI, while the server hosts the review workflow, persistence logic, and integration with Hyperion via Spring AI. Client and server communicate through REST endpoints, which keeps presentation and business logic separated and supports stable integration with existing Artemis components. The review subsystem integrates into the existing infrastructure for exercises and exercise versions so that review comments remain linked to the correct exercise version and permissions.

== Design Goals
#TODO[
  Derive design goals from your quality attributes and constraints, prioritize them (as they might conflict with each other) and describe the rationale of your prioritization. Any trade-offs between design goals (e.g., build vs. buy, memory space vs. response time), and the rationale behind the specific solution should be described in this section
]
The design goals derive from the functional requirements, quality attributes, and constraints defined in Chapter 4. Following Bruegge and Dutoit’s guidance on prioritizing conflicting objectives #cite(<bruegge2004object>), the goals below describe the primary forces that shape the architecture and the trade-offs between them.

#par(first-line-indent: 0pt)[*Usability and Familiar Review Interaction*]
The system must provide a low-friction review experience that aligns with common tools instructors and editors already use. The architecture therefore prioritizes a GitHub-style comment model and a VS Code-like overview navigation, which reduces training effort and supports fast adoption. This goal ranks high because the review workflow only succeeds if instructors and editors can interpret and act on comments quickly (QA1, FR1).

#par(first-line-indent: 0pt)[*Reliability and Safe Issue Resolution*]
All changes must remain under instructor and editor control. The design must enforce explicit confirmation, clear resolution states, and consistent behavior even when LLM output is uncertain. This goal drives decisions around thread state management, change application, and validation of suggested code changes (QA2, FR3). It ranks equally high with usability because incorrect changes can compromise exercise integrity.

#par(first-line-indent: 0pt)[*Persistence and Traceability*]
Review artifacts must remain available across sessions and exercise versions. The architecture therefore emphasizes persistent storage for threads, resolution status, and applied fixes, enabling instructors and editors to track decisions and collaborate effectively (FR2). This goal supports auditability and reduces repeated work across iterations.

#par(first-line-indent: 0pt)[*Performance and Responsiveness*]
The system must remain responsive while handling multiple threads, overview filters, and LLM requests. The architecture favors efficient state synchronization and non-blocking updates in the editor UI, so instructors and editors can continue working while data loads (QA3). Performance is important, but it does not outweigh correctness and usability.

#par(first-line-indent: 0pt)[*Modularity and Extensibility*]
The design should allow independent evolution of the review workflow, LLM integration, and UI components. Clear subsystem boundaries and well-defined interfaces enable future comment types, new review sources, or alternative LLM services without restructuring the core system (QA4). Modularity ranks after usability and reliability but remains essential for long-term maintainability.

#par(first-line-indent: 0pt)[*Prioritization and Trade-offs*]
In cases of conflict, the system follows an instructor/editor-first principle: reliability and correctness take precedence over speed, and clarity of review comments takes precedence over aggressive automation. The design favors stable, comprehensible workflows over maximum LLM autonomy, aligning architectural choices with human-in-the-loop requirements.

== Subsystem Decomposition
#TODO[
  Describe the architecture of your system by decomposing it into subsystems and the services provided by each subsystem. Use UML class diagrams including packages / components for each subsystem.
]
The subsystem decomposition splits the review workflow into client and server concerns, shown in #ref(<SubsystemDecompClient>) and #ref(<SubsystemDecompServer>).

#par(first-line-indent: 0pt)[*Client Side*]
The client diagram in #ref(<SubsystemDecompClient>) separates the UI from service access. The Service Layer exposes ReviewService and ConsistencyCheckService interfaces, which the UI uses to load threads, start checks, and apply changes. The User Interface Layer contains the CodeEditorContainer, CodeEditor, and CommentOverview components. CodeEditorContainer orchestrates the editor and overview, the CodeEditor renders inline comments and applies edits, and CommentOverview supports filtering and navigation. This split keeps the UI modular and allows the review workflow to evolve without changing how the editor talks to the server.

#figure(
  image("../figures/SubDecompClient.pdf", width: 95%),
  caption: [Subsystem decomposition of the client side.],
) <SubsystemDecompClient>

#par(first-line-indent: 0pt)[*Server Side*]
The server diagram in #ref(<SubsystemDecompServer>) groups components into persistence, application, and web layers. The Persistence Layer contains CommentRepository and ThreadRepository. They expose DataProviderService interfaces that supply thread and comment data to the application layer. The Application Layer contains ReviewSystem, ConsistencyCheck, and ExerciseVersioning. ReviewSystem manages thread lifecycle and state changes, ConsistencyCheck orchestrates LLM requests and transforms results into review threads, and ExerciseVersioning creates new exercise versions when fixes apply. The Web Layer exposes ReviewResource and ConsistencyCheckResource, which provide REST endpoints for the client-facing services.

The LLM Provider subsystem offers a PromptService that ConsistencyCheck consumes to execute checks. This separation keeps LLM access behind a dedicated interface and allows alternative providers without changing the review workflow. The dependencies in the diagram show that web resources depend on application services, application services depend on repositories and the LLM provider, and the client communicates only through the exposed service interfaces.

#figure(
  image("../figures/SubDecompServer.pdf", width: 95%),
  caption: [Subsystem decomposition of the server side.],
) <SubsystemDecompServer>

== Hardware Software Mapping
#TODO[
  This section describes how the subsystems are mapped onto existing hardware and software components. The description is accompanied by a UML deployment diagram. The existing components are often off-the-shelf components. If the components are distributed on different nodes, the network infrastructure and the protocols are also described.
]
The review workflow reuses the existing Artemis deployment and does not introduce new hardware nodes. The client runs in the browser as part of the Artemis web application, and the server runs in the existing Artemis backend environment. LLM requests go through the existing Hyperion integration via Spring AI.

The implementation follows the established Artemis tech stack: Angular on the client, Spring Boot on the server, and a relational database (PostgreSQL or MySQL) for persistence. Client and server communicate through REST endpoints, and the review subsystem integrates into the existing services for exercises and exercise versions.

== Persistent Data Management
#TODO[
  Optional section that describes how data is saved over the lifetime of the system and which data. Usually this is either done by saving data in structured files or in databases. If this is applicable for the thesis, describe the approach for persisting data here and show a UML class diagram how the entity objects are mapped to persistent storage. It contains a rationale of the selected storage scheme, file system or database, a description of the selected database and database administration issues.
]

The review workflow stores its data in Artemis's relational database so that review information remains available across sessions and across exercise versions. As shown in #ref(<DB>), the persistence model centers on three entities: ThreadGroup, CommentThread, and Comment. ThreadGroup organizes related threads within one exercise, CommentThread stores the review anchor and lifecycle state, and Comment stores the individual discussion entries and consistency-check outputs.

CommentThread is linked to the corresponding ProgrammingExercise and, where needed, to an ExerciseVersion. In addition to the thread state (for example resolved and outdated), the model stores anchor metadata such as repository target, file path, line number, and initial version/commit references. This allows the system to keep review context stable even when the exercise evolves. Comments are linked to a thread and an optional author, and consistency-related comment content can carry both a human-readable fix description and an optional suggested inline code change.

Over the lifetime of the system, data is written at the moment instructors or editors create threads/comments or update thread states, and it is cleaned up according to ownership boundaries. In practice, this means that removing all comments from a thread removes the thread as well, and exercise-level deletion removes dependent review data. This behavior keeps the review model consistent with the lifecycle of its parent exercise while avoiding orphaned records.

The selected storage scheme is a pragmatic hybrid: relational structures for ownership, references, and lifecycle state, combined with structured comment payloads for extensible content types. This balances integrity and flexibility. Relational constraints and explicit mappings support reliable querying and access control, while structured payloads allow the system to evolve consistency-comment content without redesigning the schema for every new field.

From an operational perspective, the subsystem reuses Artemis database infrastructure and migration process. Schema changes are managed through Liquibase changelogs, and the same model supports the existing Artemis database setups (for example MySQL and PostgreSQL profiles). For administration, this means the review data follows the same backup, migration, and monitoring workflows as the rest of the platform, with particular attention to thread/comment relations and version references.

#figure(
  image("../figures/Database.pdf", width: 95%),
  caption: [Database Schema.],
) <DB>

== Access Control
#TODO[
  Optional section describing the access control and security issues based on the quality attributes and constraints. It also de- scribes the implementation of the access matrix based on capabilities or access control lists, the selection of authentication mechanisms and the use of en- cryption algorithms.
]
The review system restricts all review actions to instructors and editors. Only users with instructor or editor permissions can view review threads, create or edit comments, resolve or discard issues, run consistency checks, and apply suggested code changes. This restriction aligns review actions with teaching responsibility and avoids accidental changes by students or tutors.

Access control follows existing Artemis authorization rules for programming exercises. Review threads inherit the same access scope as the exercise and its repository, so only instructors and editors assigned to the exercise can access the data. Server-side endpoints in ReviewResource and ConsistencyCheckResource enforce these checks, and the client only exposes review UI elements when the user has the required role. #ref(<AccessRightsMatrix>) summarizes the role-based access rights for the core review and consistency check functions.

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
  caption: [Access rights for review and consistency-check functions.],
) <AccessRightsMatrix>

== Global Software Control
#TODO[
  Optional section describing the control flow of the system, in particular, whether a monolithic, event-driven control flow or concurrent processes have been selected, how requests are initiated and specific synchronization issues
]

Artemis uses a hybrid control model for the review workflow. User actions are handled through a main REST request/response path and persisted as the authoritative state in the database, while a parallel WebSocket live-update path distributes changes to other open clients. This separation keeps write operations reliable and still supports low-latency collaboration.

The runtime processes requests and live notifications concurrently. This is important because multiple users can review the same exercise at the same time, and the system must remain responsive for all active clients.

To keep shared state stable, the client synchronization logic handles delayed or repeated updates safely. Temporary differences between open views are resolved without corrupting state, so the workflow remains eventually consistent during concurrent work.

/*
== Boundry Conditions
#TODO[
  Optional section describing the use cases how to start up the separate components of the system, how to shut them down, and what to do if a component or the system fails.
]
*/
