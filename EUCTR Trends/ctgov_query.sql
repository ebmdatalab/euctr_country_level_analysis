--Extracts relevant fields from our JSON dump of ClinicalTrials.gov

SELECT
  TRIM(json_EXTRACT(json,
      "$.clinical_study.id_info.nct_id"), '"') AS nct_id,
  TRIM(json_EXTRACT(json,
      "$.clinical_study.overall_status"), '"') AS study_status,
  TRIM(json_EXTRACT(json,
      "$.clinical_study.study_type"), '"') AS study_type,
  CASE
    WHEN json_EXTRACT(json,  "$.clinical_study.start_date.text") IS NOT NULL THEN (IF(REGEXP_CONTAINS(JSON_EXTRACT_SCALAR(json,  "$.clinical_study.start_date.text"), r"\d,"),  PARSE_DATE("%B %e, %Y",  JSON_EXTRACT_SCALAR(json,  "$.clinical_study.start_date.text")),  DATE_SUB(DATE_ADD(PARSE_DATE("%B %Y",  JSON_EXTRACT_SCALAR(json,  "$.clinical_study.start_date.text")), INTERVAL 1 MONTH), INTERVAL 1 DAY)))
    ELSE (IF(REGEXP_CONTAINS(JSON_EXTRACT_SCALAR(json,
          "$.clinical_study.start_date"), r"\d,"),
      PARSE_DATE("%B %e, %Y",
        JSON_EXTRACT_SCALAR(json,
          "$.clinical_study.start_date")),
      DATE_SUB(DATE_ADD(PARSE_DATE("%B %Y",
            JSON_EXTRACT_SCALAR(json,
              "$.clinical_study.start_date")), INTERVAL 1 MONTH), INTERVAL 1 DAY)))
  END AS start_date,
  PARSE_DATE("%B %e, %Y",
    TRIM(json_EXTRACT(json,
        "$.clinical_study.study_first_submitted"),'"')) AS submitted_date,
  TRIM(json_EXTRACT(json,
      "$.clinical_study.location_countries"), '"') AS location,
  TRIM(TRIM(json_EXTRACT(json,
        "$.clinical_study.phase"), '"')) AS phase
FROM
  `clinicaltrials.today`