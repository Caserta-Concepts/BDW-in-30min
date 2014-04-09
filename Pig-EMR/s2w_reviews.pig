rmf $OUTPUT

in_generic = LOAD '$INPUT'
  USING PigStorage('|')
  AS (review_id:chararray,
      business_id:chararray,
      user_id:chararray,
      rating:float,
      review_date:chararray);

exp = FOREACH in_generic
  GENERATE 
    review_id,
    REPLACE(review_date,'-','') as review_date_id,
    business_id,
    user_id,
    rating,
    (rating >= 3 ? 1 : 0) as good_review_count,
    (rating < 3 ? 1 : 0) as bad_review_count;

STORE exp INTO '$OUTPUT'
  USING PigStorage('|');  
