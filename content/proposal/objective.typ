#import "/utils/todo.typ": TODO

= Objective
#TODO[ // Remove this block
  *Proposal Objective*
  - Define the main goals of your thesis clearly and concisely.
  - Start with a short overview where you enumerate the goals as bullet points, using action-oriented phrasing (e.g., 1., 2., 3., ...).
  - Avoid the gerund form for verbs (e.g., "Developing Feature XYZ") and noun phrases (e.g., "Feature XYZ Development"). Instead, use action-oriented language such as "Develop Feature XYZ", similar to how you would formulate use cases in UML use case diagrams.
  - Ensure your goals are concrete and specific, avoiding generic statements. Clearly state what you aim to achieve.
  - Expand on each goal in a dedicated subsection. Repeat the corresponding enumerated bullet point number to maintain consistency and provide at least two paragraphs explaining the goal. Focus on being precise and specific in your descriptions.
]

To achieve these outcomes, we define set of concrete objectives that guide the implementation. Each objective addresses a key improvement for creating and maintaining programming exercises: providing persistent consistency checks, enabling direct integration of code changes, and offering intuitive support for human-in-the-loop review. The objectives are as follows:
+ Add Inline Comments and Navigation Options
+ Implement Persistent Storage and Collaboration
+ Propose Inline Code Improvements

== Add Inline Comments and Navigation Options

The first goal is to enhance the interface for displaying consistency check results and make them directly actionable. Currently, Artemis only shows the raw JSON returned by the LLM request, which instructors must interpret manually. The improved interface visualizes this data as inline comments within the text editor, giving instructors immediate context while reviewing an exercise. #ref(<Problem>) shows a mockup of a comment highlighting an identified inconsistency directly at the relevant line of code, together with its severity, description, and suggested fix.

Each comment clearly describes the identified issue, explain how it can be resolved, and indicate the affected lines of code, along with its severity level to help instructors prioritize their actions. When instructors rerun a consistency check, the interface automatically updates existing comments to reflect new results or remove resolved ones, ensuring that the displayed feedback always matches the current state of the exercise. This approach transforms the static JSON output into an interactive, structured review experience directly inside the exercise editor.

#figure(
  image("../../figures/CodeExample1.PNG", width: 80%),
  caption: [Mockup of the interface demonstrating how Artemis displays consistency issues as inline comments within the template repository, including severity, description, and suggested fixes.],
) <Problem>

A dropdown menu also summarizes all detected inconsistencies to give instructors a clear overview of the entire exercise. The menu lists each issue along with its severity level, affected files, and line ranges, allowing instructors to quickly assess the overall state of the exercise. The dropdown also includes filtering and sorting options, such as by severity, component (problem statement, template, solution, or tests), or issue category. This overview enables instructors to manage the review process more efficiently, prioritize critical inconsistencies, and keep track of which issues have been addressed or remain unresolved.

== Implement Persistent Storage and Collaboration

The next goal is to extend Artemis’s internal data management architecture to support persistent storage of consistency issues and LLM-generated suggestions. Currently, detected inconsistencies exist only temporarily within the client-side session after the user executes a consistency check. Once the page is reloaded, the results are lost, and instructors must repeat the process to retrieve them. 

To address this limitation, the server-side model expands to include a dedicated database entity for consistency issues, linked to the corresponding exercise, file, and exercise version. Each issue entry stores the description, severity, category, suggested fix, affected line range, and timestamps, ensuring that results can be queried and restored later.

In addition to persistence, this goal introduces concurrent collaboration support for reviewing and managing consistency data. Multiple instructors can open and annotate the same exercise simultaneously without losing or overwriting each other’s comments. A synchronization mechanism ensures that issue status updates, resolutions, or deletions are propagated immediately to all active users. A conflict-handling strategy prevents race conditions, such as two users marking the same issue as resolved/discarded at once.

== Propose Inline Code Improvements

The third goal is to extend Artemis to support not only the detection of inconsistencies but also their automatic resolution through inline code suggestions. When a consistency check is executed, the LLM response also includes structured code modification proposals in addition to issue descriptions. Each suggestion specifies the file path, affected line range, and replacement snippet that implements the proposed fix. The database stores this data together with the issue, allowing Artemis to associate each inconsistency with its corresponding suggested correction. Within the exercise editor, instructors can preview these suggestions inline, viewing the existing and modified code side by side.

The system also provides mechanisms for applying or discarding suggestions directly from the editor. When an instructor accepts a suggestion, Artemis replaces the existing code with the suggestion and automatically create a new exercise version. The implementation includes validation and conflict checks to ensure that suggestions remain consistent with the current state of the file, even if it has been modified since the check was generated. This approach reduces repetitive manual editing, accelerates the review process, and allows instructors to focus on conceptual validation while the system handles mechanical consistency corrections. 
#ref(<Diagram>) illustrates the improved process for refactoring consistency issues within an exercise. It shows how instructors interact with Artemis and how they will remove consistency issues from an exercise. For clarity, the diagram omits concurrent access.
