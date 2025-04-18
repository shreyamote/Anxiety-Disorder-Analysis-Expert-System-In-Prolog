% anxiety_expert_system.pl
% Enhanced expert system for anxiety disorder diagnosis and recommendations
% This system loads a comprehensive knowledge base and provides an improved UI

:- use_module(library(lists)).
:- dynamic symptom/1, severity_rating/2.
:- consult('anxiety_kb.pl').  % Load the knowledge base

% Main program entry point
start :-
    initialize_system,
    main_menu.

% Initialize the system
initialize_system :-
    clear_all_data,
    display_welcome_message.

% Clear all asserted data
clear_all_data :-
    retractall(symptom(_)),
    retractall(severity_rating(_, _)).

% Display welcome message
display_welcome_message :-
    cls,
    write('====================================================='), nl,
    write('|                                                   |'), nl,
    write('|        ANXIETY DISORDERS ASSESSMENT SYSTEM        |'), nl,
    write('|                                                   |'), nl,
    write('|            Based on DSM-5 Criteria                |'), nl,
    write('|                                                   |'), nl,
    write('====================================================='), nl, nl,
    write('This system will help assess possible anxiety disorders'), nl,
    write('based on reported symptoms and provide recommendations.'), nl,
    write('NOTE: This is not a substitute for professional diagnosis.'), nl, nl,
    write('Press Enter to continue...'), nl,
    read_line_to_string(user_input, _).

% Main menu
main_menu :-
    cls,
    write('====================================================='), nl,
    write('|                  MAIN MENU                        |'), nl,
    write('====================================================='), nl,
    write('1. Start Assessment'), nl,
    write('2. About Anxiety Disorders'), nl,
    write('3. Exit'), nl, nl,
    write('Enter your choice (1-3): '),
    read_line_to_string(user_input, Choice),
    process_main_menu_choice(Choice).

% Process main menu choice
process_main_menu_choice("1") :- !, start_assessment.
process_main_menu_choice("2") :- !, show_anxiety_info, main_menu.
process_main_menu_choice("3") :- !, exit_system.
process_main_menu_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    sleep(1),
    main_menu.

% About anxiety disorders
show_anxiety_info :-
    cls,
    write('====================================================='), nl,
    write('|             ABOUT ANXIETY DISORDERS               |'), nl,
    write('====================================================='), nl, nl,
    write('Anxiety disorders are a group of mental health conditions'), nl,
    write('characterized by significant feelings of anxiety and fear.'), nl,
    write('These disorders include:'), nl, nl,
    write('- Generalized Anxiety Disorder (GAD)'), nl,
    write('- Panic Disorder'), nl,
    write('- Social Anxiety Disorder'), nl,
    write('- Specific Phobias'), nl,
    write('- Agoraphobia'), nl,
    write('- Separation Anxiety Disorder'), nl,
    write('- Illness Anxiety Disorder'), nl,
    write('- Obsessive-Compulsive Disorder (OCD)'), nl,
    write('- Post-Traumatic Stress Disorder (PTSD)'), nl, nl,
    write('Anxiety disorders are treatable with therapy, medication,'), nl,
    write('or a combination of treatments. If you\'re experiencing'), nl,
    write('symptoms that interfere with daily life, please consult'), nl,
    write('a mental health professional for proper diagnosis and treatment.'), nl, nl,
    write('Press Enter to return to the main menu...'),
    read_line_to_string(user_input, _).

% Exit system
exit_system :-
    cls,
    write('Thank you for using the Anxiety Disorders Assessment System.'), nl,
    write('Remember that this tool is not a substitute for professional'), nl,
    write('mental health evaluation. If you are experiencing distress,'), nl,
    write('please consult with a qualified mental health professional.'), nl, nl,
    write('Goodbye!'), nl,
    halt.

% Start the assessment process
start_assessment :-
    cls,
    write('====================================================='), nl,
    write('|              SYMPTOM ASSESSMENT                   |'), nl,
    write('====================================================='), nl, nl,
    write('Please answer the following questions about your symptoms.'), nl,
    write('Answer with "yes" or "no" for each question.'), nl, nl,
    collect_symptoms,
    assess_severity,
    display_results.

% Collect symptoms with improved UI
collect_symptoms :-
    findall(Symptom, symptom_description(Symptom, _, _), AllSymptoms),
    collect_symptoms(AllSymptoms).

collect_symptoms([]).
collect_symptoms([Symptom|Rest]) :-
    symptom_description(Symptom, ShortDesc, LongDesc),
    cls,
    write('====================================================='), nl,
    write('Question: '), write(ShortDesc), nl,
    write('====================================================='), nl, nl,
    write(LongDesc), nl, nl,
    write('Do you experience this? (yes/no): '),
    read_line_to_string(user_input, Answer),
    string_lower(Answer, LowerAnswer),
    process_answer(Symptom, LowerAnswer),
    collect_symptoms(Rest).

% Process user's answer
process_answer(Symptom, "yes") :- 
    assert(symptom(Symptom)), !.
process_answer(_, "no") :- !.
process_answer(Symptom, _) :-
    write('Please answer only with "yes" or "no".'), nl,
    write('Press Enter to try again...'), nl,
    read_line_to_string(user_input, _),
    symptom_description(Symptom, ShortDesc, LongDesc),
    cls,
    write('====================================================='), nl,
    write('Question: '), write(ShortDesc), nl,
    write('====================================================='), nl, nl,
    write(LongDesc), nl, nl,
    write('Do you experience this? (yes/no): '),
    read_line_to_string(user_input, Answer),
    string_lower(Answer, LowerAnswer),
    process_answer(Symptom, LowerAnswer).

% Assess severity of symptoms
assess_severity :-
    cls,
    write('====================================================='), nl,
    write('|              SEVERITY ASSESSMENT                  |'), nl,
    write('====================================================='), nl, nl,
    write('Please rate the severity of your symptoms:'), nl, nl,
    findall(Category, severity_question(Category, _, _), Categories),
    assess_severity_categories(Categories).

assess_severity_categories([]).
assess_severity_categories([Category|Rest]) :-
    severity_question(Category, Question, Options),
    cls,
    write('====================================================='), nl,
    write('Severity: '), write(Question), nl,
    write('====================================================='), nl, nl,
    write_options(Options, 1),
    write('Enter your choice (1-'), write(4), write('): '),
    read_line_to_string(user_input, ChoiceStr),
    (
        atom_number(ChoiceStr, Choice),
        integer(Choice),
        Choice >= 1,
        Choice =< 4
    ->
        assert(severity_rating(Category, Choice)),
        assess_severity_categories(Rest)
    ;
        write('Invalid choice. Please enter a number between 1 and 4.'), nl,
        write('Press Enter to try again...'), nl,
        read_line_to_string(user_input, _),
        assess_severity_categories([Category|Rest])
    ).

% Write options with numbering
write_options([], _).
write_options([Option|Rest], N) :-
    write(N), write('. '), write(Option), nl,
    N1 is N + 1,
    write_options(Rest, N1).

% Display results with improved formatting
display_results :-
    cls,
    write('====================================================='), nl,
    write('|               ASSESSMENT RESULTS                  |'), nl,
    write('====================================================='), nl, nl,
    find_disorders(Disorders),
    (
        Disorders = []
    ->
        write('Based on the information provided, no specific anxiety'), nl,
        write('disorder was identified. However, if you are experiencing'), nl,
        write('anxiety symptoms that affect your daily life, it is'), nl,
        write('recommended to consult with a mental health professional'), nl,
        write('for a thorough assessment.'), nl
    ;
        write('Based on the symptoms provided, the following anxiety'), nl,
        write('disorder(s) may be considered:'), nl, nl,
        display_disorders_and_recommendations(Disorders),
        nl, nl,
        display_severity_summary
    ),
    nl, nl,
    write('IMPORTANT DISCLAIMER:'), nl,
    write('This assessment is for informational purposes only and'), nl,
    write('should not be considered a medical diagnosis. Please consult'), nl,
    write('with a qualified mental health professional for proper'), nl,
    write('diagnosis and treatment.'), nl, nl,
    write('Press Enter to continue...'),
    read_line_to_string(user_input, _),
    post_assessment_menu.

% Find all applicable disorders based on symptoms
find_disorders(Disorders) :-
    findall(Disorder, (disorder(Disorder, _, _), call(disorder(Disorder, _, _))), Disorders).

% Display each disorder and its recommendations
display_disorders_and_recommendations([]).
display_disorders_and_recommendations([Disorder|Rest]) :-
    disorder(Disorder, Name, Description),
    write('-----------------------------------------------------'), nl,
    write('DISORDER: '), write(Name), nl,
    write('-----------------------------------------------------'), nl,
    write(Description), nl, nl,
    write('RECOMMENDATIONS:'), nl,
    recommendation(Disorder, Recommendations),
    display_recommendations(Recommendations, 1),
    nl,
    display_disorders_and_recommendations(Rest).

% Display recommendations with numbering
display_recommendations([], _).
display_recommendations([Recommendation|Rest], N) :-
    write('  '), write(N), write('. '), write(Recommendation), nl,
    N1 is N + 1,
    display_recommendations(Rest, N1).

% Display severity summary
display_severity_summary :-
    write('-----------------------------------------------------'), nl,
    write('SEVERITY ASSESSMENT SUMMARY:'), nl,
    write('-----------------------------------------------------'), nl,
    findall(Category-Rating, severity_rating(Category, Rating), Ratings),
    display_severity_ratings(Ratings),
    calculate_overall_severity(Ratings, OverallSeverity),
    write('Overall severity level: '),
    display_severity_level(OverallSeverity), nl.

% Display individual severity ratings
display_severity_ratings([]).
display_severity_ratings([Category-Rating|Rest]) :-
    severity_question(Category, Question, Options),
    nth1(Rating, Options, RatingText),
    write('- '), write(Question), write(': '), write(RatingText), nl,
    display_severity_ratings(Rest).

% Calculate overall severity level (1-4) based on average of ratings
calculate_overall_severity(Ratings, OverallSeverity) :-
    sum_ratings(Ratings, Sum, Count),
    (Count > 0 -> 
        Avg is Sum / Count,
        OverallSeverity is round(Avg)
    ;
        OverallSeverity = 1
    ).

% Sum ratings for calculating average
sum_ratings([], 0, 0).
sum_ratings([_-Rating|Rest], Sum, Count) :-
    sum_ratings(Rest, RestSum, RestCount),
    Sum is RestSum + Rating,
    Count is RestCount + 1.

% Display severity level text
display_severity_level(1) :- write('Mild (monitor symptoms)').
display_severity_level(2) :- write('Moderate (consider professional consultation)').
display_severity_level(3) :- write('Severe (professional help recommended)').
display_severity_level(4) :- write('Very Severe (seek professional help promptly)').

% Post-assessment menu
post_assessment_menu :-
    cls,
    write('====================================================='), nl,
    write('|                POST-ASSESSMENT                    |'), nl,
    write('====================================================='), nl,
    write('1. View Results Again'), nl,
    write('2. Start New Assessment'), nl,
    write('3. Return to Main Menu'), nl,
    write('4. Exit'), nl, nl,
    write('Enter your choice (1-4): '),
    read_line_to_string(user_input, Choice),
    process_post_assessment_choice(Choice).

% Process post-assessment choice
process_post_assessment_choice("1") :- !, display_results.
process_post_assessment_choice("2") :- !, clear_all_data, start_assessment.
process_post_assessment_choice("3") :- !, clear_all_data, main_menu.
process_post_assessment_choice("4") :- !, exit_system.
process_post_assessment_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    sleep(1),
    post_assessment_menu.

% Clear screen (works on most Prolog implementations)
cls :-
    write('\e[H\e[2J').

% Print formatted header
print_header(Text) :-
    string_length(Text, Length),
    Total is 53,  % Width of header
    Stars is (Total - Length - 2) / 2,
    write_chars('=', Total), nl,
    write('|'),
    write_spaces(Stars),
    write(' '), write(Text), write(' '),
    write_spaces(Stars),
    write('|'), nl,
    write_chars('=', Total), nl.

% Helper to write repeated characters
write_chars(_, 0) :- !.
write_chars(Char, N) :-
    N > 0,
    write(Char),
    N1 is N - 1,
    write_chars(Char, N1).

% Helper to write spaces
write_spaces(N) :-
    write_chars(' ', N).% Add logs for system events
log_event(Event) :-
    open('anxiety_expert_system.log', append, Stream),
    format(Stream, '~w~n', [Event]),
    close(Stream).

% Initialize the system with logging
initialize_system :-
    clear_all_data,
    display_welcome_message,
    log_event('System initialized').

% Clear all asserted data with logging
clear_all_data :-
    retractall(symptom(_)),
    retractall(severity_rating(_, _)),
    log_event('Data cleared').

% Exit system with logging
exit_system :-
    cls,
    write('Thank you for using the Anxiety Disorders Assessment System.'), nl,
    write('Remember that this tool is not a substitute for professional'), nl,
    write('mental health evaluation. If you are experiencing distress,'), nl,
    write('please consult with a qualified mental health professional.'), nl, nl,
    write('Goodbye!'), nl,
    log_event('System exited'),
    halt.

% Start the assessment process with logging
start_assessment :-
    cls,
    write('====================================================='), nl,
    write('|              SYMPTOM ASSESSMENT                   |'), nl,
    write('====================================================='), nl, nl,
    write('Please answer the following questions about your symptoms.'), nl,
    write('Answer with "yes" or "no" for each question.'), nl, nl,
    collect_symptoms,
    assess_severity,
    display_results,
    log_event('Assessment started').

% Display results with logging
display_results :-
    cls,
    write('====================================================='), nl,
    write('|               ASSESSMENT RESULTS                  |'), nl,
    write('====================================================='), nl, nl,
    find_disorders(Disorders),
    (
        Disorders = []
    ->
        write('Based on the information provided, no specific anxiety'), nl,
        write('disorder was identified. However, if you are experiencing'), nl,
        write('anxiety symptoms that affect your daily life, it is'), nl,
        write('recommended to consult with a mental health professional'), nl,
        write('for a thorough assessment.'), nl
    ;
        write('Based on the symptoms provided, the following anxiety'), nl,
        write('disorder(s) may be considered:'), nl, nl,
        display_disorders_and_recommendations(Disorders),
        nl, nl,
        display_severity_summary
    ),
    nl, nl,
    write('IMPORTANT DISCLAIMER:'), nl,
    write('This assessment is for informational purposes only and'), nl,
    write('should not be considered a medical diagnosis. Please consult'), nl,
    write('with a qualified mental health professional for proper'), nl,
    write('diagnosis and treatment.'), nl, nl,
    write('Press Enter to continue...'),
    read_line_to_string(user_input, _),
    post_assessment_menu,
    log_event('Results displayed').

% Post-assessment menu with logging
post_assessment_menu :-
    cls,
    write('====================================================='), nl,
    write('|                POST-ASSESSMENT                    |'), nl,
    write('====================================================='), nl,
    write('1. View Results Again'), nl,
    write('2. Start New Assessment'), nl,
    write('3. Return to Main Menu'), nl,
    write('4. Exit'), nl, nl,
    write('Enter your choice (1-4): '),
    read_line_to_string(user_input, Choice),
    process_post_assessment_choice(Choice),
    log_event('Post-assessment menu displayed').

% Process post-assessment choice with logging
process_post_assessment_choice("1") :- !, display_results, log_event('Results viewed again').
process_post_assessment_choice("2") :- !, clear_all_data, start_assessment, log_event('New assessment started').
process_post_assessment_choice("3") :- !, clear_all_data, main_menu, log_event('Returned to main menu').
process_post_assessment_choice("4") :- !, exit_system, log_event('System exited').
process_post_assessment_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    sleep(1),
    post_assessment_menu,
    log_event('Invalid post-assessment choice').
