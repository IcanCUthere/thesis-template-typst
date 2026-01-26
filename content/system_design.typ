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

Artemis operates as a web application with a client-server architecture. The client provides the programming exercise editor and review UI, while the server hosts the review workflow, persistence logic, and integration with Hyperion via Spring AI. Client and server communicate through REST endpoints, which keeps presentation and business logic separated and supports stable integration with existing Artemis components. The review subsystem integrates into the existing exercise and versioning infrastructure so that review comments remain linked to the correct exercise version and permissions.

== Design Goals
#TODO[
  Derive design goals from your quality attributes and constraints, prioritize them (as they might conflict with each other) and describe the rationale of your prioritization. Any trade-offs between design goals (e.g., build vs. buy, memory space vs. response time), and the rationale behind the specific solution should be described in this section
]
The design goals derive from the functional requirements, quality attributes, and constraints defined in Chapter 4. Following Bruegge and Dutoit’s guidance on prioritizing conflicting objectives #cite(<bruegge2004object>), the goals below describe the primary forces that shape the architecture and the trade-offs between them.

#par(first-line-indent: 0pt)[*Usability and Familiar Review Interaction*]
The system must provide a low-friction review experience that aligns with common tools instructors already use. The architecture therefore prioritizes a GitHub-style comment model and a VS Code-like overview navigation, which reduces training effort and supports fast adoption. This goal ranks high because the review workflow only succeeds if instructors can interpret and act on comments quickly (QA1, FR1).

#par(first-line-indent: 0pt)[*Reliability and Safe Issue Resolution*]
All changes must remain under instructor control. The design must enforce explicit confirmation, clear resolution states, and consistent behavior even when LLM output is uncertain. This goal drives decisions around thread state management, change application, and validation of suggested fixes (QA2, FR3). It ranks equally high with usability because incorrect changes can compromise exercise integrity.

#par(first-line-indent: 0pt)[*Persistence and Traceability*]
Review artifacts must remain available across sessions and exercise versions. The architecture therefore emphasizes persistent storage for threads, resolution status, and applied fixes, enabling instructors to track decisions and collaborate effectively (FR2). This goal supports auditability and reduces repeated work across iterations.

#par(first-line-indent: 0pt)[*Performance and Responsiveness*]
The system must remain responsive while handling multiple threads, overview filters, and LLM requests. The architecture favors efficient state synchronization and non-blocking updates in the editor UI, so instructors can continue working while data loads (QA3). Performance is important, but it does not outweigh correctness and usability.

#par(first-line-indent: 0pt)[*Modularity and Extensibility*]
The design should allow independent evolution of the review workflow, LLM integration, and UI components. Clear subsystem boundaries and well-defined interfaces enable future comment types, new review sources, or alternative LLM services without restructuring the core system (QA4). Modularity ranks after usability and reliability but remains essential for long-term maintainability.

#par(first-line-indent: 0pt)[*Prioritization and Trade-offs*]
In cases of conflict, the system follows an instructor-first principle: reliability and correctness take precedence over speed, and clarity of review comments takes precedence over aggressive automation. The design favors stable, comprehensible workflows over maximum LLM autonomy, aligning architectural choices with human-in-the-loop requirements.

== Subsystem Decomposition
#TODO[
  Describe the architecture of your system by decomposing it into subsystems and the services provided by each subsystem. Use UML class diagrams including packages / components for each subsystem.
]
The subsystem decomposition in #ref(<SubsystemDecomp>) separates the review workflow into client, server, persistence, and LLM provider concerns. On the client side, the UI consumes the ReviewService and CheckService interfaces to load review threads, submit replies, and trigger consistency checks without coupling to server internals.

The server side groups components into three layers. The Web Layer exposes REST endpoints through ReviewResource and ConsistencyCheckResource, which delegate to the application layer. The Application Layer contains the ReviewSystem, ConsistencyCheck, and ExerciseVersioning components. ReviewSystem coordinates thread lifecycle and comment state, ConsistencyCheck orchestrates calls to the LLM provider and transforms results into review threads, and ExerciseVersioning ensures that applied fixes create new exercise versions. The Persistence Layer provides CommentRepository and ThreadRepository, which supply data access via DataProviderService interfaces to the application layer.

The LLM Provider subsystem offers a PromptService that ConsistencyCheck consumes to execute consistency checks. This separation keeps LLM access behind a dedicated interface and allows alternative providers without changing the review workflow. The dependencies shown in the diagram clarify that web resources depend on application services, application services depend on repositories and the LLM provider, and the client communicates only through the exposed service interfaces.

#figure(
  image("../figures/Subsystem Decomposition.pdf", width: 100%),
  caption: [Sybsystem Decomposition of the server side.],
) <SubsystemDecomp>

== Hardware Software Mapping
#TODO[
  This section describes how the subsystems are mapped onto existing hardware and software components. The description is accompanied by a UML deployment diagram. The existing components are often off-the-shelf components. If the components are distributed on different nodes, the network infrastructure and the protocols are also described.
]

== Persistent Data Management
#TODO[
  Optional section that describes how data is saved over the lifetime of the system and which data. Usually this is either done by saving data in structured files or in databases. If this is applicable for the thesis, describe the approach for persisting data here and show a UML class diagram how the entity objects are mapped to persistent storage. It contains a rationale of the selected storage scheme, file system or database, a description of the selected database and database administration issues.
]

== Access Control
#TODO[
  Optional section describing the access control and security issues based on the quality attributes and constraints. It also de- scribes the implementation of the access matrix based on capabilities or access control lists, the selection of authentication mechanisms and the use of en- cryption algorithms.
]

== Global Software Control
#TODO[
  Optional section describing the control flow of the system, in particular, whether a monolithic, event-driven control flow or concurrent processes have been selected, how requests are initiated and specific synchronization issues
]

== Boundry Conditions
#TODO[
  Optional section describing the use cases how to start up the separate components of the system, how to shut them down, and what to do if a component or the system fails.
]
