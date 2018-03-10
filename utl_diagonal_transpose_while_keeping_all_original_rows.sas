Diagonal transpose while keeping all original rows

Original Topic: Is there an easy way to create duplicate variables in SAS?

github
https://tinyurl.com/y7qz7gmn
https://github.com/rogerjdeangelis/utl_diagonal_transpose_while_keeping_all_original_rows

see
https://tinyurl.com/ybl9umag
https://stackoverflow.com/questions/49141267/is-there-an-easy-way-to-create-duplicate-variables-in-sas


INPUT
=====

 WORK.HAVE total obs=9      |            RULES
                            |      Add these Variables
                    HOME_   |
  PRODUCT    DMA    SALES   |    HOME1    HOME2    HOME3
                            |
     A        1        1    |      1        0         0
     A        2        2    |      2        0         0
     A        3        3    |      3        0         0
                            |
     B        1        2    |      0        2         0
     B        2        4    |      0        4         0
     B        3        8    |      0        8         0
                            |
     C        1        4    |      0        0         4
     C        2        8    |      0        0         8
     C        3       16    |      0        0        16


PROCESS
=======

data want;

  * compile time meta data and array;
  if _n_=0 then do;
     %let rc=%sysfunc(dosubl('
         proc sql noprint;
             select count(distinct product) into :num_groups trimmed from have;
         quit;
     '));
     array homes(&num_groups.) home1-home&num_groups (&num_groups.*0);
  end;

  set have;

     by product;
     retain index 0;
     if first.product then index+1;
     homes[index]=home_sales;
     if index > 1 then homes[index-1]=0;

  drop index;
run;quit;


OUTPUT
======

 WORK.WANT total obs=9

                          HOME_
  PRODUCT    DMA    SALES      HOME1    HOME2    HOME3

     A        1        1         1        0         0
     A        2        2         2        0         0
     A        3        3         3        0         0
     B        1        2         0        2         0
     B        2        4         0        4         0
     B        3        8         0        8         0
     C        1        4         0        0         4
     C        2        8         0        0         8
     C        3       16         0        0        16

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

data want;

  * compile time meta data and array;
  if _n_=0 then do;
     %let rc=%sysfunc(dosubl('
         proc sql noprint;
             select count(distinct product) into :num_groups trimmed from have;
         quit;
     '));
     array homes(&num_groups.) home1-home&num_groups (&num_groups.*0);
  end;

  set have;

     by product;
     retain index 0;
     if first.product then index+1;
     homes[index]=home_sales;
     if index > 1 then homes[index-1]=0;

  drop index;
run;quit;

