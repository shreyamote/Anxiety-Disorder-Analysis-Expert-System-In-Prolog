% anxiety_kb.pl
% Improved knowledge base for anxiety disorders based on DSM-5 criteria

:- dynamic symptom/1.

% HELPER PREDICATES FOR SYMPTOM CHECKING
% ======================================

% Helper predicate to check if at least N items from a list are true
at_least_n([], 0) :- !.
at_least_n([H|T], N) :-
    (call(H) -> N1 is N - 1 ; N1 = N),
    at_least_n(T, N1).

% Specific helper for at least 3 symptoms
at_least_three(List) :- at_least_n(List, 3).

% Count how many symptoms from the list are present
count_symptoms([], 0).
count_symptoms([Symptom|Rest], Count) :-
    (symptom(Symptom) -> Count1 is 1 ; Count1 is 0),
    count_symptoms(Rest, RestCount),
    Count is Count1 + RestCount.

% DISORDERS DEFINITIONS
% =====================

% Generalized Anxiety Disorder (GAD)
disorder(generalized_anxiety_disorder, "Generalized Anxiety Disorder (GAD)", "A disorder characterized by persistent and excessive worry about a variety of topics that is difficult to control, lasting for at least 6 months, accompanied by physical or cognitive symptoms.") :-
    symptom(excessive_worry),
    symptom(difficulty_controlling_worry),
    symptom(duration_at_least_6_months),
    % Check for at least 3 of the following symptoms
    GAD_Symptoms = [
        symptom(restlessness),
        symptom(fatigue),
        symptom(difficulty_concentrating),
        symptom(irritability),
        symptom(muscle_tension),
        symptom(sleep_disturbance)
    ],
    count_symptoms([restlessness, fatigue, difficulty_concentrating, irritability, muscle_tension, sleep_disturbance], Count),
    Count >= 3,
    symptom(significant_distress_or_impairment),
    \+ symptom(due_to_substance),
    \+ symptom(due_to_medical_condition),
    \+ symptom(better_explained_by_other_disorder).

% Panic Disorder
disorder(panic_disorder, "Panic Disorder", "A condition characterized by recurrent unexpected panic attacks and persistent concern about having additional attacks or significant changes in behavior related to the attacks.") :-
    symptom(recurrent_panic_attacks),
    symptom(fear_of_additional_attacks),
    symptom(significant_behavior_change_due_to_attacks),
    symptom(significant_distress_or_impairment),
    \+ symptom(due_to_substance),
    \+ symptom(due_to_medical_condition).

% Social Anxiety Disorder (Social Phobia)
disorder(social_anxiety_disorder, "Social Anxiety Disorder (Social Phobia)", "Marked fear or anxiety about social situations in which the person is exposed to possible scrutiny by others, with fears of being negatively evaluated or showing anxiety symptoms that will be embarrassing.") :-
    symptom(fear_of_social_situations),
    symptom(fear_of_negative_evaluation),
    symptom(social_situations_always_provoke_fear),
    symptom(social_situations_avoided_or_endured_with_distress),
    symptom(fear_out_of_proportion),
    symptom(duration_at_least_6_months),
    symptom(significant_distress_or_impairment),
    \+ symptom(due_to_substance),
    \+ symptom(due_to_medical_condition),
    \+ symptom(better_explained_by_other_disorder).

% Specific Phobia
disorder(specific_phobia, "Specific Phobia", "Marked fear or anxiety about a specific object or situation that almost always provokes immediate fear and is actively avoided or endured with intense distress.") :-
    symptom(fear_of_specific_object_or_situation),
    symptom(object_or_situation_always_provokes_fear),
    symptom(object_or_situation_avoided_or_endured_with_distress),
    symptom(fear_out_of_proportion),
    symptom(duration_at_least_6_months),
    symptom(significant_distress_or_impairment),
    \+ symptom(better_explained_by_other_disorder).

% Agoraphobia
disorder(agoraphobia, "Agoraphobia", "Intense fear or anxiety triggered by actual or anticipated exposure to situations where escape might be difficult or help might not be available if panic symptoms or other embarrassing symptoms occur.") :-
    symptom(fear_of_two_or_more_agoraphobic_situations),
    symptom(situations_avoided_or_require_companion),
    symptom(fear_of_no_escape_or_help),
    symptom(fear_out_of_proportion),
    symptom(duration_at_least_6_months),
    symptom(significant_distress_or_impairment),
    \+ symptom(better_explained_by_other_disorder).

% Separation Anxiety Disorder
disorder(separation_anxiety_disorder, "Separation Anxiety Disorder", "Developmentally inappropriate and excessive fear or anxiety concerning separation from attachment figures, lasting at least 4 weeks in children and 6 months in adults.") :-
    symptom(excessive_fear_of_separation),
    % Check for at least 3 separation anxiety symptoms
    SepAnx_Symptoms = [
        distress_when_separated,
        worry_about_losing_attachment_figures,
        worry_about_harm_to_attachment_figures,
        reluctance_to_go_out_due_to_separation_fear,
        fear_of_being_alone,
        reluctance_to_sleep_away_from_attachment_figures,
        separation_nightmares,
        physical_symptoms_when_separation_anticipated
    ],
    count_symptoms(SepAnx_Symptoms, Count),
    Count >= 3,
    symptom(duration_at_least_4_weeks_in_children_or_6_months_in_adults),
    symptom(significant_distress_or_impairment),
    \+ symptom(better_explained_by_other_disorder).

% Illness Anxiety Disorder
disorder(illness_anxiety_disorder, "Illness Anxiety Disorder", "Preoccupation with having or acquiring a serious illness, with minimal or no somatic symptoms present, and excessive health-related behaviors or maladaptive avoidance.") :-
    symptom(preoccupation_with_having_serious_illness),
    symptom(no_or_mild_somatic_symptoms),
    symptom(high_anxiety_about_health),
    symptom(excessive_health_related_behaviors_or_avoidance),
    symptom(illness_preoccupation_duration_at_least_6_months),
    symptom(significant_distress_or_impairment),
    \+ symptom(better_explained_by_other_disorder).

% Obsessive-Compulsive Disorder (OCD)
disorder(obsessive_compulsive_disorder, "Obsessive-Compulsive Disorder (OCD)", "Presence of obsessions, compulsions, or both that are time-consuming or cause significant distress or impairment in functioning.") :-
    (symptom(obsessions) ; symptom(compulsions)),
    symptom(thoughts_recognized_as_product_of_own_mind),
    symptom(attempts_to_suppress_or_neutralize),
    symptom(time_consuming_or_significant_distress),
    symptom(significant_distress_or_impairment),
    \+ symptom(due_to_substance),
    \+ symptom(due_to_medical_condition),
    \+ symptom(better_explained_by_other_disorder).

% Post-Traumatic Stress Disorder (PTSD)
disorder(ptsd, "Post-Traumatic Stress Disorder (PTSD)", "A disorder that develops following exposure to a traumatic event, characterized by intrusion symptoms, avoidance, negative alterations in cognition and mood, and alterations in arousal and reactivity.") :-
    symptom(exposure_to_traumatic_event),
    symptom(intrusion_symptoms),
    symptom(avoidance),
    symptom(negative_alterations_in_cognition_and_mood),
    symptom(alterations_in_arousal_and_reactivity),
    symptom(duration_more_than_1_month),
    symptom(significant_distress_or_impairment),
    \+ symptom(due_to_substance),
    \+ symptom(due_to_medical_condition).

% RECOMMENDATIONS
% ==============

% Recommendations based on disorders
recommendation(generalized_anxiety_disorder, [
    'Consult with a psychiatrist or psychologist for a comprehensive assessment and diagnosis confirmation',
    'Consider Cognitive Behavioral Therapy (CBT) which has strong evidence for GAD treatment',
    'Learn mindfulness meditation and progressive muscle relaxation techniques',
    'Discuss medication options with a psychiatrist (SSRIs like escitalopram or SNRIs like duloxetine are common)',
    'Establish regular sleep patterns and exercise routine (30 minutes of moderate activity most days)',
    'Reduce caffeine and alcohol consumption which can worsen anxiety symptoms',
    'Join a support group for people with anxiety disorders',
    'Consider using smartphone apps designed for anxiety management (like Calm, Headspace, or Woebot)',
    'Practice worry time - scheduling specific times to address worries rather than throughout the day'
]).

recommendation(panic_disorder, [
    'Seek evaluation from a mental health professional specializing in anxiety disorders',
    'Consider Cognitive Behavioral Therapy with particular focus on interoceptive exposure',
    'Learn and practice diaphragmatic breathing and other panic management techniques',
    'Discuss medication options with your doctor (SSRIs or benzodiazepines for acute attacks)',
    'Keep a panic diary to identify triggers and monitor progress',
    'Gradually expose yourself to feared sensations in a safe environment',
    'Avoid caffeine, alcohol, and nicotine which can trigger panic symptoms',
    'Join a support group for people with panic disorder',
    'Download a panic management app with guided exercises for when attacks occur'
]).

recommendation(social_anxiety_disorder, [
    'Consult with a mental health professional who specializes in anxiety disorders',
    'Consider Cognitive Behavioral Therapy with gradual exposure to feared social situations',
    'Participate in social skills training or assertiveness training',
    'Discuss medication options with a psychiatrist (SSRIs are first-line pharmacological treatment)',
    'Consider group therapy specifically designed for social anxiety',
    'Practice mindfulness techniques to stay present during social interactions',
    'Start with small, manageable social goals and gradually increase difficulty',
    'Join Toastmasters or similar groups to practice public speaking in a supportive environment',
    'Use role-playing exercises to prepare for challenging social situations'
]).

recommendation(specific_phobia, [
    'Seek help from a psychologist trained in exposure therapy',
    'Participate in systematic desensitization or exposure therapy (the gold standard treatment)',
    'Consider Cognitive Behavioral Therapy to address fearful thoughts',
    'Ask about virtual reality exposure therapy which is effective for some phobias',
    'Learn relaxation and breathing techniques to manage anxiety during exposures',
    'Create a fear hierarchy with your therapist to approach the phobia gradually',
    'Practice self-exposure exercises between therapy sessions',
    'Consider joining a support group for people with similar phobias',
    'Medication is generally not first-line but may be used in specific cases'
]).

recommendation(agoraphobia, [
    'Seek comprehensive assessment by a mental health professional experienced with anxiety disorders',
    'Participate in Cognitive Behavioral Therapy with gradual exposure to feared situations',
    'Discuss medication options with a psychiatrist (SSRIs are commonly prescribed)',
    'Learn panic management techniques for use during exposure practices',
    'Start with easier situations and gradually work toward more challenging ones',
    'Consider family therapy to address accommodation behaviors',
    'Use technology (virtual reality) for initial exposure work if available',
    'Practice regular relaxation and mindfulness techniques',
    'Join a support group for people with agoraphobia'
]).

recommendation(separation_anxiety_disorder, [
    'Seek evaluation by a mental health professional who specializes in anxiety disorders',
    'Consider family-based cognitive behavioral therapy approaches',
    'Practice gradual separations in a supportive context',
    'For children: coordinate with school personnel for consistent intervention',
    'Create a clear separation ritual to reduce uncertainty',
    'Use technology (video calls) to maintain contact during separations',
    'Practice relaxation techniques before and during separations',
    'Discuss medication options with a psychiatrist for severe cases',
    'Maintain consistent routines to increase sense of security'
]).

recommendation(illness_anxiety_disorder, [
    'Consult with a mental health professional who specializes in health anxiety',
    'Participate in Cognitive Behavioral Therapy focusing on health-related beliefs',
    'Consider acceptance and commitment therapy approaches',
    'Establish a schedule for regular but limited medical check-ups with one trusted provider',
    'Learn to recognize and challenge catastrophic health thoughts',
    'Practice mindfulness to reduce focus on bodily sensations',
    'Gradually reduce checking and reassurance-seeking behaviors',
    'Discuss medication options with a psychiatrist if anxiety is severe',
    'Join a support group for people with health anxiety'
]).

recommendation(obsessive_compulsive_disorder, [
    'Seek specialized treatment from an OCD-experienced mental health professional',
    'Participate in Exposure and Response Prevention therapy (ERP), the gold standard for OCD',
    'Consider medication options (SSRIs at higher doses than typically used for depression)',
    'Join the International OCD Foundation for resources and support',
    'Practice mindfulness techniques to reduce fusion with obsessive thoughts',
    'Engage family members in treatment to reduce accommodation of symptoms',
    'Use smartphone apps designed specifically for OCD management',
    'Consider intensive outpatient or residential treatment for severe cases',
    'Join a support group for people with OCD and their families'
]).

recommendation(ptsd, [
    'Consult with a trauma-informed mental health professional',
    'Consider evidence-based trauma therapies: Prolonged Exposure, Cognitive Processing Therapy, or EMDR',
    'Discuss medication options with a psychiatrist (SSRIs are first-line)',
    'Learn grounding techniques for managing flashbacks and dissociation',
    'Establish safety planning for managing triggers and nightmares',
    'Practice regular relaxation and stress management techniques',
    'Consider group therapy with other trauma survivors',
    'Engage in regular physical activity which can help reduce hyperarousal',
    'Use smartphone apps designed for PTSD symptom management'
]).

% SYMPTOM DESCRIPTIONS
% ===================

% Symptom descriptions for user interface
symptom_description(excessive_worry, "Excessive worry about various topics", 
    "You worry significantly about many different things (work, health, family, finances, etc.) most days").

symptom_description(difficulty_controlling_worry, "Difficulty controlling worry", 
    "You find it hard to stop worrying or to control the worry once it starts").

symptom_description(duration_at_least_6_months, "Duration of at least 6 months", 
    "These worry symptoms have been present for at least 6 months").

symptom_description(restlessness, "Restlessness or feeling on edge", 
    "You often feel restless, keyed up, or on edge").

symptom_description(fatigue, "Easily fatigued", 
    "You become tired easily, even without much physical exertion").

symptom_description(difficulty_concentrating, "Difficulty concentrating", 
    "You have trouble concentrating or your mind goes blank").

symptom_description(irritability, "Irritability", 
    "You feel irritable more often than not").

symptom_description(muscle_tension, "Muscle tension", 
    "You experience tension in your muscles (such as jaw clenching, shoulder tension, back pain)").

symptom_description(sleep_disturbance, "Sleep disturbance", 
    "You have trouble falling asleep, staying asleep, or have restless, unsatisfying sleep").

symptom_description(recurrent_panic_attacks, "Recurrent unexpected panic attacks", 
    "You experience sudden episodes of intense fear with physical symptoms (racing heart, sweating, shortness of breath, etc.) that come on unexpectedly").

symptom_description(fear_of_additional_attacks, "Fear of additional attacks", 
    "You worry about having additional panic attacks").

symptom_description(significant_behavior_change_due_to_attacks, "Significant behavior change due to attacks", 
    "You have changed your behavior because of the attacks (e.g., avoiding exercise, unfamiliar situations, or places where attacks occurred)").

symptom_description(fear_of_social_situations, "Fear of social situations", 
    "You fear social situations where you might be judged, embarrassed, or scrutinized by others").

symptom_description(fear_of_negative_evaluation, "Fear of negative evaluation", 
    "You worry about being embarrassed or humiliated, appearing anxious, or being rejected in social situations").

symptom_description(social_situations_always_provoke_fear, "Social situations almost always provoke fear", 
    "Social situations almost always cause you to feel anxious or fearful").

symptom_description(social_situations_avoided_or_endured_with_distress, "Social situations avoided or endured with distress", 
    "You avoid social situations or endure them with intense fear or anxiety").

symptom_description(fear_out_of_proportion, "Fear out of proportion", 
    "Your fear or anxiety is out of proportion to the actual threat posed by the situation").

symptom_description(fear_of_specific_object_or_situation, "Fear of specific object or situation", 
    "You have an intense fear of a specific object or situation (e.g., flying, heights, animals, receiving an injection, seeing blood)").

symptom_description(object_or_situation_always_provokes_fear, "Object or situation always provokes fear", 
    "The specific object or situation almost always causes immediate fear or anxiety").

symptom_description(object_or_situation_avoided_or_endured_with_distress, "Object or situation avoided or endured with distress", 
    "You actively avoid the specific object or situation, or endure it with intense fear or anxiety").

symptom_description(fear_of_two_or_more_agoraphobic_situations, "Fear of two or more agoraphobic situations", 
    "You fear two or more of the following: using public transportation, being in open spaces, being in enclosed places, standing in line or being in a crowd, or being outside of the home alone").

symptom_description(situations_avoided_or_require_companion, "Situations avoided or require companion", 
    "You avoid these situations, require a companion, or endure them with fear or anxiety").

symptom_description(fear_of_no_escape_or_help, "Fear of no escape or help", 
    "You fear these situations because you think escape might be difficult or help might not be available if you develop panic symptoms").

symptom_description(excessive_fear_of_separation, "Excessive fear of separation", 
    "You have significant fear or anxiety about being separated from people you are attached to").

symptom_description(distress_when_separated, "Distress when separated", 
    "You experience significant distress when separated from home or attachment figures").

symptom_description(worry_about_losing_attachment_figures, "Worry about losing attachment figures", 
    "You worry about losing major attachment figures or possible harm befalling them").

symptom_description(worry_about_harm_to_attachment_figures, "Worry about harm to attachment figures", 
    "You worry about something bad happening to your attachment figures (like illness, injury, disasters, or death)").

symptom_description(reluctance_to_go_out_due_to_separation_fear, "Reluctance to go out due to separation fear", 
    "You are reluctant or refuse to go out, away from home, to work, or elsewhere because of fear of separation").

symptom_description(fear_of_being_alone, "Fear of being alone", 
    "You are fearful or reluctant to be alone or without attachment figures").

symptom_description(reluctance_to_sleep_away_from_attachment_figures, "Reluctance to sleep away from attachment figures", 
    "You are reluctant or refuse to sleep away from home or to go to sleep without being near attachment figures").

symptom_description(separation_nightmares, "Separation nightmares", 
    "You have repeated nightmares about being separated from attachment figures").

symptom_description(physical_symptoms_when_separation_anticipated, "Physical symptoms when separation anticipated", 
    "You experience physical symptoms (headaches, stomachaches, nausea, vomiting) when separation occurs or is anticipated").

symptom_description(duration_at_least_4_weeks_in_children_or_6_months_in_adults, "Duration appropriate for age", 
    "These symptoms have lasted at least 4 weeks in children or 6 months in adults").

symptom_description(significant_distress_or_impairment, "Significant distress or impairment", 
    "These symptoms cause significant distress or impairment in your social, occupational, or other important areas of functioning").

symptom_description(due_to_substance, "Due to substance", 
    "These symptoms are due to the effects of a substance (medication, drug of abuse) or another medical condition").

symptom_description(due_to_medical_condition, "Due to medical condition", 
    "These symptoms are attributable to another medical condition (e.g., hyperthyroidism, cardiac disorders)").

symptom_description(better_explained_by_other_disorder, "Better explained by other disorder", 
    "These symptoms are better explained by another mental disorder you've been diagnosed with").

symptom_description(preoccupation_with_having_serious_illness, "Preoccupation with having serious illness", 
    "You're preoccupied with having or acquiring a serious illness").

symptom_description(no_or_mild_somatic_symptoms, "No or mild somatic symptoms", 
    "You have no or only mild physical symptoms").

symptom_description(high_anxiety_about_health, "High anxiety about health", 
    "You have a high level of anxiety about health").

symptom_description(excessive_health_related_behaviors_or_avoidance, "Excessive health behaviors or avoidance", 
    "You perform excessive health-related behaviors (checking body for signs of illness) or maladaptive avoidance").

symptom_description(illness_preoccupation_duration_at_least_6_months, "Illness preoccupation for 6+ months", 
    "Preoccupation with illness has been present for at least 6 months").

symptom_description(obsessions, "Obsessions", 
    "You experience recurrent and persistent thoughts, urges, or images that are intrusive and unwanted").

symptom_description(compulsions, "Compulsions", 
    "You feel driven to perform repetitive behaviors or mental acts in response to an obsession or according to rigid rules").

symptom_description(thoughts_recognized_as_product_of_own_mind, "Recognition that thoughts come from own mind", 
    "You recognize that these obsessional thoughts come from your own mind").

symptom_description(attempts_to_suppress_or_neutralize, "Attempts to suppress or neutralize", 
    "You try to ignore, suppress, or neutralize these thoughts with some other thought or action").

symptom_description(time_consuming_or_significant_distress, "Time consuming or significant distress", 
    "These obsessions or compulsions are time-consuming (more than 1 hour per day) or cause significant distress").

symptom_description(exposure_to_traumatic_event, "Exposure to traumatic event", 
    "You have been exposed to death, threatened death, actual or threatened serious injury, or actual or threatened sexual violence").

symptom_description(intrusion_symptoms, "Intrusion symptoms", 
    "You experience intrusive memories, nightmares, flashbacks, or psychological distress to trauma reminders").

symptom_description(avoidance, "Avoidance", 
    "You persistently avoid distressing memories, thoughts, feelings, or external reminders associated with the trauma").

symptom_description(negative_alterations_in_cognition_and_mood, "Negative alterations in cognition and mood", 
    "You experience negative beliefs about yourself or the world, distorted blame, persistent negative emotions, diminished interest, feeling detached, or inability to experience positive emotions").

symptom_description(alterations_in_arousal_and_reactivity, "Alterations in arousal and reactivity", 
    "You experience irritable behavior, recklessness, hypervigilance, exaggerated startle response, problems with concentration, or sleep disturbance").

symptom_description(duration_more_than_1_month, "Duration more than 1 month", 
    "These symptoms have lasted more than 1 month").

% Severity assessment questions
severity_question(frequency, "How often do you experience these symptoms?",
    ["Rarely (once a week or less)", "Sometimes (several times a week)", "Often (daily)", "Almost constantly (multiple times per day)"]).

severity_question(intensity, "How intense are your symptoms when they occur?",
    ["Mild (noticeable but manageable)", "Moderate (uncomfortable but can function)", "Severe (very distressing, hard to function)", "Extreme (overwhelming, cannot function)"]).

severity_question(impairment, "How much do these symptoms interfere with your daily life?",
    ["Minimal impact", "Some interference with activities", "Significant interference with work/social life", "Unable to perform normal activities"]).

severity_question(duration, "How long have you been experiencing these symptoms?",
    ["Less than 1 month", "1-6 months", "6-12 months", "More than 1 year"]).

severity_question(coping, "How well are you able to cope with these symptoms?",
    ["Very well (manage symptoms effectively)", "Fairly well (some coping strategies)", "Struggling (difficult to cope)", "Not coping at all (overwhelmed)"]).
