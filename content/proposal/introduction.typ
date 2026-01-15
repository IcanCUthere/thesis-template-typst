#import "/utils/todo.typ": TODO


= Introduction
#TODO[ // Remove this block
  *Introduction*
  - Introduce the reader to the general setting (No Problem description yet)
  - What is the environment?
  - What are the tools in use?
  - (Not more than 1/2 a page)
]

Artemis is a learning platform widely used in higher education to support programming education through interactive exercises and automatic assessment #cite(<Krusche2018284>). It integrates with version-controlled repositories and continuous integration systems and has recently been extended with large language models (LLMs). Through Iris, the integrated LLM-based chatbot, students can receive explanations and guidance while solving exercises #cite(<Bassner2024394>).

In addition to student support, Artemis also allows instructors to use LLMs to review programming exercises. Each exercise consists of a problem statement, a template, a solution, and tests, which must remain consistent with each other. The system can query an LLM to detect inconsistencies and returns a structured JSON output describing each issue, its severity, and suggested fixes.

Existing human-in-the-loop research in education mainly focuses on grading and automated feedback for students #ref(<Funayama2022465>) #ref(<Shalinda2025>) while focusing on programming tasks #ref(<Xu2025469>) #ref(<Knipp2025379>) #ref(<Dosaru2025>) or on generating AI-based hints #ref(<Wolff2025897>) and assessments #ref(<Kituku2025>) with instructor oversight  . While these works highlight the value of combining AI with human review, they primarily address student-facing use cases. This work instead enhances instructor workflows by improving how Artemis presents and manages LLM-based consistency checks.
