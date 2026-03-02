#import "/utils/todo.typ": TODO

= Requirements
#TODO[
  This chapter follows the Requirements Analysis Document Template in @bruegge2004object. Important: Make sure that the whole chapter is independent of the chosen technology and development platform. The idea is that you illustrate concepts, taxonomies and relationships of the application domain independent of the solution domain! Cite @bruegge2004object several times in this chapter.

]
This chapter examines the requirements for integrating AI-assisted review into Artemis. We follow the design process described by Bruegge and Dutoit #cite(<bruegge2004object>). First, we define the scope and highlight the major objectives of the proposed system. We then describe the existing system before detailing the functional requirements and quality attributes in the Proposed System section. Finally, the System Models section describes system models to illustrate the concepts further.

== Overview
#TODO[
  Provide a short overview about the purpose, scope, objectives and success criteria of the system that you like to develop.
]
This section summarizes the purpose and scope of the proposed system and outlines its objectives and success criteria. The system aims to support instructors and editors in reviewing programming exercises by turning LLM-based consistency checks into persistent, actionable review comments. Its scope covers detecting inconsistencies across problem statement, template, solution, and tests, and managing their review lifecycle within Artemis. The objectives are to introduce a review comment system with persistence across exercise versions, provide clear inline issue presentation and navigation, and enable instructors and editors to preview and apply suggested code changes under human control. The system is considered successful if it reduces review effort, improves transparency of inconsistencies, and is judged usable by instructors and editors in evaluation.

== Existing System
#TODO[
  This section is only required if the proposed system (i.e. the system that you develop in the thesis) should replace an existing system.
]
Artemis already supports LLM-based consistency checks for programming exercises through the Hyperion module. Hyperion integrates via Spring AI and provides an AI-driven exercise creation assistant that helps instructors and editors create high-quality exercises more efficiently, including consistency checking. An instructor or editor can trigger a check that compares the problem statement, template, solution, and tests and returns a structured JSON list of detected inconsistencies, including severity, categories, and suggested fix descriptions. The current interface exposes this output as raw JSON, so instructors and editors must manually interpret the results, locate the affected files and lines, and apply corrections themselves.

The existing system does not persist consistency results. Once the page is reloaded or the exercise version changes, the detected issues are lost and the check must be rerun. There is also no review comment mechanism to track resolution status or discussion over time, which makes it difficult to maintain consistency across iterations and coordinate among multiple instructors.

== Proposed System
#TODO[
  If you leave out the section “Existing system”, you can rename this section into “Requirements”.
]

The proposed system extends Artemis with a review-centric consistency workflow that turns Hyperion's LLM findings into persistent, actionable artifacts. The system models consistency issues as review comments and stores them with the exercise and the corresponding exercise version, so instructors and editors can track, discuss, and resolve issues over time. The system presents issues inline with clear metadata, provides overview navigation, and lets instructors and editors preview and apply suggested code changes while keeping human control over final changes. Overall, the system aims to improve the transparency, efficiency, and reliability of exercise creation without changing the pedagogical intent of the exercises.

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
- *FR9 Update Thread Line References for New Exercise Versions:* The system shall update thread line references when a new exercise version is created so existing threads remain linked to the correct locations in the updated files.
- *FR10 Mark Threads as Outdated on Content Changes:* The system shall detect when the underlying line content at a thread’s referenced line location has changed and mark the thread as outdated to signal that the context may no longer match.
- *FR11 Propagate Review Updates to Active Clients:* The system shall propagate thread and comment updates to other active clients that are working on the same exercise.

These requirements define the baseline review workflow, independent of how issues are discovered.

#par(first-line-indent: 0pt)[*Specific Consistency Issue Functionality*]

- *FR12 Create Review Comments from Consistency Checks:* The system shall convert Hyperion consistency check results into review comments linked to the affected file and line range.
- *FR13 Provide Code-Change Previews:* The system shall present suggested code changes side by side with the current content to enable review before changes.
- *FR14 Apply Suggested Code Changes:* The system shall allow instructors and editors to apply a suggested code change and update the exercise content accordingly.
- *FR15 Validate Suggested Code Changes:* The system shall check that a suggested code change still matches the current file context before applying it.
- *FR16 Provide Consistency Issue Overview and Navigation:* The system shall provide an overview list of detected consistency issues and allow instructors and editors to jump from this list to the corresponding locations in the editor.

These requirements define the consistency-check-specific workflow and ensure that instructors and editors retain control over final changes while reducing manual edits.

=== Quality Attributes
#TODO[
  List and describe all quality attributes of your system. All your quality attributes should fall into the URPS categories mentioned in @bruegge2004object. Also mention requirements that you were not able to realize.

  - QA1 Category: Short Description. 
  - QA2 Category: Short Description. 
  - QA3 Category: Short Description.

]
This section details the quality attributes of the proposed system and defines criteria for evaluating operational performance and user experience. The attributes follow the URPS categories described by #cite(<bruegge2004object>).

- *QA1 Unobtrusive Inline Review (Usability):* Inline review elements shall remain unobtrusive during editing and shall not unnecessarily block code content.
- *QA2 Clear Thread Visibility and State (Usability):* Thread location and status shall be immediately recognizable through consistent indicators and labels (for example open, resolved, outdated).
- *QA3 Safe Change Application (Reliability):* Suggested code changes shall only be applied after explicit confirmation and successful context validation; otherwise, no content shall be modified.
- *QA4 Consistent Review State (Reliability):* Thread and comment states shall remain consistent across persistence, reloads, exercise-version updates, and concurrent client updates, with clear feedback on failures.
- *QA5 Responsive Editor Interaction (Performance):* Editing interactions (typing, scrolling, cursor movement, thread expand/collapse, and issue navigation) shall remain responsive and non-blocking.
- *QA6 Asynchronous Long-Running Operations (Performance):* Long-running operations (for example consistency checks) shall run asynchronously, and UI updates shall be incremental instead of full reloads.
- *QA7 Extensible Review Model (Supportability):* The core review model shall support new AI-generated comment types without redesigning the thread workflow, storage model, or editor interaction.
- *QA8 Stable Integration Boundaries (Supportability):* Comment-type-specific logic shall remain isolated from the shared thread lifecycle, and integration with existing Artemis workflows shall remain stable as extensions are added.

=== Constraints

#TODO[
  List and describe all pseudo requirements of your system. Also mention requirements that you were not able to realize.

  - C1 Category: Short Description. 
  - C2 Category: Short Description. 
  - C3 Category: Short Description. 

]

Constraints define limitations and boundary conditions under which the system must operate. They are typically imposed by technical, organizational, or external factors and influence architecture and design decisions without describing functional behavior directly #cite(<bruegge2004object>). The following constraints summarize the key conditions identified for this thesis.

- *C1 Platform Constraint:* The solution shall be implemented within the existing Artemis client-server architecture and codebase.
- *C2 Role Constraint:* Review functionality shall be restricted to authorized teaching roles (editor level and above).
- *C3 Persistence and Compatibility Constraint:* Review data shall be persisted in the Artemis database and remain compatible with Artemis migration workflows and supported database configurations.
- *C4 Prompt Data Minimization Constraint:* LLM prompts shall include only the data required for the specific consistency check, and prompt payloads shall be kept as short as possible to reduce token usage while preserving sufficient context for reliable results.

== System Models
#TODO[
  This section includes important system models for the requirements.
]
This section uses system models to illustrate the requirements from multiple perspectives. Scenarios describe concrete usage situations, the use case model captures actor-system interactions, the analysis object model defines core domain concepts and relationships, and the dynamic model explains the workflow over time. The user interface section complements these models with visual representations of key interactions.

=== Scenarios
#TODO[
  If you do not distinguish between visionary and demo scenarios, you can remove the two subsubsections below and list all scenarios here.

  *Visionary Scenarios*
  Describe 1-2 visionary scenario here, i.e. a scenario that would perfectly solve your problem, even if it might not be realizable. Use free text description.

  *Demo Scenarios*
  Describe 1-2 demo scenario here, i.e. a scenario that you can implement and demonstrate until the end of your thesis. Use free text description.
]

#par(first-line-indent: 0pt)[*Visionary Scenario 1 - Automatic Revision Support*]
Nina, an experienced instructor for Software Engineering, prepares a complex programming exercise for the upcoming semester. She opens the exercise editor in Artemis, runs a consistency check, and the system automatically applies the suggested code changes across the problem statement, template, solution, and tests. The review comments explain each change in context, highlight the affected lines, and summarize the rationale so Nina can verify the result without additional steps.

After the update, the system keeps the resolved comments linked to the new exercise version and shows which changes resulted from the automated fixes. Nina scans the overview list to confirm that all high-severity issues are resolved, checks a few comment threads for clarity, and continues refining the exercise content. This visionary scenario outlines a future state in which consistency support during exercise creation becomes largely automatic while still keeping instructors in control through transparent review comments and history across exercise versions.

#par(first-line-indent: 0pt)[*Visionary Scenario 2 - LLM-Assisted Exercise Expansion*]
Kai, an instructor for Software Architecture, wants to expand an exercise with an additional design-pattern task. He adds a review comment that describes the new requirement and the expected learning outcome. The system sends the comment to the LLM and returns code suggestions that extend the problem statement, template, solution, and tests to match the new task. The review thread explains the proposed changes and highlights the new sections so Kai can review the expansion in context. This visionary scenario shows how instructors can use review comments to request substantial exercise extensions while keeping the process transparent and aligned with their intent.

#par(first-line-indent: 0pt)[*Demo Scenario 1 - Collaborative Review without Consistency Check*]

Lea and Omar, two instructors for Software Engineering, review a new programming exercise before the semester starts. Lea spots an ambiguous requirement in the problem statement and adds a review comment at the exact line, proposing clearer wording and a concrete example. Omar opens the comment thread, asks for a minor adjustment, and adds a follow-up suggestion that aligns the wording with the template variables. Lea agrees with this suggestion, updates the text, and marks the comment as resolved.

During the same review, Omar notices that the expected input format appears in the template but not in the tests. He adds a second comment. After adding the test, he updates the comment state to resolved, and Lea sees the status change immediately. This interaction demonstrates how instructors use the review system to coordinate improvements without running a consistency check.

#par(first-line-indent: 0pt)[*Demo Scenario 2 - Review with Consistency Check and Applied Fixes*]

Sofia, an instructor for Software Architecture, runs a consistency check on a multi-file exercise. The system returns review comments inline in the editor, each labeled with severity, affected location, and a suggested fix description. Sofia opens the overview list, filters for high-severity issues, and navigates to a comment that flags a mismatch between the problem statement and the solution signature. She opens the suggested code-change preview, compares it with the current code, and applies the change with one click. The system updates the file, records the applied change, and marks the comment as resolved.

Sofia then reviews a second comment that proposes an edit in the test file. She notices that the file has changed since the check and the system warns about a mismatch. She reruns the check, receives an updated comment, and applies the corrected fix. After a page reload, the review comments persist with their resolved status, and the overview confirms that no high-severity issues remain.

=== Use Case Model
#TODO[
  This subsection should contain a UML Use Case Diagram including roles and their use cases. You can use colors to indicate priorities. Think about splitting the diagram into multiple ones if you have more than 10 use cases. *Important:* Make sure to describe the most important use cases using the use case table template (./tex/use-case-table.tex). Also describe the rationale of the use case model, i.e. why you modeled it like you show it in the diagram. Make sure to describe the most important use cases using the use case table template (./tex/use-case-table.tex).

]
To model the review workflow, this subsection follows the structure proposed by Bruegge and Dutoit #cite(<bruegge2004object>). It identifies the main actors, defines the system's primary interactions, and explains the rationale behind the modeling choices.

The primary actors are Instructor and Editor. Instructors and editors use the review system to discuss and resolve issues in programming exercises and to incorporate LLM-based consistency feedback. All interactions occur within the Artemis programming exercise editor, where review comments provide the shared interface for collaboration and resolution.

#par(first-line-indent: 0pt)[*Basic Review Collaboration Use Cases*]

The first diagram models the core review mechanisms without consistency checks as six main user paths: starting a thread, adding a comment, editing a comment, deleting a comment, toggling a thread as resolved, and submitting changes. The model captures the key dependencies between these paths: starting a thread includes creating the initial comment, deleting a comment extends deleting a thread, and toggling a thread as resolved includes hiding the thread from active review views.

It also links review actions to exercise changes. Submitting changes includes creating a new exercise version, and that versioning step extends the update of thread line numbers and the marking of threads as outdated where context no longer matches. This structure keeps the basic review flow compact while making explicit how collaborative editing decisions propagate into version history and thread state management.

#figure(   
  image("../figures/UseCaseDefault.pdf", width: 95%),                                    
  caption: [Use case diagram for basic, collaborative reviewing.],
)

#par(first-line-indent: 0pt)[*Consistency Check Review Use Cases*]

The second diagram structures the consistency workflow around two main use cases: checking consistency and jumping to an issue. Checking consistency includes storing detected issues as review threads, and storing issues includes creating a thread group so generated threads are organized consistently. The jump-to-issue path is connected to applying code changes through an extend relation, and applying a code change includes toggling the related thread as resolved.

This model separates automated issue generation from follow-up actions on individual issues. The include relations capture the mandatory system behavior during check execution (issue persistence and grouping), while the extend relation captures optional fix application during navigation. This keeps the consistency workflow transparent and preserves human control over whether and when suggested changes are applied.

#figure(   
  image("../figures/UseCaseConsistency.pdf", width: 95%),                                    
  caption: [Use case diagram the review process with consistency checks.],
)

=== Analysis Object Model
#TODO[
  This subsection should contain a UML Class Diagram showing the most important objects, attributes, methods and relations of your application domain including taxonomies using specification inheritance (see #cite(<bruegge2004object>)). Do not insert objects, attributes or methods of the solution domain. *Important:* Make sure to describe the analysis object model thoroughly in the text so that readers are able to understand the diagram. Also write about the rationale how and why you modeled the concepts like this.

]


The analysis object model in #ref(<AOM>) describes the core domain concepts of the review system and their relationships. A ProgrammingExercise is composed of one ProblemStatement and three or more ExerciseRepositories, and each repository aggregates Files. A File contains text and a path, and together with the ProblemStatement it provides the context in which review Threads are shown.

#figure(   
  image("../figures/AOM Diagram.pdf", width: 95%),                                    
  caption: [Analysis Object Model for the review system.],
) <AOM>

A Thread captures a discussion at a specific line. It stores its resolution state, outdated state, and lineNumber, and it offers operations to add and manage comments. Both Files and the ProblemStatement can show multiple Threads. Each Thread composes one or more Comments, which ensures that comments do not exist without a parent thread.

Comment acts as an abstract superclass with a shared text attribute and allows additional comment types in the future. The model distinguishes two concrete comment types: UserComment represents user-written discussion and stores an author, while ConsistencyComment represents consistency findings and carries severity, category, and codeReplacement information with an applyReplacement action. This specialization captures the different semantics of manual review and automated consistency feedback while keeping the discussion structure uniform.

The model focuses on domain concepts that users reason about during review: exercises, the problem statement, repositories, files, threads, and comment types. It separates comment text and issue metadata from file context and thread state, which clarifies ownership. This structure keeps the review workflow consistent whether issues originate from manual discussion or from consistency checks.

=== Dynamic Model
#TODO[
  This subsection should contain dynamic UML diagrams. These can be a UML state diagrams, UML communication diagrams or UML activity diagrams.*Important:* Make sure to describe the diagram and its rationale in the text. *Do not use UML sequence diagrams.*
]
The activity diagram in #ref(<ACTDIA>) models the dynamic behavior of the review workflow across the Instructor, Artemis, and Hyperion. The process starts when the Instructor clicks “Check Consistency”, Artemis forwards the request to Hyperion, and Hyperion either finds no inconsistencies or returns consistency issues. When Artemis receives issues, it stores them as review comments and shows them inline so the Instructor can jump to each one.

For every issue, the Instructor first jumps to it and then decides whether the suggested code-fix makes sense. When it does not make sense, the Instructor changes the code manually. When it does make sense, the Instructor presses “Apply”, and Artemis applies the changes to the exercise. In both cases, the Instructor then presses “Resolve”, after which Artemis stores the resolved state and hides the comment.

After resolving an issue, the Instructor presses “Submit”, and Artemis saves the exercise and creates a new exercise version. The workflow then checks whether more issues are unresolved. If so, it loops back to the next issue; otherwise, it ends. This model highlights the human-in-the-loop control flow and the system’s role in storing review comments, resolution state, and exercise versions across the review process.

#figure(   
  image("../figures/Activity Diagram.pdf", width: 95%),                                    
  caption: [Activity Diagram for the review system.],
) <ACTDIA>

=== User Interface
#TODO[
  Show mockups of the user interface of the software you develop and their connections / transitions. You can also create a storyboard. *Important:* Describe the mockups and their rationale in the text.
]
The user interface aims for familiarity to reduce onboarding effort. The thread design in #ref(<UICommentThread>) uses a review pattern that is common across modern code and document review tools, without relying on a platform-specific layout. Comments are shown as a linear history within one thread so that discussion context stays visible from top to bottom.

Each comment provides a compact three-dot menu for comment-level actions such as editing and deleting. At the bottom of the thread, a reply input bar supports quick follow-up messages, and the action row below it provides explicit Reply and Resolve controls. This combination keeps the interaction flow clear: discuss first, then either continue the thread or close it.

#figure(
  image("../figures/Comment Mockup.pdf", width: 80%),
  caption: [Mockup of the comment-thread interaction.],
) <UICommentThread>

For the overview UI, the editor needed a dedicated space to list and filter comments. The mockup in #ref(<UIOverview>) builds on the existing Artemis editor layout, which previously used two sidebars (left and right). In the revised layout, the right sidebar is removed and the left sidebar is transformed into a tab view. This keeps interaction patterns familiar from common editor interfaces, but is not tied to one specific tool.

The tab-based sidebar improves extensibility because additional views can be added as new tabs instead of introducing more fixed sidebars. At the same time, removing the right sidebar increases the space available for the main editor, which improves readability during review and code editing.

#figure(
  image("../figures/UI Mockups/One-Sided Comments.png", width: 100%),
  caption: [Mockup of the overview UI to navigate between comments.],
) <UIOverview>
