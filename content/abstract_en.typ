/*
Note:
  1. *paragraph:* What is the motivation of your thesis? Why is it interesting from a scientific point of view? Which main problem do you like to solve?
  2. *paragraph:* What is the purpose of the document? What is the main content, the main contribution?
  3. *paragraph:* What is your methodology? How do you proceed?
*/

Programming exercises are a central instrument in computer science education, but their quality depends on consistent alignment between the problem statement, template, solution, and tests. Artemis already uses large language models (LLMs) to detect consistency issues, yet the system presents the findings as raw JavaScript Object Notation (JSON) that instructors must interpret manually. This format slows review and increases the risk of errors.

This thesis extends Artemis with AI-assisted review tools that make consistency checks accessible and actionable. The thesis introduces a persistent review comment system and stores each consistency issue as a review comment in that system. The exercise editor visualizes consistency-issue comments inline with severity, affected locations, and suggested fix descriptions, and the editor provides an overview for fast navigation. Instructors and editors can preview and apply suggested code changes directly in the editor while retaining human control over final changes. These contributions improve the reliability of programming exercises and reduce manual overhead.

Methodologically, the work follows a design-oriented software engineering approach. It derives requirements from instructor workflows, maps them into a system design with persistent storage of consistency issues and editor integration, and implements the system within Artemis.
