#!/bin/bash
# Script to insert data from courses.csv and students.csv into students database

PSQL="psql -X --username=freecodecamp --dbname=students --no-align --tuples-only -c"

# First, clear all the existing data from 4 tables
echo $($PSQL "TRUNCATE students, majors, courses, majors_courses")

# Read the file courses_test.csv into SQL related tables
cat courses_test.csv | while IFS="," read MAJOR COURSE
do
  # Skip the 1st line - the title line
  if [[ $MAJOR != "major" ]]
  then
    # get major_id
    MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")
    # if the major_id not found or undefined
    if [[ -z $MAJOR_ID ]]
    then
      # insert major
      INSERT_MAJOR_RESULT=$($PSQL "INSERT INTO majors(major) VALUES('$MAJOR')")
      if [[ $INSERT_MAJOR_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into majors, $MAJOR
      fi
      # get new major_id
      MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")
      fi
    fi


  # Skip the 1st line - the title line
  if [[ $COURSE != "course" ]]
  then
    # get course_id
    COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")
    # if not found
    if [[ -z $COURSE_ID ]]
    then
    # insert course
    INSERT_COURSE_RESULT=$($PSQL "INSERT INTO courses(course) VALUES('$COURSE')")
      if [[ $INSERT_COURSE_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into courses, $COURSE
      fi
    # get new course_id
    COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")
    fi
      # insert into majors_courses
      INSERT_MAJORS_COURSES_RESULT=$($PSQL "INSERT INTO majors_courses(major_id, course_id) VALUES($MAJOR_ID, $COURSE_ID)")
      if [[ $INSERT_MAJORS_COURSES_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into majors_courses, $MAJOR : $COURSE"
      fi
  fi
done
