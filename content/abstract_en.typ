/*
Note:
  1. *paragraph:* What is the motivation of your thesis? Why is it interesting from a scientific point of view? Which main problem do you like to solve?
  2. *paragraph:* What is the purpose of the document? What is the main content, the main contribution?
  3. *paragraph:* What is your methodology? How do you proceed?
*/

Programming exercises are a central instrument in computer science education, but their quality depends on consistent alignment between the problem statement, template, solution, and tests. Artemis already uses large language models (LLMs) to detect inconsistencies, yet the results appear as raw JSON that is hard to interpret and act on, which makes review slow and error-prone for instructors.

This thesis extends Artemis with AI-assisted review tools that make consistency checks accessible and actionable. It introduces a persistent review comment system, and consistency issues are represented as review comments within that system. The exercise editor visualizes these issue comments inline with severity, affected locations, and suggested fix descriptions, and provides an overview for fast navigation. Instructors can preview and apply suggested code changes directly in the editor while keeping human control over final changes. These contributions improve the reliability of programming exercises and reduce manual overhead.

Methodologically, the work follows a design-oriented software engineering approach. It derives requirements from instructor workflows, maps them into a system design with persistent issue storage and editor integration, and implements the system within Artemis. The solution is evaluated through user testing to assess usability and the effectiveness of the new review workflow.
