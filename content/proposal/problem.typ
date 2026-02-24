#import "/utils/todo.typ": TODO

= Problem
#TODO[ // Remove this block
  *Problem description*
  - What is/are the problem(s)? 
  - Identify the actors and use these to describe how the problem negatively influences them.
  - Do not present solutions or alternatives yet!
  - Present the negative consequences in detail 
]

While Artemis already integrates LLMs to automatically generate new exercises, its support for reviewing and refining them is still limited. Instructors can query an LLM to check for inconsistencies, but the results are returned only as formatted JSON. The output lists descriptions, severities, categories, and suggested fixes, but it still doesn’t present the information in a way instructors can act on directly. Instead, they must manually interpret the entries, identify the affected files and lines, and apply corrections themselves.
This manual review process is time-consuming, error-prone, and does not scale well for complex exercises. In addition, Artemis does not yet provide mechanisms to persist comments across exercise versions, making it hard to track whether inconsistencies have been resolved or whether issues resurface in later iterations of the exercise.

This means that instructors must spend a substantial amount of time manually interpreting raw JSON outputs, locating inconsistencies across multiple files, and reapplying checks when exercises evolve. This repetitive process diverts attention from pedagogical work and makes it harder to maintain a consistent standard across exercises. 
Students, in turn, depend on well-structured and coherent exercises for effective learning. Inconsistencies between the problem statement, template, solution, and tests can cause confusion, increase cognitive load, and ultimately hinder their ability to achieve learning goals.
