#import "/utils/todo.typ": TODO

= Schedule
#TODO[ // Remove this block
  *Thesis Schedule*
  - When will the thesis Start
  - Create a rough plan for your thesis (separate the time in iterations with a length of 2-4 weeks)
  - Each iteration should contain several smaller work items - Again keep it high-level and make to keep your plan realistic
  - Make sure the work-items are measurable and deliverable, they should describe features that are vertically integrated
  - Do not include thesis writing or presentation tasks
]

The thesis will run from October 1, 2025 to the January 31, 2026, and splits into 4 development iterations. The first three iterations corresponds to a previously defined objectives and are split into several smaller work items that are measurable and deliverable.
- Objective 4.1 -> Iteration 5.1
- Objective 4.2 -> Iteration 5.2
- Objective 4.3 -> Iteration 5.3

#figure(
  image("../../figures/Diagram.pdf", width: 100%),
  caption: [UML activity diagram showing the workflow for detecting, reviewing, and resolving consistency issues, involving interactions between the instructor, Artemis, and the LLM service.],
) <Diagram>

== Inline Comments and Navigation (until 29.10.25)
- Replace raw JSON output textbox with inline comments in the text editor
- Add a dropdown menu that lists all detected inconsistencies
- Enable quick navigation from the dropdown to the corresponding code location

== Persistent Storage and Collaboration (until 26.11.25)
- Extend the database to persist consistency issues and suggestions across sessions
- Ensure issues remain linked to the correct code lines across exercise versions
- Add support for concurrent collaboration so multiple instructors can review and resolve issues simultaneously

== Suggestions and Auto-Implementation (until 31.12.25)
- Extend the JSON returned by the consistency check to include inline code suggestions
- Make inline comments interactive, allowing instructors to view suggestion details
- Show a preview of the proposed code changes
- Add buttons to “Apply” or “Discard” changes directly from the editor

== Finalization, Polish, Integration Testing (until 31.01.26)
- Write developer and user-facing documentation
- Write extensive tests to ensure stability
- Standardize UI for Artemis