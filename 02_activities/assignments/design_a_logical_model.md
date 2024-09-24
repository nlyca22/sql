# Assignment 1: Design a Logical Model

## Question 1
Create a logical model for a small bookstore. 📚

At the minimum it should have employee, order, sales, customer, and book entities (tables). Determine sensible column and table design based on what you know about these concepts. Keep it simple, but work out sensible relationships to keep tables reasonably sized. Include a date table. There are several tools online you can use, I'd recommend [_Draw.io_](https://www.drawio.com/) or [_LucidChart_](https://www.lucidchart.com/pages/).

```
MY SUBMISSION: 
     1) File "Bookstore ERD(Q1) submission.drawio.pdf" 
     2) Some explanation for the ERD: 
        - The design is for a small bookstore with presence online (ie. website, Amazon) and offline (physical store). 
        - Customers have the option of providing more personal info (e.g., date of birth) to receive anniversary and special occasion gifts (e.g., birthday gifts, christmas gifts). 
        - To make an online purchase, customers are required to create an account. Note: I considered an option for customers to purchase as "guest", but I decided to require an account at this stage. 
        - Membership is optional for customers. 
        - Promotion codes are unique every time and are at items-level. Note: I considered to have promotions at both items-level and at basket-level, but decided to simplify it to just items-level, since a promotion code can apply to as many items as we want however we want. 
        - All tables are for internal usage purposes (reporting, data analytics, marketing, machine learning/recommendation system), except for the "receipt" table that is for external issuance to customers. 
        - I separated "book" table from "other items" table for easy inventory management. 
        - I included "display location" table - for internal monitoring to see if there's any correlation with sales performance.
        - "address" column means full address, including: unit/house number, street number, street name, city, province, postal code, country. 

```
   

## Question 2
We want to create employee shifts, splitting up the day into morning and evening. Add this to the ERD.

```
MY SUBMISSION: 
     1) File "Bookstore ERD(Q2) submission.drawio.pdf" 
     2) Some explanation for the ERD: 
        - I added "Shift" table. 
        - I included "shift id" in "Order" table and "Sales" table - for analytics purposes such as optimal staff allocations during busier shifts. 
```
         

## Question 3
The store wants to keep customer addresses. Propose two architectures for the CUSTOMER_ADDRESS table, one that will retain changes, and another that will overwrite. Which is type 1, which is type 2?

_Hint, search type 1 vs type 2 slowly changing dimensions._

Bonus: Are there privacy implications to this, why or why not?
```
MY SUBMISSION:

1) Option 1: Architecture for OVERWRITING customers' addresses - Type 1 Slowly Changing Dimension (SCD):
The CUSTOMER_ADRESS table only stores the most recent address, overwriting the previous address. It does not keep any history of old addresses.  
When the address changes, only the "date_updated" is modified.  

Table stucture:
     - customer_id (FK)
     - address (full address, including: unit/house number, street number, street name, city, province, postal code, country)
     - date_updated

Privacy implication:
It is less privacy-sensitive than type 2 (below) because it stores less customer's personal data (only the current address is kept). 
Compliance with data protection laws and regulations (such as GDPR) would require explicit customer's consent as well as secure handling of data retention, restriction of access, encryption, and deletion.


2) Option 2: Architecture for RETAINING customers' addresses - Type 2 Slowly Changing Dimension (SCD):
The CUSTOMER_ADRESS table preserves records of all previous addresses, and stores each address as a separate record with "effective start dates" and "effective end dates". 
Whenever an address changes, a new row is inserted (aka created), with the "effective_end_date" and "is_current" fields updated accordingly. 

Table stucture:
     - customer_id (FK)
     - address_id (auto-incremented) (PK) 
     - address (full address, including: unit/house number, street number, street name, city, province, postal code, country)
     - effective_start_date (when the address becomes effective)
     - effective_end_date (when the address is no longer valid)
     - is_current (yes/no flag)  

Privacy implication:
It is more privacy-sensitive than type 1 (above) because it stores more customer's personal data info (ie. history of addresses). 
Compliance with data protection laws and regulations (such as GDPR) would require explicit customer's consent as well as secure handling of data retention, restriction of access, encryption, and deletion. In addition, due to more risks involved, the business should consider the necessity of storing historical records of customers' personal data from business and legal standpoint.


```

## Question 4
Review the AdventureWorks Schema [here](https://i.stack.imgur.com/LMu4W.gif)

Highlight at least two differences between it and your ERD. Would you change anything in yours?
```
Your answer...
```

# Criteria

[Assignment Rubric](./assignment_rubric.md)

# Submission Information

🚨 **Please review our [Assignment Submission Guide](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md)** 🚨 for detailed instructions on how to format, branch, and submit your work. Following these guidelines is crucial for your submissions to be evaluated correctly.

### Submission Parameters:
* Submission Due Date: `September 28, 2024`
* The branch name for your repo should be: `model-design`
* What to submit for this assignment:
    * This markdown (design_a_logical_model.md) should be populated.
    * Two Entity-Relationship Diagrams (preferably in a pdf, jpeg, png format).
* What the pull request link should look like for this assignment: `https://github.com/<your_github_username>/sql/pull/<pr_id>`
    * Open a private window in your browser. Copy and paste the link to your pull request into the address bar. Make sure you can see your pull request properly. This helps the technical facilitator and learning support staff review your submission easily.

Checklist:
- [ ] Create a branch called `model-design`.
- [ ] Ensure that the repository is public.
- [ ] Review [the PR description guidelines](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md#guidelines-for-pull-request-descriptions) and adhere to them.
- [ ] Verify that the link is accessible in a private browser window.

If you encounter any difficulties or have questions, please don't hesitate to reach out to our team via our Slack at `#cohort-4-help`. Our Technical Facilitators and Learning Support staff are here to help you navigate any challenges.
