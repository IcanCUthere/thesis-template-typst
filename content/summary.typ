#import "/utils/todo.typ": TODO

= Summary <chap-summary>
#TODO[
  This chapter includes the status of your thesis, a conclusion and an outlook about future work.
]

This chapter reports the current thesis status against the defined functional requirements and closes with a short conclusion and outlook.

== Status
#TODO[
  Describe honestly the achieved goals (e.g. the well implemented and tested use cases) and the open goals here. if you only have achieved goals, you did something wrong in your analysis.
]

This section summarizes the implementation status of the functional requirements. #ref(<FRStatusTable>) provides the detailed status overview. The symbols used are `✓` (fulfilled), `◐` (partially fulfilled), and `✗` (open).

#figure(
  table(
    columns: (1.2fr, 3.6fr, 0.8fr),
    inset: 6pt,
    align: (left, left, center),
    [*Requirement*], [*Title*], [*Status*],
    [FR1], [Create Review Threads and User Comments], [✓],
    [FR2], [Persist Review Threads], [✓],
    [FR3], [Reply to Threads], [✓],
    [FR4], [Edit User Comments], [✓],
    [FR5], [Delete Comments and Threads], [✓],
    [FR6], [Show Threads Inline in the Editor], [✓],
    [FR7], [Hide Review Threads in the Editor], [◐],
    [FR8], [Mark Threads as Resolved], [✓],
    [FR9], [Update Thread Line References for New Exercise Versions], [✓],
    [FR10], [Mark Threads as Outdated on Content Changes], [✓],
    [FR11], [Propagate Review Updates to Active Clients], [✓],
    [FR12], [Create Review Threads from Consistency Checks], [✓],
    [FR13], [Provide Code-Change Previews], [✓],
    [FR14], [Apply Suggested Code Changes], [✓],
    [FR15], [Validate Suggested Code Changes], [✓],
    [FR16], [Provide Consistency Issue Overview and Navigation], [◐],
  ),
  caption: [Functional Requirement Status Overview. The table summarizes fulfillment of FR1-FR16 as fulfilled, partially fulfilled, or open.],
) <FRStatusTable>

=== Realized Goals
#TODO[
  Summarize the achieved goals by repeating the realized requirements or use cases stating how you realized them.
]

This subsection summarizes the realized goals listed in #ref(<FRStatusTable>). The current implementation only partially fulfills two capabilities (FR7 and FR16); the Open Goals section discusses them in detail.

#par(first-line-indent: 0pt)[*Basic Review Functionality (FR1-FR11)*]
The implementation covers the core review workflow end to end. Instructors and editors can create threads, add and edit comments, reply in existing threads, and resolve threads in the editor workflow (FR1-FR6, FR8). The system stores review threads and comments persistently in the database with exercise linkage and lifecycle state, so review context remains available across sessions (FR2). The editor integrates inline thread rendering and uses line-based positioning (FR6). The editor provides thread visibility controls in collapsed form (FR7). When instructors or editors create new exercise versions, the system remaps thread line references to updated line positions and marks threads as outdated when context mapping indicates that the original line context is no longer reliable (FR9-FR10). For collaborative work, the system propagates updates to threads and comments to other active clients so concurrent reviewers stay synchronized (FR11). Existing backend integration tests and frontend service/component tests cover the central paths of this functionality.

#par(first-line-indent: 0pt)[*Consistency-Check Functionality (FR12-FR16)*]
The consistency-specific workflow uses the same review model. The system converts consistency issues from consistency checks into review threads, stores the issue details in the initial consistency comments, and links the review threads to affected file locations (FR12). For suggested code changes, the system provides a preview workflow and allows instructors and editors to apply updates in a controlled way after validating that each suggested code change still matches the current context (FR13-FR15).

=== Open Goals
#TODO[
  Summarize the open goals by repeating the open requirements or use cases and explaining why you were not able to achieve them. Important: It might be suspicious, if you do not have open goals. This usually indicates that you did not thoroughly analyze your problems.
]

#ref(<FRStatusTable>) shows that two requirements remain partially fulfilled. The current implementation only partially fulfills FR7 (hide review threads in the editor), because threads can collapse but cannot disappear completely from the editor view. Review elements therefore still occupy visible space in dense files and can interrupt continuous code editing, especially when many comments are concentrated in one area.

The current implementation also partially fulfills FR16 (consistency issue overview and navigation). It provides a consistency-focused navigation component with previous/next traversal and severity-based ordering, but it does not provide a unified overview across all thread types or configurable ordering. This limits flexibility in larger review sessions, because instructors and editors cannot apply different prioritization strategies directly and still need multiple UI views to track all open discussion threads.

== Conclusion
#TODO[
  Recap shortly which problem you solved in your thesis and discuss your *contributions* here.
]

This thesis integrates a review system into the Artemis programming exercise editor and turns consistency-related work into a structured, persistent workflow for instructors and editors. Instead of handling raw JSON output from a consistency check manually, instructors and editors can review consistency issues in context, collaborate through review threads, and track resolution state across ongoing exercise refinement.

In addition, the thesis integrates consistency issues from consistency checks into the same review system, including consistency-issue visualization, controlled handling of suggested code changes, and navigation support. This improves transparency and reduces repetitive manual effort while keeping final decisions under human control. Overall, the implemented workflow represents a first step toward more automated exercise creation in Artemis, with clear opportunities for further expansion.

== Future Work
#TODO[
  Tell us the next steps (that you would do if you have more time). Be creative, visionary and open-minded here.
]

Future work should first close the remaining gaps of this thesis, especially the partially fulfilled requirements in #ref(<FRStatusTable>). This includes full thread-visibility control in the editor (beyond collapsing) and a unified, configurable overview that supports navigation across all thread types. Another extension could also allow instructors and editors to apply all suggested code changes of a thread group in one step instead of applying them thread by thread.

Beyond these near-term completions, the long-term direction is broader automation of exercise creation workflows. One next step is comment-driven expansion, where instructors and editors can write intent as comments in review threads and let the system generate coordinated updates across the problem statement, template, solution, and tests.

An additional step is a more autonomous consistency workflow: after running a consistency check, the system could apply selected fixes automatically and leave review threads that document what changed and why through their initial consistency comments and follow-up discussion. In this direction, review threads evolve from a purely manual discussion tool into a structured control and traceability layer for increasingly automated exercise creation.
