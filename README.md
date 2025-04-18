# Anxiety-Disorder-Analysis-Expert-System-In-Prolog

# AIM:
To represent knowledge using Prolog by implementing a small expert system that diagnoses anxiety disorders based on the DSM-5 criteria.



# 1. Problem Statement
In recent years, mental health disorders such as anxiety have become increasingly common, particularly among students and working professionals. Early detection and diagnosis are essential to managing anxiety effectively, but access to qualified professionals is often limited. There is a need for an intelligent system that can preliminarily assess the likelihood of anxiety disorders using standardized medical criteria such as DSM-5.
Objective:
To develop a rule-based expert system in Prolog that can analyze user symptoms and suggest whether the individual might be suffering from a specific type of anxiety disorder (e.g., GAD, Panic Disorder, Social Anxiety, Phobias, etc.).



# 2. Introduction
Expert systems simulate the decision-making abilities of a human expert by applying logical reasoning to a body of knowledge stored in the form of rules and facts. Prolog (Programming in Logic) is particularly suited for implementing such systems due to its declarative nature and built-in support for logical inference.
This project leverages Prolog to build an expert system that performs preliminary diagnosis of anxiety disorders based on user inputs. The system is built upon the diagnostic criteria laid out in the DSM-5 (Diagnostic and Statistical Manual of Mental Disorders, 5th Edition), which is a widely accepted standard in psychology and psychiatry.
What is an Anxiety Disorder?
Anxiety disorders are a group of mental health conditions characterized by excessive fear, worry, and behavioral disturbances. These include:
Generalized Anxiety Disorder (GAD)
Panic Disorder
Social Anxiety Disorder
Specific Phobias
Separation Anxiety Disorder
Agoraphobia



# 3. Modules / Features
The expert system consists of the following major modules:
       
                1. Knowledge Base Module
                Stores facts and rules derived from DSM-5 diagnostic criteria.
                Encodes symptom patterns specific to each disorder.
                
                
                2. Inference Engine
                Uses backward chaining to ask questions and draw conclusions.
                Matches user symptoms with rules to infer a possible diagnosis.
                
                
                3. User Interaction Module
                Presents a series of questions to the user regarding symptoms.
                Records user responses (yes/no) and uses them as facts for inference.
                
                
                4. Diagnosis Module
                Generates a potential diagnosis based on symptom match percentage.
                Displays a recommendation to consult a mental health professional.





# 4. Dataset / Knowledge Base Information
The dataset is manually curated based on DSM-5 criteria and includes symptom sets for the following disorders:
Example Knowledge Representation (Simplified):
                Generalized Anxiety Disorder (GAD)
                Excessive anxiety/worry for more than 6 months.
                Difficulty controlling the worry.
                Presence of 3+ symptoms: restlessness, fatigue, irritability, muscle tension, sleep disturbance, etc.
                Panic Disorder
                Recurrent unexpected panic attacks.
                Palpitations, sweating, shaking, shortness of breath, etc.
                Persistent concern about having more attacks.
Social Anxiety Disorder
Fear or anxiety about social situations.
Avoidance behavior.
Lasts for 6+ months.

These criteria are converted into Prolog rules for diagnosis.





# 5. Code
Here's a complete and detailed Prolog implementation:
prolog
CopyEdit

              % expert_system.pl

              start :-
                  intro,
                  reset_answers,
                  diagnose(Disorder),
                  format("~nBased on your responses, you may be experiencing: ~w~n", [Disorder]),
                  advice(Disorder),
                  nl.


% Introduction
       
              intro :-
                  write("Welcome to the Anxiety Disorder Expert System."), nl,
                  write("Please answer the following questions with yes. or no."), nl, nl.

% Reset previous answers

              reset_answers :-
                  retractall(yes(_)),
                  retractall(no(_)).


% Dynamic predicates to store responses

              :- dynamic yes/1, no/1.

% Ask questions

              ask(Question) :-
                  format("~w ", [Question]),
                  read(Response),
                  nl,
                  ( (Response == yes) -> assert(yes(Question));
                    (Response == no)  -> assert(no(Question)); 
                    write("Please answer with yes. or no."), nl, ask(Question) ).
              verify(Symptom) :-
                  (yes(Symptom) -> true;
                   no(Symptom) -> fail;
                   ask(Symptom)).


% Disorder Rules

       diagnose(generalized_anxiety_disorder) :-
           verify("Have you been worrying excessively for more than 6 months?"),
           verify("Do you find it difficult to control your worry?"),
           verify("Do you often feel restless or on edge?"),
           verify("Do you feel easily fatigued?"),
           verify("Do you have difficulty concentrating?"),
           verify("Do you feel irritable frequently?"),
           verify("Do you experience muscle tension?"),
           verify("Do you have sleep disturbances?").
       
       diagnose(panic_disorder) :-
           verify("Do you experience sudden intense fear or discomfort?"),
           verify("Do you have palpitations or rapid heart rate?"),
           verify("Do you experience sweating, trembling, or shaking?"),
           verify("Do you have shortness of breath or choking sensations?"),
           verify("Do you worry about future panic attacks?").
       
       diagnose(social_anxiety_disorder) :-
           verify("Do you fear social situations where you may be judged?"),
           verify("Do you avoid social interactions or endure them with intense fear?"),
           verify("Has this fear lasted for more than 6 months?").
       
       diagnose(specific_phobia) :-
           verify("Do you have an intense fear of a specific object or situation?"),
           verify("Do you go out of your way to avoid the phobic stimulus?"),
           verify("Is the fear excessive or unreasonable?"),
           verify("Does it interfere with your daily life?").
       
       diagnose(separation_anxiety_disorder) :-
           verify("Do you fear being separated from loved ones?"),
           verify("Do you experience nightmares about separation?"),
           verify("Do you complain of physical symptoms when separation occurs or is anticipated?").
       
       diagnose(agoraphobia) :-
           verify("Do you avoid public places or open spaces?"),
           verify("Do you fear being unable to escape in case of panic?"),
           verify("Has this fear persisted for more than 6 months?").
       
       diagnose(no_disorder) :-
           write("Your symptoms do not clearly indicate a specific anxiety disorder. However, if you feel distressed, please consult a professional.").


% Advice module

              advice(no_disorder).
              advice(_) :-
                  write("It is recommended that you consult a licensed mental health professional for a full diagnosis and treatment plan.").



# 6. Conclusion
This expert system demonstrates the power of symbolic AI using Prolog in the domain of mental health diagnosis. By encoding standardized diagnostic rules, the system can assist in the preliminary detection of anxiety disorders, helping users recognize their symptoms and prompting them to seek professional help.
While the system is not a replacement for licensed mental health practitioners, it provides a scalable and accessible tool to raise awareness about anxiety-related conditions.
Future Scope
Extend to include mood and personality disorders.
Integrate with a GUI or chatbot interface.
Incorporate probabilistic reasoning using certainty factors or fuzzy logic.
Add multilingual support.



