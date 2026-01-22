#import "/utils/todo.typ": TODO

= Requirements
#TODO[
  This chapter follows the Requirements Analysis Document Template in @bruegge2004object. Important: Make sure that the whole chapter is independent of the chosen technology and development platform. The idea is that you illustrate concepts, taxonomies and relationships of the application domain independent of the solution domain! Cite @bruegge2004object several times in this chapter.

]
This chapter examines the requirements for integrating AI-assisted review into Artemis. We follow the design process described by Bruegge and Dutoit #cite(<bruegge2004object>). First, we define the scope and highlight the major objectives of the proposed system. We then describe the existing system before detailing the functional and non-functional requirements in the Proposed System section. Finally, the System Models section describes system models to illustrate the concepts further.

== Overview
#TODO[
  Provide a short overview about the purpose, scope, objectives and success criteria of the system that you like to develop.
]
This section summarizes the purpose and scope of the proposed system and outlines its objectives and success criteria. The system aims to support instructors in reviewing programming exercises by turning LLM-based consistency checks into persistent, actionable review comments. Its scope covers detecting inconsistencies across problem statement, template, solution, and tests, and managing their review lifecycle within Artemis. The objectives are to introduce a review comment system with persistence across versions, provide clear inline issue presentation and navigation, and enable instructors to preview and apply suggested fixes under human control. The system is considered successful if it reduces review effort, improves transparency of inconsistencies, and is judged usable by instructors in evaluation.

== Existing System
#TODO[
  This section is only required if the proposed system (i.e. the system that you develop in the thesis) should replace an existing system.
]
Artemis already supports LLM-based consistency checks for programming exercises through the Hyperion module. Hyperion integrates via Spring AI and provides an AI-driven exercise creation assistant that helps instructors create high-quality exercises more efficiently, including consistency checking. An instructor can trigger a check that compares the problem statement, template, solution, and tests and returns a structured JSON list of detected inconsistencies, including severity, categories, and suggested fixes. The current interface exposes this output as raw JSON, so instructors must manually interpret the results, locate the affected files and lines, and apply corrections themselves.

The existing system does not persist consistency results. Once the page is reloaded or the exercise version changes, the detected issues are lost and the check must be rerun. There is also no review comment mechanism to track resolution status or discussion over time, which makes it difficult to maintain consistency across iterations and coordinate among multiple instructors.

== Proposed System
#TODO[
  If you leave out the section “Existing system”, you can rename this section into “Requirements”.
]

The proposed system extends Artemis with a review-centric consistency workflow that turns Hyperion's LLM findings into persistent, actionable artifacts. The system models consistency issues as review comments and stores them with the exercise and its version, so instructors can track, discuss, and resolve issues over time. The system presents issues inline with clear metadata, provides overview navigation, and lets instructors preview and apply suggested fixes while keeping human control over final changes. Overall, the system aims to improve the transparency, efficiency, and reliability of exercise maintenance without changing the pedagogical intent of the exercises.

=== Functional Requirements
#TODO[
  List and describe all functional requirements of your system. Also mention requirements that you were not able to realize. The short title should be in the form “verb objective”

  - FR1 Short Title: Short Description. 
  - FR2 Short Title: Short Description. 
  - FR3 Short Title: Short Description.
]

This section specifies the functional requirements of the review workflow. Each requirement describes a distinct capability the system must provide to support instructors in reviewing, discussing, and resolving consistency issues within Artemis.

#par(first-line-indent: 0pt)[*FR1 Review Comment Presentation and Navigation*]

- *FR1.1 Create Review Comments from Consistency Checks:* The system shall convert Hyperion consistency check results into review comments linked to the affected file and line range.
- *FR1.2 Display Inline Comments:* The system shall display review comments inline in the editor with severity, category, and suggested fix metadata.
- *FR1.3 Provide Issue Overview:* The system shall provide an overview list with filtering and navigation to each comment location.

These requirements ensure that instructors can understand and navigate inconsistencies efficiently.

#par(first-line-indent: 0pt)[*FR2 Persistent Storage and Collaboration*]

- *FR2.1 Persist Review Comments:* The system shall store review comments with the exercise and its version so instructors can revisit them across sessions.
- *FR2.2 Track Resolution State:* The system shall allow instructors to resolve, discard, or reopen comments and record these states.
- *FR2.3 Sync Concurrent Changes:* The system shall synchronize comment updates across concurrent instructor sessions to prevent lost edits.

These requirements ensure continuity and coordinated review workflows.

#par(first-line-indent: 0pt)[*FR3 Suggested Fix Preview and Application*]

- *FR3.1 Provide Fix Previews:* The system shall present suggested fixes side by side with the current content to enable review before changes.
- *FR3.2 Apply Suggested Fixes:* The system shall allow instructors to apply a suggested fix and update the exercise content accordingly.
- *FR3.3 Validate Suggestions:* The system shall check that a suggestion still matches the current file context before applying it.

These requirements ensure that instructors retain control over final changes while reducing manual edits.

=== Quality Attributes
#TODO[
  List and describe all quality attributes of your system. All your quality attributes should fall into the URPS categories mentioned in @bruegge2004object. Also mention requirements that you were not able to realize.

  - QA1 Category: Short Description. 
  - QA2 Category: Short Description. 
  - QA3 Category: Short Description.

]
This section details the quality attributes of the proposed system and defines criteria for evaluating operational performance and user experience. The attributes follow the URPS categories described by #cite(<bruegge2004object>).

#par(first-line-indent: 0pt)[*QA1 Usability*]
The system shall provide an intuitive interface that requires minimal technical expertise. The workflow shall guide instructors step by step, minimize cognitive load, and present consistent inline comments and previews that remain readable in common themes.

#par(first-line-indent: 0pt)[*QA2 Reliability*]
The system shall require instructor confirmation before applying changes. It shall handle incomplete or invalid inputs through clarifying prompts instead of failing, and it shall validate interactions with Artemis and Hyperion to maintain consistent behavior during transient failures.

#par(first-line-indent: 0pt)[*QA3 Performance*]
The system shall keep the review workflow responsive. It shall render inline comments and overviews quickly and avoid blocking interactions while it processes LLM results or loads persisted issues.

#par(first-line-indent: 0pt)[*QA4 Supportability and Integration*]
The system shall remain modular and align with existing Artemis integration conventions. It shall expose clear interfaces for future extensions and remain compatible with existing deployment environments with minimal reconfiguration.

=== Constraints

#TODO[
  List and describe all pseudo requirements of your system. Also mention requirements that you were not able to realize.

  - C1 Category: Short Description. 
  - C2 Category: Short Description. 
  - C3 Category: Short Description.

]

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
Nina, an experienced instructor for Software Engineering, prepares a complex programming exercise for the upcoming semester. She opens the exercise editor in Artemis, runs a consistency check, and the system automatically applies the suggested fixes across the problem statement, template, solution, and tests. The review comments explain each change in context, highlight the affected lines, and summarize the rationale so Nina can verify the result without additional steps.

After the update, the system keeps the resolved comments linked to the new exercise version and shows which changes resulted from the automated fixes. Nina scans the overview list to confirm that all high-severity issues are resolved, checks a few comment threads for clarity, and continues refining the exercise content. This visionary scenario outlines a future state in which consistency maintenance becomes largely automatic while still keeping instructors in control through transparent review comments and versioned history.

#par(first-line-indent: 0pt)[*Visionary Scenario 2 - LLM-Assisted Exercise Expansion*]
Kai, an instructor for Software Architecture, wants to expand an exercise with an additional design-pattern task. He adds a review comment that describes the new requirement and the expected learning outcome. The system sends the comment to the LLM and returns code suggestions that extend the problem statement, template, solution, and tests to match the new task. The review thread explains the proposed changes and highlights the new sections so Kai can review the expansion in context. This visionary scenario shows how instructors can use review comments to request substantial exercise extensions while keeping the process transparent and aligned with their intent.

#par(first-line-indent: 0pt)[*Demo Scenario 1 - Collaborative Review without Consistency Check*]

Lea and Omar, two instructors for Software Engineering, review a new programming exercise before the semester starts. Lea spots an ambiguous requirement in the problem statement and adds a review comment at the exact line, proposing clearer wording and a concrete example. Omar opens the comment thread, asks for a minor adjustment, and adds a follow-up suggestion that aligns the wording with the template variables. Lea accepts the suggestion, updates the text, and marks the comment as resolved. The system keeps the resolved thread attached to the exercise version so both instructors can revisit the rationale later.

During the same review, Omar notices that the expected input format appears in the template but not in the tests. He adds a second comment, links it to the missing test case, and assigns it to himself. After adding the test, he updates the comment state to resolved, and Lea sees the status change immediately. This interaction demonstrates how instructors use the review system to coordinate improvements without running a consistency check.

#par(first-line-indent: 0pt)[*Demo Scenario 2 - Review with Consistency Check and Applied Fixes*]

Sofia, an instructor for Software Architecture, runs a consistency check on a multi-file exercise. The system returns review comments inline in the editor, each labeled with severity, affected location, and a suggested fix. Sofia opens the overview list, filters for high-severity issues, and navigates to a comment that flags a mismatch between the problem statement and the solution signature. She opens the suggestion preview, compares it with the current code, and applies the fix with one click. The system updates the file, records the applied change, and marks the comment as resolved.

Sofia then reviews a second comment that proposes an edit in the test file. She notices that the file has changed since the check and the system warns about a mismatch. She reruns the check, receives an updated comment, and applies the corrected fix. After a page reload, the review comments persist with their resolved status, and the overview confirms that no high-severity issues remain.

=== Use Case Model
#TODO[
  This subsection should contain a UML Use Case Diagram including roles and their use cases. You can use colors to indicate priorities. Think about splitting the diagram into multiple ones if you have more than 10 use cases. *Important:* Make sure to describe the most important use cases using the use case table template (./tex/use-case-table.tex). Also describe the rationale of the use case model, i.e. why you modeled it like you show it in the diagram. Make sure to describe the most important use cases using the use case table template (./tex/use-case-table.tex).

]
To model the review workflow, this subsection follows the structure proposed by Bruegge and Dutoit #cite(<bruegge2004object>). It identifies the main actors, defines the system's primary interactions, and explains the rationale behind the modeling choices.

The Instructor serves as the central actor. Instructors use the review system to discuss and resolve issues in programming exercises and to incorporate LLM-based consistency feedback. All interactions occur within the Artemis programming exercise editor, where review comments provide the shared interface for collaboration and resolution.

#par(first-line-indent: 0pt)[*Basic Review Collaboration Use Cases*]

The first diagram models the core review mechanisms without consistency checks. Two instructors can start and reply to threads, edit or delete comments, and mark threads as resolved. The model emphasizes peer discussion and coordination on issues that instructors identify manually. It also shows that both instructors can participate in the same thread lifecycle, which supports shared ownership and accountability during exercise preparation.

This model highlights the review system as a collaboration layer within Artemis rather than a separate tool. By focusing on thread creation, replies, edits, deletions, and resolution, the diagram captures the minimal set of interactions needed to coordinate review work and document rationale over time.

#figure(   
  image("../figures/UseCaseBasic.pdf", width: 70%),                                    
  caption: [Use case diagram for basic, collaborative reviewing.],
)

#par(first-line-indent: 0pt)[*Consistency Check Review Use Cases*]

The second diagram focuses on review workflows that start with a consistency check. The Instructor runs a check, filters and jumps to threads, and applies code changes. The check includes the creation of review threads so detected issues enter the same review process. Applying a code change extends the resolution flow because the system can mark the thread as resolved after the change.

This model separates automated issue discovery from human decision-making. It makes clear that the system uses consistency checks to populate review threads, while instructors retain control over navigation, fixes, and resolution. The separation between check initiation, thread navigation, and code changes keeps the workflow transparent and aligns the automated assistance with established review practices.

#figure(   
  image("../figures/UseCaseConsistency.pdf", width: 70%),                                    
  caption: [Use case diagram the review process with consistency checks.],
)

=== Analysis Object Model
#TODO[
  This subsection should contain a UML Class Diagram showing the most important objects, attributes, methods and relations of your application domain including taxonomies using specification inheritance (see #cite(<bruegge2004object>)). Do not insert objects, attributes or methods of the solution domain. *Important:* Make sure to describe the analysis object model thoroughly in the text so that readers are able to understand the diagram. Also write about the rationale how and why you modeled the concepts like this.

]

#figure(   
  image("../figures/ClassDiagram.pdf", width: 95%),                                    
  caption: [Analysis Object Model for the review system.],
)

=== Dynamic Model
#TODO[
  This subsection should contain dynamic UML diagrams. These can be a UML state diagrams, UML communication diagrams or UML activity diagrams.*Important:* Make sure to describe the diagram and its rationale in the text. *Do not use UML sequence diagrams.*
]

=== User Interface
#TODO[
  Show mockups of the user interface of the software you develop and their connections / transitions. You can also create a storyboard. *Important:* Describe the mockups and their rationale in the text.
]
