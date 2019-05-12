--creates euctr_april19.csv
--BigQuery Standard SQL
  
SELECT
  eudract_number,
  eudract_number_with_country,
  REGEXP_EXTRACT(eudract_number_with_country, '-([^-]+)$') AS trial_location,
  date_of_competent_authority_decision,
  date_of_ethics_committee_opinion,
  date_on_which_this_record_was_first_entered_in_the_eudract_data,
  CASE
    WHEN trial_human_pharmacology_phase_i = TRUE AND trial_therapeutic_exploratory_phase_ii = FALSE THEN 1
    ELSE 0
  END AS phase_1
FROM
  `euctr.euctr_2019_05_01`