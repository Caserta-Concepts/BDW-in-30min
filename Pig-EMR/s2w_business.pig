rmf $OUTPUT

REGISTER 's3://caserta-bucket1/libs/elephant-bird-pig.jar'
REGISTER 's3://caserta-bucket1/libs/elephant-bird-core.jar'
REGISTER 's3://caserta-bucket1/libs/elephant-bird-hadoop-compat.jar'
REGISTER 's3://caserta-bucket1/libs/json-simple.jar'


raw = LOAD '$INPUT' USING com.twitter.elephantbird.pig.load.JsonLoader('-nestedLoad');

exp = FOREACH raw
  generate $0#'business_id',
    REPLACE($0#'name','\\|','-') as name,
    $0#'city',
    $0#'state',
    $0#'longitude',
    $0#'latitude',
    $0#'categories';
  
STORE exp INTO '$OUTPUT' USING PigStorage('|');

--  business_id:chararray, 
--  full_address:chararray, 
--  open: chararray, 
--  categories:tuple(i:chararray), 
--  city:chararray, 
--  review_count:int, 
--  name:chararray, 
--  neighborhoods:tuple(i:chararray), 
--  longitude:float, 
--  state:chararray, 
--  stars:float, 
--  latitude:float, 
--  type:chararray
