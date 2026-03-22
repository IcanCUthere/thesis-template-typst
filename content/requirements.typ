#import "/utils/todo.typ": TODO

= Requirements <chap-requirements>
#TODO[
  This chapter follows the Requirements Analysis Document Template in @bruegge2004object. Important: Make sure that the whole chapter is independent of the chosen technology and development platform. The idea is that you illustrate concepts, taxonomies and relationships of the application domain independent of the solution domain! Cite @bruegge2004object several times in this chapter.

]
This chapter examines the requirements for integrating AI-assisted review into Artemis. This chapter follows the design process described by Bruegge and Dutoit #cite(<bruegge2004object>). First, this chapter defines the scope and highlights the major objectives of the proposed system. It then describes the existing system before detailing the functional requirements and quality attributes in the Proposed System section. Finally, the System Models section describes system models to illustrate the concepts further.

== Overview
#TODO[
  Provide a short overview about the purpose, scope, objectives and success criteria of the system that you like to develop.
]
This section summarizes the purpose and scope of the proposed system and outlines its objectives and success criteria. The system aims to support instructors and editors in reviewing programming exercises by turning LLM-based consistency checks into persistent, actionable review threads. Its scope covers detecting consistency issues across problem statement, template, solution, and tests, and managing their review lifecycle within Artemis. The objectives are to introduce a review thread system with persistence across exercise versions, provide clear inline consistency-issue presentation and navigation, and enable instructors and editors to preview and apply suggested code changes under human control. This thesis considers the system successful when it reduces review effort and improves transparency of consistency issues.

== Existing System
#TODO[
  This section is only required if the proposed system (i.e. the system that you develop in the thesis) should replace an existing system.
]
Artemis already supports LLM-based consistency checks for programming exercises through the Hyperion module. Hyperion integrates via Spring AI and provides an AI-assisted exercise creation assistant that helps instructors and editors create high-quality exercises more efficiently, including consistency checking. An instructor or editor can trigger a consistency check that compares the problem statement, template, solution, and tests and returns a structured JSON list of detected consistency issues, including severity, category, and suggested fix description. The current interface exposes this output as raw JSON, so instructors and editors must manually interpret the results, locate the affected files and lines, and apply corrections themselves.

The existing system does not persist consistency issues. When the page reloads or the exercise version changes, Artemis discards detected consistency issues and users must rerun the consistency check. Artemis also lacks a review thread mechanism for tracking resolution state and discussion over time, which makes cross-iteration consistency management and team coordination difficult.

== Proposed System
#TODO[
  If you leave out the section “Existing system”, you can rename this section into “Requirements”.
]

The proposed system extends Artemis with a review-centric consistency workflow that turns Hyperion's LLM-detected consistency issues into persistent, actionable artifacts. For each detected consistency issue, the system creates a review thread and stores the issue details in the initial consistency comment. The system stores these threads with the exercise and the corresponding exercise version, so instructors and editors can track, discuss, and resolve consistency issues over time. It integrates manual instructor/editor feedback and AI-generated consistency issues into one interface and keeps a clear trace of what changed and why across exercise versions.

This design operationalizes the human-in-the-loop paradigm: the system provides AI-generated proposals, while instructors and editors review, decide, and remain responsible for the final outcome. The system presents consistency issues inline with clear metadata, provides overview navigation, and lets instructors and editors preview and apply suggested code changes while keeping human control over final changes. Overall, the system aims to improve the transparency, efficiency, and reliability of exercise creation without changing the pedagogical intent of the exercises.

=== Functional Requirements
#TODO[
  List and describe all functional requirements of your system. Also mention requirements that you were not able to realize. The short title should be in the form “verb objective”

  - FR1 Short Title: Short Description. 
  - FR2 Short Title: Short Description. 
  - FR3 Short Title: Short Description.
]

This section specifies the functional requirements of the review workflow. Each requirement describes a distinct capability the system must provide to support instructors and editors in reviewing, discussing, and resolving consistency issues within Artemis.

#par(first-line-indent: 0pt)[*Basic Review System Functionality*]

- *FR1 Create Review Threads and User Comments:* The system shall allow instructors and editors to create review threads for a specific file and line number and add user-written comments to these threads.
- *FR2 Persist Review Threads:* The system shall store review threads with the exercise so they remain available across sessions.
- *FR3 Reply to Threads:* The system shall allow instructors and editors to reply within an existing thread to continue the discussion.
- *FR4 Edit User Comments:* The system shall allow instructors and editors to edit the content of their user comments.
- *FR5 Delete Comments and Threads:* The system shall allow instructors and editors to delete individual comments and remove entire threads.
- *FR6 Show Threads Inline in the Editor:* The system shall display threads and their comments inside the editor at the referenced line location and provide navigation between threads.
- *FR7 Hide Review Threads in the Editor:* The system shall allow instructors and editors to hide review threads in the editor view to reduce visual obstruction while editing code.
- *FR8 Mark Threads as Resolved:* The system shall allow instructors and editors to mark threads as resolved and reflect the resolution status in both the inline view and any overview/navigation views.
- *FR9 Update Thread Line References for New Exercise Versions:* The system shall update thread line references when instructors or editors create a new exercise version so the system keeps existing threads linked to the correct locations in the updated files.
- *FR10 Mark Threads as Outdated on Content Changes:* The system shall detect when the underlying line content at a thread’s referenced line location has changed and mark the thread as outdated to signal that the context may no longer match.
- *FR11 Propagate Review Updates to Active Clients:* The system shall propagate thread and comment updates to other active clients that are working on the same exercise.

These requirements define the baseline review workflow, independent of how consistency issues are discovered.

#par(first-line-indent: 0pt)[*Specific Consistency Issue Functionality*]

- *FR12 Create Review Threads from Consistency Checks:* The system shall convert Hyperion consistency check results into review threads, link each review thread to the affected file and line range, and store each consistency issue in the initial consistency comment of the corresponding thread.
- *FR13 Provide Code-Change Previews:* The system shall present suggested code changes side by side with the current content to enable review before changes.
- *FR14 Apply Suggested Code Changes:* The system shall allow instructors and editors to apply a suggested code change and update the exercise content accordingly.
- *FR15 Validate Suggested Code Changes:* The system shall check that a suggested code change still matches the current file context before applying it.
- *FR16 Provide Consistency Issue Overview and Navigation:* The system shall provide an overview list of detected consistency issues and allow instructors and editors to jump from this list to the corresponding locations in the editor.

These requirements define the workflow for consistency checks and ensure that instructors and editors retain control over final changes while reducing manual edits.

=== Quality Attributes
#TODO[
  List and describe all quality attributes of your system. All your quality attributes should fall into the URPS categories mentioned in @bruegge2004object. Also mention requirements that you were not able to realize.

  - QA1 Category: Short Description. 
  - QA2 Category: Short Description. 
  - QA3 Category: Short Description.

]
This section details the quality attributes of the proposed system and defines criteria for evaluating operational performance and user experience. The attributes follow the Usability, Reliability, Performance, and Supportability (URPS) categories described by Bruegge and Dutoit #cite(<bruegge2004object>).

- *QA1 Unobtrusive Inline Review (Usability):* Inline review elements shall remain unobtrusive during editing and shall not unnecessarily block code content.
- *QA2 Clear Thread Visibility and State (Usability):* The interface shall show thread location and status through indicators and labels (for example open, resolved, outdated) so instructors and editors can recognize them immediately.
- *QA3 Safe Change Application (Reliability):* The system shall apply suggested code changes only after explicit confirmation and successful context validation; otherwise, the system shall leave the content unchanged.
- *QA4 Consistent Review State (Reliability):* The system shall keep thread and comment states consistent across persistence, reloads, exercise-version updates, and concurrent client updates, and the system shall provide clear feedback on failures.
- *QA5 Responsive Editor Interaction (Performance):* Editing interactions (typing, scrolling, cursor movement, thread expand/collapse, and issue navigation) shall remain responsive and non-blocking.
- *QA6 Asynchronous Long-Running Operations (Performance):* Long-running operations (for example consistency checks) shall run asynchronously, and UI updates shall be incremental instead of full reloads.
- *QA7 Extensible Review Model (Supportability):* The core review model shall support new AI-generated comment types without redesigning the thread workflow, storage model, or editor interaction.
- *QA8 Stable Integration Boundaries (Supportability):* The architecture shall isolate comment-type-specific logic from the shared thread lifecycle, and the architecture shall keep integration with existing Artemis workflows stable as extensions are added.

=== Constraints

#TODO[
  List and describe all pseudo requirements of your system. Also mention requirements that you were not able to realize.

  - C1 Category: Short Description. 
  - C2 Category: Short Description. 
  - C3 Category: Short Description. 

]

Constraints define limitations and boundary conditions under which the system must operate. Technical, organizational, and external factors typically impose these limitations and influence architecture and design decisions without describing functional behavior directly #cite(<bruegge2004object>). Bruegge and Dutoit group constraints into implementation, interface, and operations requirement categories, and this thesis uses the same grouping below. This thesis currently excludes packaging and legal requirement categories from the prototype scope.

- *C1 Platform Constraint (Implementation Requirement):* The implementation shall stay within the existing Artemis client-server architecture and codebase.
- *C2 Persistence and Compatibility Constraint (Interface Requirement):* Artemis shall persist review data in the Artemis database and keep that data compatible with Artemis migration workflows and supported database configurations.
- *C3 Role Constraint (Operations Requirement):* Artemis shall restrict review functionality during operation to authorized teaching roles (editor level and above).
- *C4 Prompt Data Minimization Constraint (Operations Requirement):* Artemis shall include only the data required for the specific consistency check in LLM prompts, and Artemis shall keep prompt payloads as short as possible to reduce token usage while preserving sufficient context for reliable results.

== System Models
#TODO[
  This section includes important system models for the requirements.
]
This section uses system models to illustrate the requirements from multiple perspectives. Scenarios describe concrete usage situations, and they are split into two types: visionary scenarios describe a target workflow with extended capabilities, while demo scenarios describe workflows implemented in this thesis. The use case model captures actor-system interactions, the analysis object model defines core domain concepts and relationships, and the dynamic model explains the workflow over time. The user interface section complements these models with visual representations of key interactions.

=== Scenarios
#TODO[
  If you do not distinguish between visionary and demo scenarios, you can remove the two subsubsections below and list all scenarios here.

  *Visionary Scenarios*
  Describe 1-2 visionary scenario here, i.e. a scenario that would perfectly solve your problem, even if it might not be realizable. Use free text description.

  *Demo Scenarios*
  Describe 1-2 demo scenario here, i.e. a scenario that you can implement and demonstrate until the end of your thesis. Use free text description.
]

#par(first-line-indent: 0pt)[*Visionary Scenario 1 - Automatic Revision Support*]
Nina, an experienced instructor for Software Engineering, prepares a complex programming exercise for the upcoming semester. She opens the exercise editor in Artemis, runs a consistency check, and the system automatically applies the suggested code changes across the problem statement, template, solution, and tests. The review threads explain each change in context through their initial consistency comments, highlight the affected lines, and summarize the rationale so Nina can verify the result without additional steps.

After the update, the system keeps the resolved threads linked to the new exercise version and shows which changes resulted from the automated fixes. Nina scans the overview list, confirms that no high-severity consistency issues remain, checks a few review threads for clarity, and continues refining the exercise content. This visionary scenario outlines a future state in which consistency support during exercise creation becomes largely automatic while still keeping instructors in control through transparent review threads and history across exercise versions.

#par(first-line-indent: 0pt)[*Visionary Scenario 2 - LLM-Assisted Exercise Expansion*]
Kai, an instructor for Software Architecture, wants to expand an exercise with an additional design-pattern task. He adds a comment in a review thread that describes the new requirement and the expected learning outcome. The system sends the comment to the LLM and returns code suggestions that extend the problem statement, template, solution, and tests to match the new task. The review thread explains the proposed changes and highlights the new sections so Kai can review the expansion in context. This visionary scenario shows how instructors can use comments in review threads to request substantial exercise extensions while keeping the process transparent and aligned with their intent.

#pagebreak()
#par(first-line-indent: 0pt)[*Demo Scenario 1 - Collaborative Review without Consistency Check*]

Lea and Omar, two instructors for Software Engineering, review a new programming exercise before the semester starts. Lea spots an ambiguous requirement in the problem statement and adds a comment in a review thread at the exact line, proposing clearer wording and a concrete example. Omar opens the review thread, asks for a minor adjustment, and adds a follow-up suggestion that aligns the wording with the template variables. Lea agrees with this suggestion, updates the text, and marks the thread as resolved.

During the same review, Omar notices that the expected input format appears in the template but not in the tests. He adds a second comment. After adding the test, he updates the thread state to resolved, and Lea sees the status change immediately. This interaction demonstrates how instructors use the review system to coordinate improvements without running a consistency check.

#par(first-line-indent: 0pt)[*Demo Scenario 2 - Review with Consistency Check and Applied Fixes*]

Sofia, an instructor for Software Architecture, runs a consistency check on a multi-file exercise. The system returns review threads inline in the editor, each starting with a consistency comment labeled with severity, affected location, and a suggested fix description. Sofia opens the overview list, filters for high-severity consistency issues, and navigates to a thread that flags a consistency issue between the problem statement and the solution signature. She opens the suggested code-change preview, compares it with the current code, and applies the change with one click. The system updates the file, records the applied change, and marks the thread as resolved.

Sofia then reviews a second thread that proposes an edit in the test file. She notices that the file has changed since the consistency check, and the system warns that the thread is outdated. She reruns the consistency check, receives an updated thread, and applies the corrected fix. The system keeps the review threads in their resolved state, and the overview confirms that no high-severity consistency issues remain.

=== Use Case Model
#TODO[
  This subsection should contain a UML Use Case Diagram including roles and their use cases. You can use colors to indicate priorities. Think about splitting the diagram into multiple ones if you have more than 10 use cases. *Important:* Make sure to describe the most important use cases using the use case table template (./tex/use-case-table.tex). Also describe the rationale of the use case model, i.e. why you modeled it like you show it in the diagram. Make sure to describe the most important use cases using the use case table template (./tex/use-case-table.tex).

]
This subsection models the review workflow using the structure proposed by Bruegge and Dutoit #cite(<bruegge2004object>). It identifies the main actors, defines the system's primary interactions, and explains the rationale behind the modeling choices.

The primary actors are Instructor and Editor. Instructors and editors use the review system to discuss threads, resolve consistency issues in programming exercises, and incorporate LLM-based consistency feedback. All interactions occur within the Artemis programming exercise editor, where review threads provide the shared interface for collaboration and resolution.

#par(first-line-indent: 0pt)[*Basic Review Collaboration Use Cases*]

#figure(   
  image("../figures/UseCaseDefault.pdf", width: 95%),                                    
  caption: [Basic Review Collaboration Use Cases. The diagram shows thread creation, discussion, and resolution in the base workflow.],
) <UseCaseBasic>

#ref(<UseCaseBasic>) models the core review mechanisms without consistency checks as five main user paths: starting a thread, adding a comment, editing a comment, deleting a comment, and toggling a thread as resolved. Starting a thread includes adding the initial comment, because a thread is only valid when it contains at least one comment. Instructors and editors can also add comments to existing threads. Toggling a thread as resolved includes hiding the thread in the editor to keep code editing unobstructed. Deleting a comment also deletes its thread when the removed comment is the last remaining entry in that thread, so the system does not keep empty threads.

The model focuses on thread lifecycle management in the editor. It makes explicit how collaborative actions change thread state, preserve discussion context, and keep review decisions visible to instructors and editors.

#par(first-line-indent: 0pt)[*Consistency Check Review Use Cases*]

#figure(   
  image("../figures/UseCaseConsistency.pdf", width: 95%),                                    
  caption: [Consistency-Check Review Use Cases. The diagram shows consistency checking, issue navigation, and optional application of suggested code changes.],
) <UseCaseConsistency>

#ref(<UseCaseConsistency>) structures the consistency workflow around two main use cases: checking consistency and jumping to a consistency issue. Checking consistency serves as the entry point and provides the detected issues that instructors and editors then address through issue navigation. Jumping to a consistency issue extends to applying a code change only when an instructor or editor accepts the proposed fix. Applying a code change includes toggling the related thread as resolved, because the accepted fix resolves that consistency issue.

This model separates consistency check execution from follow-up actions on individual consistency issues. Artemis runs the consistency check first, and instructors and editors then navigate to consistency issues to inspect and resolve them. This keeps the consistency workflow transparent and preserves human control over whether and when instructors and editors apply suggested code changes.

=== Analysis Object Model
#TODO[
  This subsection should contain a UML Class Diagram showing the most important objects, attributes, methods and relations of your application domain including taxonomies using specification inheritance (see #cite(<bruegge2004object>)). Do not insert objects, attributes or methods of the solution domain. *Important:* Make sure to describe the analysis object model thoroughly in the text so that readers are able to understand the diagram. Also write about the rationale how and why you modeled the concepts like this.

]


The analysis object model in #ref(<AOM>) describes the core domain concepts of the review system and their relationships. A ProgrammingExercise contains one ProblemStatement and three or more ExerciseRepositories, and each ExerciseRepository aggregates Files. A File contains text and a path, and together with the ProblemStatement it provides the context in which the system shows review Threads.

#figure(   
  image("../figures/AOM Diagram.pdf", width: 95%),                                    
  caption: [Analysis Object Model of the Review Domain. The model shows core entities and relations for exercises, files, threads, and comment types.],
) <AOM>

A Thread captures a discussion at a specific line. It stores its resolution state, outdated state, and lineNumber, and it provides operations for anchoring itself in the problem statement or in a file and for managing its state. Both Files and the ProblemStatement can show multiple Threads. Each Thread composes one or more Comments, which ensures that comments do not exist without a parent thread.

Comment acts as an abstract superclass with a shared text attribute and allows additional comment types in the future. The model distinguishes two concrete comment types: UserComment represents user-written discussion and stores an author, while ConsistencyComment represents consistency issues and carries severity, category, and codeChange information with an applyCodeChange action. This specialization captures the different semantics of manual review and automated consistency feedback while keeping the discussion structure uniform.

The model additionally includes a ConsistencyChecker that runs consistency checks on exercise content. The checker evaluates a ProgrammingExercise with stored instructions and creates ConsistencyComments. These comments use the same thread structure as manual feedback. ProblemStatement and File provide editing operations for regular authoring changes before and after checks. This design keeps responsibilities clear and keeps one review workflow for manual discussion and automated consistency findings.

=== Dynamic Model
#TODO[
  This subsection should contain dynamic UML diagrams. These can be a UML state diagrams, UML communication diagrams or UML activity diagrams.*Important:* Make sure to describe the diagram and its rationale in the text. *Do not use UML sequence diagrams.*
]
The activity diagram in #ref(<ACTDIA>) models the dynamic behavior of the review workflow across the Instructor, Artemis, and Hyperion. The process starts when the Instructor clicks “Check Consistency”, Artemis forwards the request to Hyperion, and Hyperion either finds no consistency issues or returns consistency issues. When Artemis receives consistency issues, it creates or updates review threads and shows them inline so the Instructor can jump to each one.

For every consistency issue, the Instructor first jumps to it and then decides whether the suggested code fix makes sense. When it does not make sense, the Instructor changes the code manually. When it does make sense, the Instructor presses “Apply”, and Artemis applies the changes to the exercise. In both cases, the Instructor then presses “Resolve”, after which Artemis stores the resolved state and hides the thread.

After resolving a consistency issue, the Instructor presses “Submit”, and Artemis saves the exercise and creates a new exercise version. The workflow then checks whether more consistency issues remain unresolved. If more consistency issues remain unresolved, the workflow loops back to the next consistency issue. Otherwise, the workflow ends. This model highlights the human-in-the-loop control flow and shows how Artemis stores review threads, resolution state, and exercise versions across the review process.

#figure(   
  image("../figures/Activity Diagram.pdf", width: 95%),                                    
  caption: [Activity Diagram of the Consistency Review Workflow. The diagram shows consistency check execution, consistency-issue review, fix decisions, resolution, and submission.],
) <ACTDIA>

=== User Interface
#TODO[
  Show mockups of the user interface of the software you develop and their connections / transitions. You can also create a storyboard. *Important:* Describe the mockups and their rationale in the text.
]
The interface reuses interaction patterns that instructors and editors already know from code-review tools. In #ref(<UICommentThread>), Artemis anchors each thread to a specific repository, file and line, shows comments in chronological order, and keeps reply and resolve actions in the same panel. This structure keeps code context and discussion context together during review.

Each comment provides a compact three-dot menu for comment-level actions such as editing and deleting. At the bottom of the thread, a reply input bar supports quick follow-up messages, and the action row below it provides explicit Reply and Resolve controls. This combination keeps the interaction flow clear: discuss first, then either continue the thread or close it.

#figure(
  image("../figures/Comment Mockup.pdf", width: 80%),
  caption: [Comment-Thread Interaction Mockup. The mockup shows inline discussion with comment actions, reply input, and resolve control.],
) <UICommentThread>

For the overview UI, the editor needed a dedicated space to list and filter comments. The mockup in #ref(<UIOverview>) builds on the existing Artemis editor layout, which previously used two sidebars (left and right). In the revised layout, the right sidebar is removed and the left sidebar is transformed into a tab view. This keeps interaction patterns familiar from common editor interfaces, but is not tied to one specific tool.

The tab-based sidebar improves extensibility because additional views can be added as new tabs instead of introducing more fixed sidebars. At the same time, removing the right sidebar increases the space available for the main editor, which improves readability during review and code editing.

#figure(
  image("../figures/UI Mockups/One-Sided Comments.png", width: 100%),
  caption: [Comment Overview and Navigation Mockup. The mockup shows tab-based listing, filtering, and fast navigation while preserving editor space.],
) <UIOverview>
