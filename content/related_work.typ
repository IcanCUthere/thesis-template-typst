#import "/utils/todo.typ": TODO

= Related Work
#TODO[
  Describe related work regarding your topic and emphasize your (scientific) contribution in contrast to existing approaches / concepts / workflows. Related work is usually current research by others and you defend yourself against the statement: “Why is your thesis relevant? The problem was al- ready solved by XYZ.” If you have multiple related works, use subsections to separate them.
]

This chapter reviews prior work in four areas that are directly relevant to this thesis: human-in-the-loop grading workflows, LLM-supported authoring, instructor-facing AI assistance, and the remaining research gap. This structure clarifies how existing approaches inform the design decisions and contribution of this work.

== Human-in-the-Loop Grading Workflows

Current research on LLM-supported educational workflows shows a consistent pattern: models reduce manual effort, but reliable use still requires explicit human review. Grading-focused studies demonstrate this clearly. Xu et al. combine ChatGPT-4o grading with a human revision step #cite(<Xu2025469>), and Cisneros-González et al. report a JorGPT workflow in which instructors choose both model and rubric #cite(<Cisneros-Gonzalez2025>). Bernik et al. report close agreement between AI and teacher grades overall, with stricter AI grading in specific submissions #cite(<Bernik2025>).

Design-focused studies support the same conclusion. Work on formative coding assessment and design-pattern analysis keeps educators in control of final judgments #cite(<Knipp2025379>) #cite(<Dosaru2025>). Similar findings appear outside programming: Funayama et al. route low-confidence cases to humans #cite(<Funayama2022465>), and Emirtekin et al. report lower AI-human agreement for tasks that require deeper reasoning #cite(<Emirtekin2026>). These studies show that hybrid AI-human grading can improve quality and reduce workload when workflows enforce human decisions.

== LLM-Supported Authoring of Assessment Material

A second group of studies addresses authoring of questions, exams, and related teaching material. LLMs scale drafting, but educator moderation remains necessary for pedagogical quality. Kituku et al. report year-long classroom use of generative AI (GenAI) questions with instructor moderation #cite(<Kituku2025>). Cheng et al. present TreeQuestion as a teacher-in-the-loop multiple-choice question (MCQ) authoring workflow #cite(<Cheng2024>). Cui et al. generate large candidate sets and rely on expert review for quality selection #cite(<Cui20251094>). Tyndall et al. and Nyaaba et al. show that retrieval and interactive prompting improve outcomes when teachers review final material #cite(<Tyndall2025>) #cite(<Nyaaba2025>).

== Instructor-Facing AI Assistance

Instructor-facing support systems extend beyond grading and authoring into daily teaching workflows. Wolff et al. present EDUHints, where AI proposes hints and instructors approve what students receive #cite(<Wolff2025897>). In Artemis, Iris already provides student-facing AI tutoring, which creates a strong baseline for extending assistance toward instructor and editor tasks #cite(<Bassner2024394>). Frameworks by Tan et al. and Tebourbi et al. emphasize structured generation workflows, explicit evaluation, and human validation #cite(<Tan2025>) #cite(<Tebourbi2025>).

== Research Gap and Thesis Positioning

The reviewed literature establishes important building blocks for AI-supported education, but it treats them mostly in isolation. Grading papers focus on feedback quality and agreement, authoring papers focus on generating candidate material, and instructor-support papers focus on assistance in specific teaching tasks. These lines of work confirm the value of human oversight, yet they rarely model a complete authoring workflow from issue detection to final resolution.

This separation creates a concrete gap for programming-exercise development. Existing work does not connect multi-artifact consistency checking (problem statement, template, solution, and tests) with a persistent discussion mechanism that links findings to concrete file locations, supports explicit thread states, and remains stable across exercise versions. The reviewed papers also do not integrate suggested edits into one controlled workflow in which instructors and editors can compare, apply, reject, and trace changes inside the same review context.

This thesis positions its contribution at the workflow level rather than at the model level. The system integrates consistency-issue detection with persistent review comments, consistency-issue navigation, controlled code-change application, and traceable decision history in Artemis. Instructors and editors remain responsible for final decisions, while the system reduces mechanical review effort and preserves a clear audit trail across collaborative iterations.
