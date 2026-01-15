#import "/utils/todo.typ": TODO

= Abstract
#TODO[ // Remove this block
  *Abstract*
  - Short (1/3-1/2 page) summary of the project 
  - It is fine to repeat yourself here 
]

Programming exercises play a key role in computer science education by helping students apply theoretical knowledge in practice. Their effectiveness depends on consistent alignment between the problem statement, template, solution, and tests.
Artemis already uses large language models (LLMs) to detect inconsistencies, but the results appear only as formatted JSON that is difficult to interpret and act upon.

This thesis extends Artemis with AI-assisted review tools that make consistency checks more accessible and actionable. The exercise editor shows inconsistencies inline and summarizes them in an overview for quick navigation. Instructors can preview and apply suggested fixes directly, enhancing the human-in-the-loop process and improving the overall quality of programming exercises.