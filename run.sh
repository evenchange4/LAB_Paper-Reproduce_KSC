#!/bin/bash
group_number=$1

ruby 6_TF_DF.rb
ruby 7_TF_DF2.rb $group_number
ruby 8_VSM.rb $group_number
ruby 9_VSM2.rb $group_number
./11_logistic.r $group_number
ruby 12_evaluation.rb $group_number