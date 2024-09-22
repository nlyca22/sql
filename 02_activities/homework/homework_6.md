# Homework 6: Reflecton

- Due on Saturday, September 21 at 11:59pm
- Weight: 8% of total grade

<br>

**Write**: Reflect on your previous work and how you would adjust to include ethics and inequity components. Total length should be a few paragraphs, no more than one page.

** PLEASE SEE MY ANSWER BELOW: 

My past positions were neither Data Scientist nor Machine Learning Engineer, nor were they related to data architecture design or software development… So I don’t have direct working experience to reflect on what I should have done differently. Instead, my answer will be based on a project I led, which involved improving a system designed by others. 

In 2012, while working at a global American bank in Vietnam, I led a process-improvement initiative on built-in fraud algorithms for the transaction department. Due to company policy, I cannot reveal specific details about how frauds were screened, so I will share my experience at high-level concept. 

Regarding fraud screening, an essential field that is screened is the “name” of individuals involved in transactions. The bank’s algorithm screened “names” against sanction lists - at both at global and local levels. As per my knowledge, every financial institution builds their own fraud algorithm. My former company, likewise, set fixed “match” thresholds for all “name” fields, which were screened by anagram checkers. The problem was that in Vietnam, the surnames “Nguyen” and “Tran” are very common, accounting for about 37% and 12% of the population respectively. Unlike English names which can have derivations (e.g., Thomas and Tom, Elizabeth and Liz), Vietnamese names do not have derivations and can differ by as little as a letter or a space (e.g., Li An is a different from Lian). Additionally, the Middle Name is critical in Vietnam for identifying individuals (e.g., Au Cam Ly is different from Au Ly). The chronological arrangement of the Middle Name and First Name is also critical for differentiation (e.g., Au Cam Ly is different from Au Ly Cam). 

This means that the default global American system, which used “loose match” thresholds and anagram checkers not tailored for the Vietnamese market, resulted in a large number of false positives that required human reviews to decide whether to “pass”, “request more information”, or “reject”. Needless to say, the large amount of false positives led to constant delays in transaction processing, and unfortunate instances where actual frauds were accidentally let through. 

My work involved partnering with operations, development and product teams to improve the fraud-screening algorithm and reduce false-positive captures. Long story short, we adjusted the ‘conditioning’ of the ‘match’ algorithms, added more intricacies to matching thresholds and conditionings in combination with other fields (e.g., date of birth, place of birth, among others), added exceptions for customer accounts that had been previously cleared, considering the “recentness” of their last screening, and added more internal blacklist rules to account for potential deceptions. 

I proposed the best logics based on all scenarios we encountered and those we predicted based on our best efforts and knowledge. I presented tradeoffs, potential risks, and benefits for management’s decision. The management then considered the constraints of financial budgets and human resources, to make the best decision. 

In conclusion, in an ideal world - where budget, human resources and time are unlimited, and criminals don’t falsify their documents - we could achieve perfect fraud screening accuracy. However, in the real world, with constraints on budgets, human resources, and evolving criminal tactics, we face difficult decisions about what we are willing to trade off or invest in. Nevertheless, we have to regularly review, update, and hone our fraud screening mechanisms, considering market-specifics, especially in financial institutions. 
