#!/bin/bash

group_number=$1

echo $group_number

echo "ruby 7_TF_DF2.rb"

ruby 7_TF_DF2.rb $group_number

echo "ruby 8_VSM.rb"

ruby 8_VSM.rb $group_number

echo "ruby 9_VSM2"

ruby 9_VSM2.rb $group_number

echo "./11_logistic.r"

./11_logistic.r $group_number

echo "ruby 12_evaluation.rb"

ruby 12_evaluation.rb $group_number